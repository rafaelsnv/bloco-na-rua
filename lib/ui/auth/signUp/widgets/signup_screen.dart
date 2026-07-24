import "package:bloco_na_rua/data/repositories/auth/auth_listenable.dart";
import "package:bloco_na_rua/data/repositories/auth/iauth_repository.dart";
import "package:bloco_na_rua/data/services/auth/models/signup_request/signup_request.dart";
import "package:bloco_na_rua/routing/routes.dart";
import "package:bloco_na_rua/ui/auth/cubit/auth_cubit.dart";
import "package:bloco_na_rua/ui/auth/cubit/auth_state.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_button.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_card.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_snackbar.dart";
import "package:bloco_na_rua/ui/core/widgets/inputs/app_text_field.dart";
import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
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

  @override
  void initState() {
    super.initState();
    _name.addListener(_validateForm);
    _email.addListener(_validateForm);
    _password.addListener(_validateForm);
    _phone.addListener(_validateForm);
    _validateForm();
  }

  @override
  void dispose() {
    _name.removeListener(_validateForm);
    _email.removeListener(_validateForm);
    _password.removeListener(_validateForm);
    _phone.removeListener(_validateForm);
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _phone.dispose();
    _isFormValidNotifier.dispose();
    super.dispose();
  }

  void _validateForm() {
    _isFormValidNotifier.value = _formKey.currentState?.validate() ?? false;
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final signUpData = SignUpRequest(
        name: _name.text,
        email: _email.text,
        password: _password.text,
        phone: _phone.text,
      );
      context.read<AuthCubit>().signUp(signUpData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(
        authRepository: context.read<IAuthRepository>(),
        authListenable: context.read<AuthListenable>(),
      ),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            AppSnackbar.error(
              context,
              message: state.message.replaceAll("Exception: ", ""),
            );
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
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => context.go(Routes.login),
            ),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Crie sua conta",
                      style: AppTypography.displaySmall.copyWith(
                        color: AppColors.primary,
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Por favor, insira seu nome";
                                }
                                return null;
                              },
                              onChanged: (_) => _validateForm(),
                            ),
                            const SizedBox(height: Spacing.space_sm),
                            AppTextField(
                              label: "E-mail",
                              controller: _email,
                              prefixIcon: Icons.email_rounded,
                              keyboardType: TextInputType.emailAddress,
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
                            AppTextField(
                              label: "Senha",
                              controller: _password,
                              prefixIcon: Icons.lock_rounded,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              helperText: "Mínimo 6 caracteres",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Por favor, insira uma senha";
                                }
                                if (value.length < 6) {
                                  return "A senha deve ter no mínimo 6 caracteres";
                                }
                                return null;
                              },
                              onChanged: (_) => _validateForm(),
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Por favor, insira um telefone";
                                }
                                if (value.length < 14) {
                                  return "Telefone inválido";
                                }
                                return null;
                              },
                              onChanged: (_) => _validateForm(),
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
                      child: GestureDetector(
                        onTap: () => context.go(Routes.login),
                        child: Text(
                          "Já tem uma conta? Faça login",
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.primary,
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
      ),
    );
  }
}
