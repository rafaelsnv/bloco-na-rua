import 'package:bloco_na_rua/routing/routes.dart';
import 'package:bloco_na_rua/ui/auth/signUp/view_model/signup_viewmodel.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, required this.viewModel});

  final SignUpViewModel viewModel;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final ValueNotifier<bool> _isFormValidNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    widget.viewModel.signUp.addListener(_onResult);
    _email.addListener(_validateForm);
    _password.addListener(_validateForm);
    _phone.addListener(_validateForm);
    _validateForm(); // Initial validation
  }

  @override
  void didUpdateWidget(covariant SignUpScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.signUp.removeListener(_onResult);
    widget.viewModel.signUp.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.signUp.removeListener(_onResult);
    _email.removeListener(_validateForm);
    _password.removeListener(_validateForm);
    _phone.removeListener(_validateForm);
    _isFormValidNotifier.dispose();
    super.dispose();
  }

  void _validateForm() {
    _isFormValidNotifier.value = _formKey.currentState?.validate() ?? false;
  }

  void _onResult() {
    final result = widget.viewModel.signUp.results.value.data;

    if (result == null) {
      return;
    }

    if (result.isError()) {
      widget.viewModel.signUp.clearErrors();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.exceptionOrNull().toString()),
          showCloseIcon: true,
        ),
      );
      return;
    }

    context.go(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    'Crie sua conta',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 26),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
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
                  SizedBox(height: 16),
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
                  SizedBox(height: 16),
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
                  SizedBox(height: 26),
                  SizedBox(
                    width: double.infinity,
                    height: 49,
                    child: ListenableBuilder(
                      listenable: widget.viewModel.signUp,
                      builder: (context, _) {
                        if (widget.viewModel.signUp.isExecuting.value) {
                          return const CircularProgressIndicator();
                        }

                        return ValueListenableBuilder<bool>(
                          valueListenable: _isFormValidNotifier,
                          builder: (context, isFormValid, child) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: isFormValid
                                  ? () {
                                      if (_formKey.currentState!.validate()) {
                                        widget.viewModel.signUp.execute((
                                          _email.value.text,
                                          _password.value.text,
                                          _phone.value.text,
                                        ));
                                      }
                                    }
                                  : null,
                              child: Text(
                                'Cadastrar',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surfaceBright,
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
                  SizedBox(height: 26),
                  Center(
                    child: GestureDetector(
                      onTap: () => context.go(Routes.login),
                      child: Text(
                        "Já tem uma conta? Faça login",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primaryFixedDim,
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
