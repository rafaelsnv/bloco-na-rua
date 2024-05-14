import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../interactor/blocs/auth_bloc.dart';
import '../interactor/events/auth_event.dart';
import '../interactor/states/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<AuthBloc>();
    final state = bloc.state;

    final isLoading = state is LoadingAuthState;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrar'),
      ),
      body: Center(
        child: Column(
          children: [
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
                  final event = LoginAuthEvent(
                    email: email,
                    password: password,
                  );
                  bloc.add(event);
                },
                child: const Text('Entrar'),
              ),
          ],
        ),
      ),
    );
  }
}
