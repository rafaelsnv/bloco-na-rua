import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../interactor/blocs/auth_bloc.dart';
import '../../interactor/events/auth_event.dart';
import '../../interactor/states/auth_state.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String email = '';
  String password = '';
  String name = '';
  String phone = '';

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(horizontal: 6, vertical: 4);

    final bloc = context.watch<AuthBloc>();
    final state = bloc.state;
    final isLoading = state is LoadingAuthState;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Modular.to.navigate('/auth/login');
          },
        ),
        title: const Text('Cadastrar'),
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
                    onChanged: (value) {
                      name = value;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nome Completo*',
                    ),
                  ),
                ),
                Padding(
                  padding: padding,
                  child: TextFormField(
                    enabled: !isLoading,
                    onChanged: (value) {
                      phone = value;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Telefone*',
                    ),
                  ),
                ),
                Padding(
                  padding: padding,
                  child: TextFormField(
                    enabled: !isLoading,
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
                    onPressed: () {
                      if (name.isEmpty &&
                          email.isEmpty &&
                          password.isEmpty &&
                          phone.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Preencha os campos obrigatórios',
                              textAlign: TextAlign.center,
                              textScaler: TextScaler.linear(1.1),
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
                      final event = CreateUserAuthEvent(
                        name: name,
                        phone: phone,
                        email: email,
                        password: password,
                      );
                      bloc.add(event);
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
