// import 'package:bloco_na_rua/src/features/auth/interactor/blocs/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // final bloc = context.watch<AuthBloc>();
    // final state = bloc.state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloco na Rua'),
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              children: [
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () {
                    Modular.to.navigate('/profile');
                  },
                  child: const Text('Ver Perfil'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
