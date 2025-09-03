import 'package:bloco_na_rua/routing/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Widget principal da aplicação
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bloco na Rua',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: router(context.read()),
    );
  }
}
