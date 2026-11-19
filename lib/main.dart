import 'package:bloco_na_rua/config/dependencies.dart';
import 'package:bloco_na_rua/core/date_format.dart';
import 'package:bloco_na_rua/main_app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';
import 'package:marionette_flutter/marionette_flutter.dart';
import 'package:marionette_logging/marionette_logging.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  if (kDebugMode) {
    MarionetteBinding.ensureInitialized(
      MarionetteConfiguration(
        enableSessionReports: true,
        logCollector: LoggingLogCollector(),
      ),
    );
  } else {
    WidgetsFlutterBinding.ensureInitialized();
  }

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    publishableKey: dotenv.env['SUPABASE_PUBLISHABLE_KEY']!,
    realtimeClientOptions: RealtimeClientOptions(
      logLevel: RealtimeLogLevel.warn,
    ),
  );

  // Initialize date symbols and Intl.defaultLocale from the app locale source of truth.
  await initAppLocale();

  Logger.root.level = kDebugMode ? Level.INFO : Level.WARNING;

  final prefs = await SharedPreferences.getInstance();
  final storedThemeIndex = prefs.getInt("THEME_MODE");
  final initialThemeMode =
      storedThemeIndex != null &&
          storedThemeIndex >= 0 &&
          storedThemeIndex < ThemeMode.values.length
      ? ThemeMode.values[storedThemeIndex]
      : ThemeMode.system;

  runApp(
    MultiProvider(
      providers: providers,
      child: MainApp(initialThemeMode: initialThemeMode),
    ),
  );
}
