import 'package:bloco_na_rua/routing/routes.dart';
import 'package:bloco_na_rua/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.viewModel});

  final LoginViewModel viewModel;

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
    widget.viewModel.login.addListener(_onResult);
    _email.addListener(_validateForm);
    _password.addListener(_validateForm);
    _validateForm();
  }

  @override
  void didUpdateWidget(covariant LoginScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.login.removeListener(_onResult);
    widget.viewModel.login.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.login.removeListener(_onResult);
    _email.removeListener(_validateForm);
    _password.removeListener(_validateForm);
    _isFormValidNotifier.dispose();
    super.dispose();
  }

  void _validateForm() {
    _isFormValidNotifier.value = _formKey.currentState?.validate() ?? false;
  }

  void _onResult() {
    final result = widget.viewModel.login.results.value.data;

    if (result == null) {
      return;
    }

    if (result.isError()) {
      widget.viewModel.login.clearErrors();
      // Guard BuildContext use with a mounted check on the BuildContext
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result.exceptionOrNull().toString().replaceAll("Exception: ", ""),
            ),
            showCloseIcon: true,
          ),
        );
        return;
      }
    }

    // Guard BuildContext use with a mounted check on the BuildContext
    if (context.mounted) {
      context.go(Routes.home);
    }
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
                    'Bem vindo',
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
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
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
                  SizedBox(height: 26),
                  SizedBox(
                    width: double.infinity,
                    height: 49,
                    child: ListenableBuilder(
                      listenable: widget.viewModel.login,
                      builder: (context, _) {
                        if (widget.viewModel.login.isExecuting.value) {
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
                                        widget.viewModel.login.execute((
                                          _email.value.text,
                                          _password.value.text,
                                        ));
                                      }
                                    }
                                  : null,
                              child: Text(
                                'Login',
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
                      onTap: _showForgotPasswordDialog,
                      child: Text(
                        'Esqueceu a senha?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primaryFixedDim,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: GestureDetector(
                      onTap: () => context.go(Routes.register),
                      child: Text(
                        "Não tem uma conta? Cadastre-se",
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

  void _showForgotPasswordDialog() {
    final TextEditingController emailController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    bool isFormValid = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            void validateForm() {
              setState(() {
                isFormValid = formKey.currentState?.validate() ?? false;
              });
            }

            return Scaffold(
              body: SizedBox(
                width: double.infinity,
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
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHigh,
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
                          : () async {
                              if (formKey.currentState!.validate()) {
                                final email = emailController.text;
                                await widget.viewModel.resetPassword(email);

                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'E-mail de redefinição de senha enviado!',
                                      ),
                                      showCloseIcon: true,
                                    ),
                                  );
                                  Navigator.of(context).pop();
                                }
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
