import 'package:bloco_na_rua/routing/routes.dart';
import 'package:bloco_na_rua/ui/auth/cubit/auth_cubit.dart';
import 'package:bloco_na_rua/ui/auth/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message.replaceAll("Exception: ", "")),
              showCloseIcon: true,
            ),
          );
        } else if (state is AuthAuthenticated) {
          context.go(Routes.home);
        } else if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? 'Sucesso!'),
              showCloseIcon: true,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceBright,
        appBar: AppBar(
          title: Text(
            'Bloco na Rua',
            style: TextStyle(
              fontSize: 30,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Bem vindo',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 26),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        border: OutlineInputBorder(),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um e-mail';
                        }
                        if (!value.contains('@')) {
                          return 'E-mail inválido';
                        }
                        return null;
                      },
                      onChanged: (_) => _validateForm(),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _password,
                      keyboardType: TextInputType.visiblePassword,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira uma senha';
                        }
                        return null;
                      },
                      onChanged: (_) => _validateForm(),
                    ),
                    const SizedBox(height: 26),
                    SizedBox(
                      width: double.infinity,
                      height: 49,
                      child: BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          if (state is AuthLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return ValueListenableBuilder<bool>(
                            valueListenable: _isFormValidNotifier,
                            builder: (context, isFormValid, child) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: isFormValid
                                    ? () {
                                        if (_formKey.currentState!
                                            .validate()) {
                                          context.read<AuthCubit>().login(
                                                _email.text,
                                                _password.text,
                                              );
                                        }
                                      }
                                    : null,
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceBright,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 26),
                    Center(
                      child: Builder(
                        builder: (context) {
                          return GestureDetector(
                            onTap: () =>
                                _showForgotPasswordDialog(context),
                            child: Text(
                              'Esqueceu a senha?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryFixedDim,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: GestureDetector(
                        onTap: () => context.go(Routes.register),
                        child: Text(
                          "Não tem uma conta? Cadastre-se",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context)
                                .colorScheme
                                .primaryFixedDim,
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

  void _showForgotPasswordDialog(BuildContext outerContext) {
    final TextEditingController emailController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    bool isFormValid = false;

    showDialog(
      context: outerContext,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            void validateForm() {
              setState(() {
                isFormValid = formKey.currentState?.validate() ?? false;
              });
            }

            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: AlertDialog(
                  title: const Text('Esqueceu a senha?'),
                  content: Form(
                    key: formKey,
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        border: OutlineInputBorder(),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um e-mail';
                        }
                        if (!value.contains('@')) {
                          return 'E-mail inválido';
                        }
                        return null;
                      },
                      onChanged: (_) => validateForm(),
                    ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHigh,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: !isFormValid
                          ? null
                          : () {
                              if (formKey.currentState!.validate()) {
                                outerContext.read<AuthCubit>().resetPassword(
                                      emailController.text,
                                    );
                                Navigator.of(context).pop();
                              }
                            },
                      child: Text(
                        'Enviar',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.surfaceBright,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
