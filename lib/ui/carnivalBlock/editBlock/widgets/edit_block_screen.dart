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
              title: const Text(
                'Editar Bloco',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.grey[850],
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.pop(),
              ),
            ),
            body: _buildBody(context, state),
            backgroundColor: Colors.grey[900],
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
            Text(state.message, style: const TextStyle(color: Colors.red)),
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
              labelStyle: const TextStyle(color: Colors.white70),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[700]!),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.purpleAccent),
              ),
            ),
            style: const TextStyle(color: Colors.white),
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
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  )
                else
                  Container(
                    height: 150,
                    width: 200,
                    color: Colors.grey.shade700,
                    child: const Icon(
                      Icons.account_circle,
                      size: 100,
                      color: Colors.grey,
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
                    backgroundColor: Colors.purpleAccent.shade100,
                    foregroundColor: Colors.black,
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
                backgroundColor: Colors.purpleAccent.shade100,
                foregroundColor: Colors.black,
                minimumSize: const Size(150, 50),
              ),
              child: isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
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
