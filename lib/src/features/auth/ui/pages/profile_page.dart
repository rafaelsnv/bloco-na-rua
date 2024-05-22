import 'package:bloco_na_rua/src/features/auth/interactor/blocs/auth_bloc.dart';
import 'package:bloco_na_rua/src/features/auth/interactor/entities/user_entity.dart';
import 'package:bloco_na_rua/src/features/auth/interactor/events/auth_event.dart';
import 'package:bloco_na_rua/src/features/auth/interactor/states/auth_state.dart';
import 'package:bloco_na_rua/src/features/auth/ui/widgets/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<AuthBloc>();
    final state = bloc.state;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Modular.to.navigate('/');
          },
        ),
        title: const Text('Meu Perfil'),
      ),
      body: _buildChild(bloc: bloc, state: state),
    );
  }

  Widget _buildChild({required AuthBloc bloc, required AuthState state}) {
    Widget child = const Center(
      child: Text('Você não está logado'),
    );

    if (state is LoggedAuthState) {
      child = ListView(
        children: [
          ProfileWidget(imagePath: state.user.profileImage),
          const SizedBox(height: 24),
          buildName(user: state.user, bloc: bloc),
        ],
      );
    }
    return child;
  }

  Widget buildName({required UserEntity user, required AuthBloc bloc}) {
    return Center(
      child: Column(
        children: [
          Text(
            user.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            user.phone,
            style: const TextStyle(color: Colors.grey),
          ),
          ElevatedButton(
            onPressed: () {
              bloc.add(LogoutAuthEvent());
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}
