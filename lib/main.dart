import 'package:bloco_na_rua/src/module_app.dart';
import 'package:bloco_na_rua/src/ui/widgets/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

void main() {
  runApp(
    ModularApp(
      module: AppModule(),
      child: const AppWidget(),
    ),
  );
}