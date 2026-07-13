import "package:flutter/foundation.dart";

class AuthListenable extends ChangeNotifier {
  void notify() => notifyListeners();
}
