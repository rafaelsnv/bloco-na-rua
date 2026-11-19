import "package:flutter/widgets.dart";
import "package:intl/date_symbol_data_local.dart";
import "package:intl/intl.dart";

/// Single source of truth for the app's supported locale (pt-BR quick fix).
const Locale kAppLocale = Locale("pt", "BR");

/// Supported locales passed to `MaterialApp.router`.
const List<Locale> kSupportedLocales = <Locale>[Locale("pt"), Locale("en")];

/// Initializes date symbols and [Intl.defaultLocale] from [kAppLocale].
Future<void> initAppLocale() async {
  final localeTag = kAppLocale.toString();
  await initializeDateFormatting(localeTag, null);
  Intl.defaultLocale = localeTag;
}

/// Resolves the Intl locale string from [context], falling back to
/// [Intl.defaultLocale] or [kAppLocale] when no [Localizations] ancestor exists.
String resolvedLocaleTag(BuildContext? context) {
  if (context != null) {
    final locale = Localizations.maybeLocaleOf(context);
    if (locale != null) return locale.toString();
  }
  return Intl.defaultLocale ?? kAppLocale.toString();
}

/// Formats [dateTime] as `"dd MMM yyyy • HH:mm"` using [context]'s locale.
String formatDateTime(DateTime dateTime, [BuildContext? context]) {
  return DateFormat(
    "dd MMM yyyy • HH:mm",
    resolvedLocaleTag(context),
  ).format(dateTime);
}

/// Formats [dateTime] with [pattern] using [context]'s locale.
String formatDatePattern(
  String pattern,
  DateTime dateTime, [
  BuildContext? context,
]) {
  return DateFormat(pattern, resolvedLocaleTag(context)).format(dateTime);
}

/// Formats [dateTime] as numeric date (`yMd`) using [context]'s locale.
String formatShortDate(DateTime dateTime, [BuildContext? context]) {
  return DateFormat.yMd(resolvedLocaleTag(context)).format(dateTime);
}

/// Formats [dateTime] as numeric date + time (`yMd` + `Hm`) using [context]'s locale.
String formatShortDateTime(DateTime dateTime, [BuildContext? context]) {
  return DateFormat.yMd(resolvedLocaleTag(context)).add_Hm().format(dateTime);
}

/// Formats [dateTime] as 24h time (`Hm`) using [context]'s locale.
String formatTime(DateTime dateTime, [BuildContext? context]) {
  return DateFormat.Hm(resolvedLocaleTag(context)).format(dateTime);
}
