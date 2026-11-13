import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

import "package:bloco_na_rua/routing/routes.dart";
import "package:bloco_na_rua/ui/auth/cubit/auth_cubit.dart";
import "package:bloco_na_rua/ui/auth/cubit/auth_state.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_button.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_card.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_dialog.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_snackbar.dart";
import "package:bloco_na_rua/ui/core/widgets/inputs/app_text_field.dart";
import "package:bloco_na_rua/ui/core/widgets/display/app_logo.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";

/// Edge length of the brand mark on the sign-in screen.
const double _logoSize = 80;

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

  /// Fields the user has already edited.
  ///
  /// Only these may paint an error before the first submit attempt — a
  /// pristine field the user never touched stays neutral.
  bool _emailTouched = false;
  bool _passwordTouched = false;

  /// True once the user tried to submit.
  ///
  /// From then on every invalid field shows its error, and the form is
  /// re-validated on every edit so the errors stay in sync.
  bool _submitAttempted = false;

  bool _isValidEmail(String value) {
    final trimmed = value.trim();
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(trimmed);
  }

  /// Error message for the e-mail field, or null when the value is valid.
  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Por favor, insira um e-mail";
    }
    if (!_isValidEmail(value)) {
      return "E-mail inválido";
    }
    return null;
  }

  /// Error message for the password field, or null when the value is valid.
  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Por favor, insira uma senha";
    }
    return null;
  }

  @override
  void dispose() {
    _isFormValidNotifier.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  /// Recomputes the submit button state from the current field values.
  ///
  /// Deliberately does NOT call `Form.validate()`: validating the whole form
  /// while the user types would paint the error border on every field they
  /// have not touched yet.
  void _updateFormValidity() {
    final isValid =
        _emailValidator(_email.text) == null &&
        _passwordValidator(_password.text) == null;
    if (_isFormValidNotifier.value != isValid) {
      _isFormValidNotifier.value = isValid;
    }
  }

  /// Keeps the painted error states in sync after an edit.
  void _syncForm() {
    _updateFormValidity();
    if (_submitAttempted) {
      // After a submit attempt every invalid field shows its error, so the
      // whole form has to be re-validated on every edit.
      _formKey.currentState?.validate();
    }
  }

  void _onEmailChanged(String _) {
    setState(() => _emailTouched = true);
    _syncForm();
  }

  void _onPasswordChanged(String _) {
    setState(() => _passwordTouched = true);
    _syncForm();
  }

  void _submit() {
    setState(() => _submitAttempted = true);
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(_email.text, _password.text);
    }
  }

  Future<void> _handleForgotPassword(BuildContext context) async {
    final email = _email.text.trim();
    if (email.isEmpty) {
      AppSnackbar.error(context, message: "Por favor, insira um e-mail");
      return;
    }
    if (!_isValidEmail(email)) {
      AppSnackbar.error(context, message: "E-mail inválido");
      return;
    }

    final confirmed = await AppDialog.confirm(
      context,
      title: "Esqueceu a senha?",
      // The dialog has no input of its own — the address comes from the
      // e-mail field of the form behind it, so the message names it.
      message: "Enviaremos um link de recuperação para $email",
      confirmLabel: "Enviar",
      cancelLabel: "Cancelar",
    );
    if (confirmed != true) return;
    if (!context.mounted) return;
    context.read<AuthCubit>().resetPassword(email);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          AppSnackbar.error(context, message: state.message);
        } else if (state is AuthAuthenticated) {
          context.go(Routes.home);
        } else if (state is AuthSuccess) {
          AppSnackbar.success(context, message: state.message ?? "Sucesso!");
        }
      },
      child: Scaffold(
        appBar: AppBar(centerTitle: false, title: const Text("Bloco na Rua")),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.pagePaddingMobile),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header section
                  const AppLogo(size: _logoSize),
                  const SizedBox(height: Spacing.space_sm),
                  Text(
                    "Bem vindo",
                    style: AppTypography.displaySmall.copyWith(
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(height: Spacing.space_xs),
                  Text(
                    "Entre para organizar seu bloco",
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
                            validator: _emailValidator,
                            errorText: _emailTouched
                                ? _emailValidator(_email.text)
                                : null,
                            onChanged: _onEmailChanged,
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
                            validator: _passwordValidator,
                            errorText: _passwordTouched
                                ? _passwordValidator(_password.text)
                                : null,
                            onChanged: _onPasswordChanged,
                            // The submit button is disabled while the form is
                            // invalid, so the keyboard action is the only way
                            // to submit an invalid form: it shows every
                            // error instead of calling the API.
                            onSubmitted: (_) => _submit(),
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
                                  variant: AppButtonVariant.accent,
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
                                    variant: AppButtonVariant.accent,
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
                  TextButton(
                    onPressed: () => _handleForgotPassword(context),
                    child: Text(
                      "Esqueceu a senha?",
                      style: AppTypography.bodyLarge.copyWith(
                        color: colors.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),

                  const SizedBox(height: Spacing.space_sm),

                  // Register link
                  TextButton(
                    onPressed: () => context.go(Routes.register),
                    child: Text(
                      "Não tem uma conta? Cadastre-se",
                      style: AppTypography.bodyLarge.copyWith(
                        color: colors.primary,
                        decoration: TextDecoration.underline,
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
