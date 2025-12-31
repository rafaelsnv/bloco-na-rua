import 'package:bloco_na_rua/data/repositories/auth/iauth_repository.dart';
import 'package:bloco_na_rua/data/services/auth/models/signup_request/signup_request.dart';
import 'package:bloco_na_rua/routing/routes.dart';
import 'package:bloco_na_rua/ui/auth/cubit/auth_cubit.dart';
import 'package:bloco_na_rua/ui/auth/cubit/auth_state.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(
        authRepository: context.read<IAuthRepository>(),
      ),
      child: BlocListener<AuthCubit, AuthState>(
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
            actions: const [Icon(Icons.arrow_back)],
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
                        'Crie sua conta',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 26),
                      TextFormField(
                        controller: _name,
                        decoration: const InputDecoration(
                          labelText: 'Nome',
                          border: OutlineInputBorder(),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira seu nome';
                          }
                          return null;
                        },
                        onChanged: (_) => _validateForm(),
                      ),
                      const SizedBox(height: 16),
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
                        decoration: const InputDecoration(
                          labelText: 'Senha',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira uma senha';
                          }
                          if (value.length < 6) {
                            return 'A senha deve ter no mínimo 6 caracteres';
                          }
                          return null;
                        },
                        onChanged: (_) => _validateForm(),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phone,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          labelText: 'Telefone',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          TelefoneInputFormatter(),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira um telefone';
                          }
                          if (value.length < 14) {
                            return 'Telefone inválido';
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
                                            final signUpData = SignUpRequest(
                                              name: _name.text,
                                              email: _email.text,
                                              password: _password.text,
                                              phone: _phone.text,
                                              profileImage: 'TODO', //TO-DO
                                            );
                                            context
                                                .read<AuthCubit>()
                                                .signUp(signUpData);
                                          }
                                        }
                                      : null,
                                  child: Text(
                                    'Cadastrar',
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
                        child: GestureDetector(
                          onTap: () => context.go(Routes.login),
                          child: Text(
                            "Já tem uma conta? Faça login",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color:
                                  Theme.of(context).colorScheme.primaryFixedDim,
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
      ),
    );
  }
}
