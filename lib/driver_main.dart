import 'package:bloco_na_rua/config/dependencies.dart';
import 'package:bloco_na_rua/main_app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // Enable Flutter Driver for widget inspection and navigation
  // Must be called before WidgetsFlutterBinding.ensureInitialized()
  enableFlutterDriverExtension();

  WidgetsFlutterBinding.ensureInitialized();

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
