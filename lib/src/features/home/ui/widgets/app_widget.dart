import 'dart:async';
import 'package:bloco_na_rua/src/features/auth/interactor/blocs/auth_bloc.dart';
import 'package:bloco_na_rua/src/features/auth/interactor/states/auth_state.dart';
import 'package:bloco_na_rua/src/features/carnival_block/interactor/blocs/carnival_block_bloc.dart';
import 'package:bloco_na_rua/src/features/carnival_block/interactor/events/carnival_block_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_storage/get_storage.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  late final StreamSubscription _subscription;

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute('/auth/login');

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Bloco na Rua',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: Modular.routerConfig,
    );
  }

  @override
  void initState() {
    super.initState();
    _subscription = Modular.get<AuthBloc>().stream.listen((state) {
      if (state is LoggedAuthState) {
        final carnivalBlockBloc = Modular.get<CarnivalBlockBloc>();
        final sessionEmail = Modular.get<GetStorage>().read('email');
        carnivalBlockBloc.add(LoadCarnivalBlockEvent(email: sessionEmail));

        Modular.to.navigate('/');
      } else if (state is LogoutedAuthState) {
        Modular.to.navigate('/auth/login');
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
