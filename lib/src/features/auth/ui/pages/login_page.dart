import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../interactor/blocs/auth_bloc.dart';
import '../../interactor/events/auth_event.dart';
import '../../interactor/states/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';
  String password = '';

  // @override
  // void initState() {
  //   super.initState();
  //   final authBloc = Modular.get<AuthBloc>();
  //   final state = authBloc.state;
  // }

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(horizontal: 6, vertical: 4);

    final bloc = Modular.get<AuthBloc>();
    final state = bloc.state;

    final isLoading = state is LoadingAuthState;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrar'),
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              children: [
                Padding(
                  padding: padding,
                  child: TextFormField(
                    enabled: !isLoading,
                    autofocus: true,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'E-mail*',
                    ),
                  ),
                ),
                Padding(
                  padding: padding,
                  child: TextFormField(
                    enabled: !isLoading,
                    obscureText: true,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Senha*',
                    ),
                  ),
                ),
                if (isLoading) const CircularProgressIndicator(),
                if (!isLoading)
                  FilledButton(
                    onPressed: () async {
                      if (email.isEmpty && password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Preencha os campos obrigatórios',
                              textAlign: TextAlign.center,
                              textScaler: TextScaler.linear(1.2),
                            ),
                            duration: const Duration(milliseconds: 1500),
                            width: 200,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                        return;
                      }
                      final event = LoginAuthEvent(
                        email: email,
                        password: password,
                      );
                      bloc.add(event);
                      // Modular.to.navigate('/');
                    },
                    child: const Text('Entrar'),
                  ),
                FilledButton.tonal(
                  onPressed: () {
                    Modular.to.navigate('/auth/sign_up');
                  },
                  child: const Text('Cadastrar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
