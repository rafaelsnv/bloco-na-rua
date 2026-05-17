// Entrypoint for Flutter Driver testing
// Usage: flutter run -t driver_main.dart

import 'package:bloco_na_rua/main.dart' as app;
import 'package:flutter_driver/driver_extension.dart';

void main() {
  enableFlutterDriverExtension();
  app.main();
}
