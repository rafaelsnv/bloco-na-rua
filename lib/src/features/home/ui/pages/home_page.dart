// import 'package:bloco_na_rua/src/features/auth/interactor/blocs/auth_bloc.dart';
// import 'package:bloco_na_rua/src/features/auth/ui/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectecIndex = 0;

  void onDestinationSelected(int index) {
    switch (index) {
      case 0:
        Modular.to.navigate('/');
        break;
      case 1:
        Modular.to.navigate('/profile');
        break;
      default:
        Modular.to.navigate('/');
    }
    setState(() {
      selectecIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final bloc = context.watch<AuthBloc>();
    // final state = bloc.state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloco na Rua'),
      ),
      body: const RouterOutlet(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectecIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Início',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
