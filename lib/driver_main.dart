// Entrypoint for Flutter Driver testing
// Usage: flutter run -t driver_main.dart

import 'package:flutter_driver/driver_extension.dart';
import 'package:bloco_na_rua/main.dart' as app;

void main() {
  enableFlutterDriverExtension();
  app.main();
}