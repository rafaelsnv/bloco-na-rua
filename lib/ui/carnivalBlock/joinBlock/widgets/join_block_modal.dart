// lib/ui/carnivalBlock/joinBlock/widgets/join_block_modal.dart
//
// Bloco na Rua design system — Join Block Modal screen.
//
// Pattern: Modal with invite code input.
// Uses JoinBlockCubit for state management.

import "package:bloco_na_rua/data/repositories/carnivalBlockMembers/icarnival_block_members_repository.dart";
import "package:bloco_na_rua/data/repositories/carnivalBlocks/icarnival_blocks_repository.dart";
import "package:bloco_na_rua/domain/use_cases/auth/get_current_user_data.dart";
import "package:bloco_na_rua/ui/carnivalBlock/joinBlock/cubit/join_block_cubit.dart";
import "package:bloco_na_rua/ui/carnivalBlock/joinBlock/cubit/join_block_state.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_button.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_card.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_snackbar.dart";
import "package:bloco_na_rua/ui/core/widgets/inputs/app_text_field.dart";
import "package:bloco_na_rua/ui/core/widgets/navigation/app_app_bar.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";

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

  void _submit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final code = _inviteCodeController.text.trim().toUpperCase();
      context.read<JoinBlockCubit>().joinBlock(code);
    }
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
            AppSnackbar.success(context, message: "Você entrou no bloco!");
            context.pop();
          } else if (state is JoinBlockError) {
            AppSnackbar.error(context, message: state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is JoinBlockLoading;
          final codeIsEmpty = _inviteCodeController.text.trim().isEmpty;

          return Scaffold(
            appBar: const AppAppBar(
              title: "Entrar em bloco",
              showBackButton: true,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Spacing.space_md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: Spacing.space_lg),
                    // Icon illustration
                    Center(
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer
                              .withValues(
                                alpha: MediaQuery.disableAnimationsOf(context)
                                    ? 1.0
                                    : 0.85,
                              ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.group_add_rounded,
                          size: 48,
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: Spacing.space_lg),
                    // Description text
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Entre em um bloco",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: Spacing.space_xs),
                          Text(
                            "Peça o código de convite ao dono do bloco para entrar.",
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Spacing.space_lg),
                    // Invite code form
                    Form(
                      key: _formKey,
                      child: AppTextField(
                        controller: _inviteCodeController,
                        label: "Código de convite",
                        hint: "Cole aqui o código",
                        prefixIcon: Icons.vpn_key_rounded,
                        autofocus: true,
                        textInputAction: TextInputAction.done,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r"[A-Za-z0-9]"),
                          ),
                          _UpperCaseTextFormatter(),
                        ],
                        onSubmitted: (_) => _submit(context),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Digite o código de convite";
                          }
                          if (value.trim().length < 4) {
                            return "Código muito curto";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: Spacing.space_lg),
                    // Submit button
                    AppButton(
                      label: "Entrar",
                      variant: AppButtonVariant.primary,
                      isFullWidth: true,
                      isLoading: isLoading,
                      isDisabled: codeIsEmpty,
                      onPressed: () => _submit(context),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A [TextInputFormatter] that converts all input to uppercase letters.
class _UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}

// Spacing token reference for this file:
// Spacing.space_md = 24.0 (page padding)
// Spacing.space_lg = 32.0 (section gaps)
// Spacing.space_xs = 12.0 (small gaps)
