import "package:bloco_na_rua/core/api_error.dart";
import "package:bloco_na_rua/core/errors/user_message.dart";
import "package:bloco_na_rua/data/services/auth/models/signup_request/signup_request.dart";
import "package:bloco_na_rua/l10n/app_localizations.dart";
import "package:bloco_na_rua/routing/routes.dart";
import "package:bloco_na_rua/ui/auth/cubit/auth_cubit.dart";
import "package:bloco_na_rua/ui/auth/cubit/auth_state.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_button.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_card.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_snackbar.dart";
import "package:bloco_na_rua/ui/core/widgets/inputs/app_text_field.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";
import "package:brasil_fields/brasil_fields.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _phone = TextEditingController();

  /// Fields the user has already edited.
  ///
  /// Only these may paint an error before the first submit attempt — a
  /// pristine field the user never touched stays neutral.
  bool _nameTouched = false;
  bool _emailTouched = false;
  bool _passwordTouched = false;
  bool _phoneTouched = false;

  /// True once the user tried to submit.
  ///
  /// From then on every invalid field shows its error, and the form is
  /// re-validated on every edit so the errors stay in sync.
  bool _submitAttempted = false;

  bool _isValidEmail(String value) {
    final trimmed = value.trim();
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(trimmed);
  }

  /// Error message for the name field, or null when the value is valid.
  String? _nameValidator(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.signupNameRequired;
    }
    return null;
  }

  /// Error message for the e-mail field, or null when the value is valid.
  String? _emailValidator(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.signupEmailRequired;
    }
    if (!_isValidEmail(value)) {
      return l10n.signupEmailInvalid;
    }
    return null;
  }

  /// Error message for the password field, or null when the value is valid.
  String? _passwordValidator(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.signupPasswordRequired;
    }
    if (value.length < 8) {
      return l10n.signupPasswordMinLength;
    }
    return null;
  }

  /// Error message for the phone field, or null when the value is valid.
  String? _phoneValidator(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.signupPhoneRequired;
    }
    if (value.length < 14) {
      return l10n.signupPhoneInvalid;
    }
    return null;
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _phone.dispose();
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

  void _onNameChanged(String _) {
    setState(() => _nameTouched = true);
    _syncForm();
  }

  void _onEmailChanged(String _) {
    setState(() => _emailTouched = true);
    _syncForm();
  }

  void _onPasswordChanged(String _) {
    setState(() => _passwordTouched = true);
    _syncForm();
  }

  void _onPhoneChanged(String _) {
    setState(() => _phoneTouched = true);
    _syncForm();
  }

  void _submit() {
    setState(() => _submitAttempted = true);
    if (_formKey.currentState?.validate() ?? false) {
      final signUpData = SignUpRequest(
        name: _name.text,
        email: _email.text,
        password: _password.text,
        // Backend validates digits-only phone; strip the display mask "(11) 98765-4321".
        phone: _phone.text.replaceAll(RegExp(r'\D'), ''),
      );
      context.read<AuthCubit>().signUp(signUpData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          final apiError = state.error is ApiError
              ? state.error! as ApiError
              : null;
          final message = apiError?.statusCode == 409
              ? l10n.signupEmailInUse
              : extractUserMessage(state.error, context);
          AppSnackbar.error(context, message: message);
        } else if (state is AuthAuthenticated) {
          context.go(Routes.home);
        } else if (state is AuthSuccess) {
          AppSnackbar.success(context, message: state.localizedMessage(l10n));
          if (state.kind == AuthSuccessKind.accountCreated) {
            context.go(Routes.login);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          leading: Semantics(
            label: l10n.authBackButton,
            button: true,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              tooltip: l10n.authBackButton,
              onPressed: () => context.go(Routes.login),
            ),
          ),
          title: Text(l10n.authAppTitle),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.pagePaddingMobile),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.signupTitle,
                    style: AppTypography.displaySmall.copyWith(
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(height: Spacing.space_xs),
                  Text(
                    l10n.signupSubtitle,
                    style: AppTypography.bodyLarge.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: Spacing.space_xl),
                  AppCard(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextField(
                            label: l10n.signupNameLabel,
                            controller: _name,
                            prefixIcon: Icons.person_rounded,
                            validator: (value) => _nameValidator(value, l10n),
                            errorText: _nameTouched
                                ? _nameValidator(_name.text, l10n)
                                : null,
                            onChanged: _onNameChanged,
                          ),
                          const SizedBox(height: Spacing.space_sm),
                          AppTextField(
                            label: l10n.signupEmailLabel,
                            controller: _email,
                            prefixIcon: Icons.email_rounded,
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: const [AutofillHints.email],
                            validator: (value) => _emailValidator(value, l10n),
                            errorText: _emailTouched
                                ? _emailValidator(_email.text, l10n)
                                : null,
                            onChanged: _onEmailChanged,
                          ),
                          const SizedBox(height: Spacing.space_sm),
                          AppTextField(
                            label: l10n.signupPasswordLabel,
                            controller: _password,
                            prefixIcon: Icons.lock_rounded,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            autofillHints: const [AutofillHints.newPassword],
                            // A password is never autocorrected or suggested.
                            autocorrect: false,
                            enableSuggestions: false,
                            helperText: l10n.signupPasswordHelper,
                            validator: (value) =>
                                _passwordValidator(value, l10n),
                            errorText: _passwordTouched
                                ? _passwordValidator(_password.text, l10n)
                                : null,
                            onChanged: _onPasswordChanged,
                          ),
                          const SizedBox(height: Spacing.space_sm),
                          AppTextField(
                            controller: _phone,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              TelefoneInputFormatter(),
                            ],
                            label: l10n.signupPhoneLabel,
                            prefixIcon: Icons.phone_rounded,
                            validator: (value) => _phoneValidator(value, l10n),
                            errorText: _phoneTouched
                                ? _phoneValidator(_phone.text, l10n)
                                : null,
                            onChanged: _onPhoneChanged,
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
                                  label: l10n.signupSubmitButton,
                                  isLoading: true,
                                  isFullWidth: true,
                                  variant: AppButtonVariant.accent,
                                );
                              }

                              return AppButton(
                                label: l10n.signupSubmitButton,
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
                  Center(
                    child: TextButton(
                      onPressed: () => context.go(Routes.login),
                      child: Text(
                        l10n.signupLoginLink,
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyLarge.copyWith(
                          color: colors.primary,
                          decoration: TextDecoration.underline,
                        ),
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
