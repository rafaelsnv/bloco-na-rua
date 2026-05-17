import 'package:bloco_na_rua/data/repositories/carnivalBlockMembers/icarnival_block_members_repository.dart';
import 'package:bloco_na_rua/data/repositories/carnivalBlocks/icarnival_blocks_repository.dart';
import 'package:bloco_na_rua/domain/use_cases/auth/get_current_user_data.dart';
import 'package:bloco_na_rua/routing/routes.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/createBlock/cubit/create_block_cubit.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/createBlock/cubit/create_block_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreateBlockScreen extends StatefulWidget {
  const CreateBlockScreen({super.key});

  @override
  State<CreateBlockScreen> createState() => _CreateBlockScreenState();
}

class _CreateBlockScreenState extends State<CreateBlockScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (context) => CreateBlockCubit(
        carnivalBlocksRepository: context.read<ICarnivalBlocksRepository>(),
        carnivalBlockMembersRepository: context.read<ICarnivalBlockMembersRepository>(),
        getCurrentUserData: context.read<GetCurrentUserData>(),
      ),
      child: BlocConsumer<CreateBlockCubit, CreateBlockState>(
        listener: (context, state) {
          if (state is CreateBlockSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.celebration, color: colorScheme.onError),
                    const SizedBox(width: 8),
                    const Text('Bloco criado com sucesso!'),
                  ],
                ),
                backgroundColor: colorScheme.primary,
                behavior: SnackBarBehavior.floating,
              ),
            );
            context.go(Routes.home);
          } else if (state is CreateBlockError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.error, color: colorScheme.onError),
                    const SizedBox(width: 8),
                    Expanded(child: Text(state.message)),
                  ],
                ),
                backgroundColor: colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Criar novo bloco',
                style: TextStyle(color: colorScheme.onSurface),
              ),
              backgroundColor: colorScheme.surface,
              leading: IconButton(
                icon: Icon(Icons.close, color: colorScheme.onSurface),
                onPressed: () {
                  context.go(Routes.home);
                },
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // Illustration
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.celebration,
                          size: 60,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Crie seu bloco',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Dê um nome ao seu bloco de rua e comece a organizar!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      // Name input
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.celebration,
                            color: colorScheme.primary,
                          ),
                          labelText: 'Nome do bloco',
                          labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                          hintText: 'Ex: Bloco da Vizinhança',
                          hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7)),
                          filled: true,
                          fillColor: colorScheme.surfaceContainerHighest,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: colorScheme.error,
                              width: 2,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: colorScheme.error,
                              width: 2,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 16,
                        ),
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Digite um nome para o bloco';
                          }
                          if (value.trim().length < 3) {
                            return 'Nome muito curto';
                          }
                          if (value.trim().length > 50) {
                            return 'Nome muito longo';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      // Image picker placeholder
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorScheme.outline,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.add_photo_alternate,
                              size: 48,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Adicionar imagem do bloco',
                              style: TextStyle(color: colorScheme.onSurfaceVariant),
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton.icon(
                              onPressed: () {
                                // TO-DO: Implement image picker
ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'Em breve: seleção de imagem',
                                    ),
                                    backgroundColor: colorScheme.secondary,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.upload),
                              label: const Text('Selecionar'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: colorScheme.primary,
                                side: BorderSide(color: colorScheme.outline),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: state is CreateBlockLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    final name = _nameController.text.trim();
                                    context
                                        .read<CreateBlockCubit>()
                                        .createBlock(name);
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            disabledBackgroundColor: colorScheme.surfaceContainerHighest,
                            disabledForegroundColor: colorScheme.onSurfaceVariant,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: state is CreateBlockLoading
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: colorScheme.onPrimary,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_circle),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Criar bloco',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            backgroundColor: colorScheme.surface,
          );
        },
      ),
    );
  }
}