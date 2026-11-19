import 'package:bloco_na_rua/config/dependencies.dart';
import 'package:bloco_na_rua/core/date_format.dart';
import 'package:bloco_na_rua/main_app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

void main() async {
  // Enable Flutter Driver for widget inspection and navigation
  // Must be called before WidgetsFlutterBinding.ensureInitialized()
  enableFlutterDriverExtension();

  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await initAppLocale();

  Logger.root.level = kDebugMode ? Level.INFO : Level.WARNING;

  runApp(MultiProvider(providers: providers, child: const MainApp()));
}
