import 'package:bloco_na_rua/config/dependencies.dart';
import 'package:bloco_na_rua/main_app.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://mqlxlytsgzzzzkndmowo.supabase.co',
    anonKey: 'sb_publishable_naPZw0mnQoMJj1PaUZur3w_a9sk6lcx',
  );

  Logger.root.level = Level.ALL;

  runApp(MultiProvider(providers: providers, child: const MainApp()));
}
