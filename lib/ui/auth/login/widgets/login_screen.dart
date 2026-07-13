// lib/ui/auth/login/widgets/login_screen.dart
//
// Login screen rebuilt with the Bloco na Rua design system.
//
// Uses design system primitives: AppTextField, AppButton, AppCard,
// AppSnackbar, and design tokens for all spacing, colors, and typography.

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

import "package:bloco_na_rua/routing/routes.dart";
import "package:bloco_na_rua/ui/auth/cubit/auth_cubit.dart";
import "package:bloco_na_rua/ui/auth/cubit/auth_state.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_button.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_card.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_snackbar.dart";
import "package:bloco_na_rua/ui/core/widgets/inputs/app_text_field.dart";
import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_radius.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final ValueNotifier<bool> _isFormValidNotifier = ValueNotifier<bool>(false);
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _email.addListener(_validateForm);
    _password.addListener(_validateForm);
    _validateForm();
  }

  @override
  void dispose() {
    _email.removeListener(_validateForm);
    _password.removeListener(_validateForm);
    _isFormValidNotifier.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _validateForm() {
    _isFormValidNotifier.value = _formKey.currentState?.validate() ?? false;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(_email.text, _password.text);
    }
  }

  void _showForgotPasswordDialog(BuildContext outerContext) {
    showDialog<bool>(
      context: outerContext,
      builder: (_) => _ForgotPasswordDialog(outerContext: outerContext),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          AppSnackbar.error(
            context,
            message: state.message.replaceAll("Exception: ", ""),
          );
        } else if (state is AuthAuthenticated) {
          context.go(Routes.home);
        } else if (state is AuthSuccess) {
          AppSnackbar.success(context, message: state.message ?? "Sucesso!");
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Bloco na Rua",
            style: AppTypography.displaySmall.copyWith(
              color: AppColors.primary,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.pagePaddingMobile),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header section
                  Icon(
                    Icons.celebration_rounded,
                    size: 80,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: Spacing.space_sm),
                  Text(
                    "Bem vindo",
                    style: AppTypography.displaySmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: Spacing.space_xs),
                  Text(
                    "Entre para gerenciar seu bloco",
                    style: AppTypography.bodyLarge.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: Spacing.space_xl),

                  // Form card
                  AppCard(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // E-mail field
                          AppTextField(
                            label: "E-mail",
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.email_rounded,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Por favor, insira um e-mail";
                              }
                              if (!value.contains("@")) {
                                return "E-mail inválido";
                              }
                              return null;
                            },
                            onChanged: (_) => _validateForm(),
                          ),

                          const SizedBox(height: Spacing.space_sm),

                          // Password field
                          AppTextField(
                            label: "Senha",
                            controller: _password,
                            keyboardType: TextInputType.visiblePassword,
                            prefixIcon: Icons.lock_rounded,
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Por favor, insira uma senha";
                              }
                              return null;
                            },
                            onChanged: (_) => _validateForm(),
                          ),

                          const SizedBox(height: Spacing.space_lg),

                          // Submit button
                          BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, state) {
                              if (state is AuthLoading) {
                                return const AppButton(
                                  label: "Entrar",
                                  isLoading: true,
                                  isFullWidth: true,
                                );
                              }

                              return ValueListenableBuilder<bool>(
                                valueListenable: _isFormValidNotifier,
                                builder: (context, isFormValid, child) {
                                  return AppButton(
                                    label: "Entrar",
                                    onPressed: isFormValid ? _submit : null,
                                    isDisabled: !isFormValid,
                                    isFullWidth: true,
                                    variant: AppButtonVariant.primary,
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: Spacing.space_md),

                  // Forgot password link
                  GestureDetector(
                    onTap: () => _showForgotPasswordDialog(context),
                    child: Text(
                      "Esqueceu a senha?",
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),

                  const SizedBox(height: Spacing.space_sm),

                  // Register link
                  GestureDetector(
                    onTap: () => context.go(Routes.register),
                    child: Text(
                      "Não tem uma conta? Cadastre-se",
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------------
// _ForgotPasswordDialog — custom dialog with email field for password reset.
// -------------------------------------------------------------------------

class _ForgotPasswordDialog extends StatefulWidget {
  const _ForgotPasswordDialog({required this.outerContext});

  final BuildContext outerContext;

  @override
  State<_ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<_ForgotPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isFormValid = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _formKey.currentState?.validate() ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: Radii.modal,
        ),
        padding: const EdgeInsets.all(Spacing.space_lg),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Esqueceu a senha?",
                style: AppTypography.headlineSmall.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Spacing.space_xs),
              Text(
                "Informe seu e-mail para receber o link de recuperacao.",
                style: AppTypography.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Spacing.space_lg),
              AppTextField(
                label: "E-mail",
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira um e-mail";
                  }
                  if (!value.contains("@")) {
                    return "E-mail inválido";
                  }
                  return null;
                },
                onChanged: (_) => _validateForm(),
              ),
              const SizedBox(height: Spacing.space_lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(
                    label: "Cancelar",
                    variant: AppButtonVariant.tertiary,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: Spacing.space_xs),
                  AppButton(
                    label: "Enviar",
                    variant: AppButtonVariant.primary,
                    isDisabled: !_isFormValid,
                    onPressed: !_isFormValid
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              widget.outerContext
                                  .read<AuthCubit>()
                                  .resetPassword(_emailController.text);
                              Navigator.of(context).pop();
                            }
                          },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
