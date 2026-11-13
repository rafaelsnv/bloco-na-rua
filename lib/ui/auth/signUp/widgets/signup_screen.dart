import "package:bloco_na_rua/data/services/auth/models/signup_request/signup_request.dart";
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
  final ValueNotifier<bool> _isFormValidNotifier = ValueNotifier<bool>(false);

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
  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Por favor, insira seu nome";
    }
    return null;
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
    if (value.length < 8) {
      return "A senha deve ter no mínimo 8 caracteres";
    }
    return null;
  }

  /// Error message for the phone field, or null when the value is valid.
  String? _phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Por favor, insira um telefone";
    }
    if (value.length < 14) {
      return "Telefone inválido";
    }
    return null;
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _phone.dispose();
    _isFormValidNotifier.dispose();
    super.dispose();
  }

  /// Recomputes the submit button state from the current field values.
  ///
  /// Deliberately does NOT call `Form.validate()`: validating the whole form
  /// while the user types would paint the error border on every field they
  /// have not touched yet.
  void _updateFormValidity() {
    final isValid =
        _nameValidator(_name.text) == null &&
        _emailValidator(_email.text) == null &&
        _passwordValidator(_password.text) == null &&
        _phoneValidator(_phone.text) == null;
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
    final colors = Theme.of(context).colorScheme;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          AppSnackbar.error(context, message: state.message);
        } else if (state is AuthEmailVerificationSent) {
          context.go(
            "${Routes.verifyEmail}?email=${Uri.encodeComponent(state.email)}",
          );
        } else if (state is AuthAuthenticated) {
          context.go(Routes.home);
        } else if (state is AuthSuccess) {
          AppSnackbar.success(context, message: state.message ?? "Sucesso!");
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.go(Routes.login),
          ),
          title: const Text("Bloco na Rua"),
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
                    "Crie sua conta",
                    style: AppTypography.displaySmall.copyWith(
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(height: Spacing.space_xs),
                  Text(
                    "Junte-se à folia",
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
                            label: "Nome",
                            controller: _name,
                            prefixIcon: Icons.person_rounded,
                            validator: _nameValidator,
                            errorText: _nameTouched
                                ? _nameValidator(_name.text)
                                : null,
                            onChanged: _onNameChanged,
                          ),
                          const SizedBox(height: Spacing.space_sm),
                          AppTextField(
                            label: "E-mail",
                            controller: _email,
                            prefixIcon: Icons.email_rounded,
                            keyboardType: TextInputType.emailAddress,
                            validator: _emailValidator,
                            errorText: _emailTouched
                                ? _emailValidator(_email.text)
                                : null,
                            onChanged: _onEmailChanged,
                          ),
                          const SizedBox(height: Spacing.space_sm),
                          AppTextField(
                            label: "Senha",
                            controller: _password,
                            prefixIcon: Icons.lock_rounded,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            helperText: "Mínimo 8 caracteres",
                            validator: _passwordValidator,
                            errorText: _passwordTouched
                                ? _passwordValidator(_password.text)
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
                            label: "Telefone",
                            prefixIcon: Icons.phone_rounded,
                            validator: _phoneValidator,
                            errorText: _phoneTouched
                                ? _phoneValidator(_phone.text)
                                : null,
                            onChanged: _onPhoneChanged,
                            // The submit button is disabled while the form is
                            // invalid, so the keyboard action is the only way
                            // to submit an invalid form: it shows every
                            // error instead of calling the API.
                            onSubmitted: (_) => _submit(),
                          ),
                          const SizedBox(height: Spacing.space_lg),
                          BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, state) {
                              if (state is AuthLoading) {
                                return const AppButton(
                                  label: "Cadastrar",
                                  isLoading: true,
                                  isFullWidth: true,
                                  variant: AppButtonVariant.accent,
                                );
                              }

                              return ValueListenableBuilder<bool>(
                                valueListenable: _isFormValidNotifier,
                                builder: (context, isFormValid, child) {
                                  return AppButton(
                                    label: "Cadastrar",
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
                  Center(
                    child: TextButton(
                      onPressed: () => context.go(Routes.login),
                      child: Text(
                        "Já tem uma conta? Faça login",
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
