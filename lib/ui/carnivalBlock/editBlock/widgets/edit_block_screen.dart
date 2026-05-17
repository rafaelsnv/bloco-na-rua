import 'package:bloco_na_rua/data/repositories/carnivalBlocks/icarnival_blocks_repository.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/editBlock/cubit/edit_block_cubit.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/editBlock/cubit/edit_block_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EditBlockScreen extends StatefulWidget {
  const EditBlockScreen({super.key, required this.carnivalBlockId});

  final String carnivalBlockId;

  @override
  State<EditBlockScreen> createState() => _EditBlockScreenState();
}

class _EditBlockScreenState extends State<EditBlockScreen> {
  final _nameController = TextEditingController();
  String _currentImage = '';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditBlockCubit(
        carnivalBlocksRepository: context.read<ICarnivalBlocksRepository>(),
        carnivalBlockId: widget.carnivalBlockId,
      ),
      child: BlocConsumer<EditBlockCubit, EditBlockState>(
        listener: (context, state) {
          if (state is EditBlockSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Bloco atualizado com sucesso')),
            );
            context.pop();
          } else if (state is EditBlockError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is EditBlockLoaded) {
            _nameController.text = state.name;
            _currentImage = state.carnivalBlockImage;
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Editar Bloco',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
              backgroundColor: Theme.of(context).colorScheme.surface,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
                onPressed: () => context.pop(),
              ),
            ),
            body: _buildBody(context, state),
            backgroundColor: Theme.of(context).colorScheme.surface,
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, EditBlockState state) {
    if (state is EditBlockLoading || state is EditBlockInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is EditBlockError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.message, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<EditBlockCubit>().loadBlock(),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    final isSaving = state is EditBlockSaving;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            enabled: !isSaving,
            decoration: InputDecoration(
              labelText: 'Nome do bloco',
              labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                if (_currentImage.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      _currentImage,
                      height: 150,
                      width: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(
                        height: 150,
                        width: 200,
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.image_not_supported,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    height: 150,
                    width: 200,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.account_circle,
                      size: 100,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () {
                          // Handle image selection
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  child: const Text('Alterar imagem'),
                ),
              ],
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomLeft,
            child: ElevatedButton(
              onPressed: isSaving
                  ? null
                  : () {
                      final name = _nameController.text.trim();
                      if (name.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Por favor, insira um nome para o bloco'),
                          ),
                        );
                        return;
                      }
                      context.read<EditBlockCubit>().updateBlock(
                        name: name,
                        carnivalBlockImage: _currentImage,
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                minimumSize: const Size(150, 50),
              ),
              child: isSaving
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    )
                  : const Text('Salvar alterações'),
            ),
          ),
        ],
      ),
    );
  }
}
