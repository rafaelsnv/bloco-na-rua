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
    final bloc = context.watch<AuthBloc>();
    final state = bloc.state;

    final isLoading = state is LoadingAuthState;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar'),
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              children: [
                const SizedBox(height: 5),
                TextFormField(
                  enabled: !isLoading,
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nome Completo',
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  enabled: !isLoading,
                  onChanged: (value) {
                    phone = value;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Telefone',
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  enabled: !isLoading,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'E-mail',
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  enabled: !isLoading,
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Senha',
                  ),
                ),
                if (isLoading) const CircularProgressIndicator(),
                if (!isLoading)
                  ElevatedButton(
                    onPressed: () {
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
                  ElevatedButton(
                onPressed: () {
                  Modular.to.navigate('/login');
                },
                child: const Text('Entrar'),
              ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
