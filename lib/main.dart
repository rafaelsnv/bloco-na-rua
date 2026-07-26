import 'package:bloco_na_rua/config/dependencies.dart';
import 'package:bloco_na_rua/core/errors/user_message.dart';
import 'package:bloco_na_rua/main_app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';
import 'package:marionette_flutter/marionette_flutter.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  if (kDebugMode) {
    MarionetteBinding.ensureInitialized();
  } else {
    WidgetsFlutterBinding.ensureInitialized();
  }

  // Initialize locale for i18n before any error messages are extracted
  initializeLocale();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    publishableKey: dotenv.env['SUPABASE_ANON_KEY']!,
    realtimeClientOptions: RealtimeClientOptions(
      logLevel: RealtimeLogLevel.warn,
    ),
  );

  Logger.root.level = kDebugMode ? Level.INFO : Level.WARNING;

  runApp(MultiProvider(providers: providers, child: const MainApp()));
}
