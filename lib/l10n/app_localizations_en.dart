// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get network => 'No internet connection. Check your Wi-Fi.';

  @override
  String get timeout => 'Slow connection. Check your internet or try again.';

  @override
  String get server503 => 'Server temporarily unavailable. Try again later.';

  @override
  String get server5xx => 'Server error. Try again later.';

  @override
  String get authExpired => 'Session expired. Please log in again.';

  @override
  String get authForbidden => 'You don\'t have permission for this action.';

  @override
  String get notFound => 'Resource not found.';

  @override
  String get validation => 'Invalid data. Check the information.';

  @override
  String get unknown => 'Something unexpected happened. Try again.';
}
