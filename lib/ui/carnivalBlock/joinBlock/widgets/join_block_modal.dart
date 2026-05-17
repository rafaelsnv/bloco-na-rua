import 'package:bloco_na_rua/data/repositories/carnivalBlockMembers/icarnival_block_members_repository.dart';
import 'package:bloco_na_rua/data/repositories/carnivalBlocks/icarnival_blocks_repository.dart';
import 'package:bloco_na_rua/domain/use_cases/auth/get_current_user_data.dart';
import 'package:bloco_na_rua/routing/routes.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/joinBlock/cubit/join_block_cubit.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/joinBlock/cubit/join_block_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class JoinBlockModal extends StatefulWidget {
  const JoinBlockModal({super.key});

  @override
  State<JoinBlockModal> createState() => _JoinBlockModalState();
}

class _JoinBlockModalState extends State<JoinBlockModal> {
  final _inviteCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _inviteCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JoinBlockCubit(
        carnivalBlocksRepository: context.read<ICarnivalBlocksRepository>(),
        carnivalBlockMembersRepository: context
            .read<ICarnivalBlockMembersRepository>(),
        getCurrentUserData: context.read<GetCurrentUserData>(),
      ),
      child: BlocConsumer<JoinBlockCubit, JoinBlockState>(
        listener: (context, state) {
          if (state is JoinBlockSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(
                      Icons.celebration,
                      color: Theme.of(context).colorScheme.onError,
                    ),
                    const SizedBox(width: 8),
                    const Text('Você entrou no bloco com sucesso!'),
                  ],
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                behavior: SnackBarBehavior.floating,
              ),
            );
            context.go(Routes.home);
          } else if (state is JoinBlockError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(
                      Icons.error,
                      color: Theme.of(context).colorScheme.onError,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(state.message)),
                  ],
                ),
                backgroundColor: Theme.of(context).colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          final colorScheme = Theme.of(context).colorScheme;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Entrar em um bloco',
                style: TextStyle(color: colorScheme.onSurface),
              ),
              backgroundColor: colorScheme.surface,
              leading: IconButton(
                icon: Icon(Icons.close, color: colorScheme.onSurface),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(Routes.home);
                  }
                },
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
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
                        Icons.group_add,
                        size: 60,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Entre em um bloco',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Insira o código de convite para participar de um bloco existente.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    // Input field
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _inviteCodeController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.vpn_key,
                            color: colorScheme.primary,
                          ),
                          labelText: 'Código de convite',
                          labelStyle: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          hintText: 'Ex: ABC123',
                          hintStyle: TextStyle(color: colorScheme.outline),
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
                          fontSize: 18,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                        textCapitalization: TextCapitalization.characters,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Digite o código de convite';
                          }
                          if (value.trim().length < 4) {
                            return 'Código muito curto';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: state is JoinBlockLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  final code = _inviteCodeController.text
                                      .trim()
                                      .toUpperCase();
                                  context.read<JoinBlockCubit>().joinBlock(
                                    code,
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primaryContainer,
                          foregroundColor: colorScheme.onPrimaryContainer,
                          disabledBackgroundColor:
                              colorScheme.surfaceContainerHighest,
                          disabledForegroundColor: colorScheme.outline,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: state is JoinBlockLoading
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.login),
                                  SizedBox(width: 8),
                                  Text(
                                    'Entrar no bloco',
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
            backgroundColor: colorScheme.surface,
          );
        },
      ),
    );
  }
}
