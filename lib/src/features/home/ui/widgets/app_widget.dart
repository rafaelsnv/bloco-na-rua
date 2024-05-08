import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp.router(
      title: 'Bloco na Rua',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: Modular.routerConfig,
      routerDelegate: Modular.routerDelegate,
      routeInformationParser: Modular.routeInformationParser,
    ); //added by extension 
  }
}
