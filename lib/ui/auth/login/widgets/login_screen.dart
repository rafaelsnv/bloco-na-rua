import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

import "package:bloco_na_rua/core/api_error.dart";
import "package:bloco_na_rua/core/errors/user_message.dart";
import "package:bloco_na_rua/l10n/app_localizations.dart";
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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
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
  String? _emailValidator(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.loginEmailRequired;
    }
    if (!_isValidEmail(value)) {
      return l10n.loginEmailInvalid;
    }
    return null;
  }

  /// Error message for the password field, or null when the value is valid.
  String? _passwordValidator(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.loginPasswordRequired;
    }
    return null;
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  /// Keeps the painted error states in sync after an edit.
  void _syncForm() {
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
    final l10n = AppLocalizations.of(context)!;
    final email = _email.text.trim();
    if (email.isEmpty) {
      AppSnackbar.error(context, message: l10n.loginEmailRequired);
      return;
    }
    if (!_isValidEmail(email)) {
      AppSnackbar.error(context, message: l10n.loginEmailInvalid);
      return;
    }

    final confirmed = await AppDialog.confirm(
      context,
      title: l10n.loginForgotPassword,
      // The dialog has no input of its own — the address comes from the
      // e-mail field of the form behind it, so the message names it.
      message: l10n.loginRecoveryMessage(email),
      confirmLabel: l10n.loginSendButton,
      cancelLabel: l10n.loginCancel,
    );
    if (confirmed != true) return;
    if (!context.mounted) return;
    context.read<AuthCubit>().resetPassword(email);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          final message = state.error is ApiError &&
                  (state.error! as ApiError).statusCode == 401
              ? l10n.loginInvalidCredentials
              : extractUserMessage(state.error, context);
          AppSnackbar.error(context, message: message);
        } else if (state is AuthAuthenticated) {
          context.go(Routes.home);
        } else if (state is AuthSuccess) {
          AppSnackbar.success(context, message: state.localizedMessage(l10n));
        }
      },
      child: Scaffold(
        appBar: AppBar(centerTitle: false, title: Text(l10n.authAppTitle)),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.pagePaddingMobile),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header section
                  const AppLogo(size: AppIconSizes.illustration),
                  const SizedBox(height: Spacing.space_sm),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      l10n.loginTitle,
                      textAlign: TextAlign.left,
                      style: AppTypography.displaySmall.copyWith(
                        color: colors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: Spacing.space_xs),
                  Text(
                    l10n.loginSubtitle,
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
                            label: l10n.loginEmailLabel,
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: const [AutofillHints.email],
                            prefixIcon: Icons.email_rounded,
                            validator: (value) => _emailValidator(value, l10n),
                            errorText: _emailTouched
                                ? _emailValidator(_email.text, l10n)
                                : null,
                            onChanged: _onEmailChanged,
                          ),

                          const SizedBox(height: Spacing.space_sm),

                          // Password field
                          AppTextField(
                            label: l10n.loginPasswordLabel,
                            controller: _password,
                            keyboardType: TextInputType.visiblePassword,
                            prefixIcon: Icons.lock_rounded,
                            obscureText: _obscurePassword,
                            autofillHints: const [AutofillHints.password],
                            // A password is never autocorrected or suggested.
                            autocorrect: false,
                            enableSuggestions: false,
                            suffixIcon: Semantics(
                              label: _obscurePassword
                                  ? l10n.loginShowPassword
                                  : l10n.loginHidePassword,
                              button: true,
                              child: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                ),
                                tooltip: _obscurePassword
                                    ? l10n.loginShowPassword
                                    : l10n.loginHidePassword,
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) =>
                                _passwordValidator(value, l10n),
                            errorText: _passwordTouched
                                ? _passwordValidator(_password.text, l10n)
                                : null,
                            onChanged: _onPasswordChanged,
                            // The keyboard action submits the form too, so the
                            // last field is not a dead end.
                            onSubmitted: (_) => _submit(),
                          ),

                          const SizedBox(height: Spacing.space_lg),

                          // Submit button — always enabled. An invalid form is
                          // reported inline when the user submits, instead of
                          // a CTA that never becomes tappable.
                          BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, state) {
                              if (state is AuthLoading) {
                                return AppButton(
                                  label: l10n.loginEnterButton,
                                  isLoading: true,
                                  isFullWidth: true,
                                  variant: AppButtonVariant.accent,
                                );
                              }

                              return AppButton(
                                label: l10n.loginEnterButton,
                                onPressed: _submit,
                                isFullWidth: true,
                                variant: AppButtonVariant.accent,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: Spacing.space_md),

                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) => AppButton(
                      label: l10n.loginGoogleButton,
                      icon: const Icon(Icons.login_rounded),
                      onPressed: state is AuthLoading
                          ? null
                          : () => context.read<AuthCubit>().googleSignIn(),
                      isLoading: state is AuthLoading,
                      isFullWidth: true,
                      variant: AppButtonVariant.secondary,
                    ),
                  ),

                  // Forgot password link
                  TextButton(
                    onPressed: () => _handleForgotPassword(context),
                    child: Text(
                      l10n.loginForgotPassword,
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
                      l10n.loginRegisterLink,
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
