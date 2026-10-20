import 'package:bloco_na_rua/config/dependencies.dart';
import 'package:bloco_na_rua/main_app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
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

  // Load pt_BR date symbols so DateFormat("EEEE ...", "pt_BR") renders
  // Portuguese weekday/month names instead of silently falling back to en.
  await initializeDateFormatting('pt_BR', null);
  Intl.defaultLocale = 'pt_BR';

  Logger.root.level = kDebugMode ? Level.INFO : Level.WARNING;

  runApp(MultiProvider(providers: providers, child: const MainApp()));
}
