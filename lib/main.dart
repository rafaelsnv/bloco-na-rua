import 'package:bloco_na_rua/firebase_options.dart';
import 'package:bloco_na_rua/src/app_module.dart';
import 'package:bloco_na_rua/src/features/home/ui/widgets/home_widget.dart';
// ignore: unused_import
import 'package:dcdg/dcdg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ModularApp(
      module: AppModule(),
      child: const HomeWidget(),
    ),
  );
}