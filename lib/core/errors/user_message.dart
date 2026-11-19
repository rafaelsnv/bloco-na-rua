import 'package:bloco_na_rua/core/api_error.dart';
import 'package:bloco_na_rua/core/error_types.dart';
import 'package:bloco_na_rua/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

/// Generic fallback used only when no [BuildContext] is available.
/// A context-aware call resolves the catalog's `unknown` key instead.
const _genericErrorMessage = 'Erro desconhecido';

/// Matches the technical `Exception: ` prefix, but only when it is NOT the
/// tail of a longer identifier (`FormatException: ` must survive intact).
final RegExp _exceptionPrefixPattern = RegExp(r'(?<![A-Za-z0-9_])Exception: ');

/// Removes every technical `Exception: ` prefix from [message].
///
/// Dart renders `Exception("boom")` as `"Exception: boom"`, and a wrapper
/// such as `Exception("Unexpected error: $e")` nests the prefix inside the
/// text. Neither belongs in a user-facing message.
String _stripExceptionPrefix(String message) =>
    message.replaceAll(_exceptionPrefixPattern, '');

/// Extracts a user-friendly message from the given error.
///
/// Uses [AppLocalizations] for proper localization when [context] is provided.
/// When [context] is unavailable, falls back to a generic non-localized string.
String extractUserMessage(Object? error, [BuildContext? context]) {
  if (context != null) {
    final l10n = AppLocalizations.of(context);
    if (l10n != null) {
      if (error == null) return l10n.unknown;
      if (error is ApiError) return _localizeApiError(error, l10n);
    }
  }
  if (error == null) return _genericErrorMessage;
  if (error is ApiError) return error.userMessage ?? error.type.name;
  return _stripExceptionPrefix(error.toString());
}

/// Localizes an [ApiError] using [AppLocalizations].
String _localizeApiError(ApiError error, AppLocalizations l10n) {
  switch (error.type) {
    case ApiErrorType.network:
      return l10n.network;
    case ApiErrorType.timeout:
      return l10n.timeout;
    case ApiErrorType.validation:
      return l10n.validation;
    case ApiErrorType.notFound:
      return l10n.notFound;
    case ApiErrorType.unknown:
      return l10n.unknown;
    case ApiErrorType.server:
      return error.statusCode == 503 ? l10n.server503 : l10n.server5xx;
    case ApiErrorType.auth:
      return error.statusCode == 401 ? l10n.authExpired : l10n.authForbidden;
  }
}

/// Extracts a localized user-friendly message from the given error.
///
/// When [ApiError] is provided, returns the message localized via
/// [AppLocalizations]. Falls back to non-localized message when
/// context is unavailable.
String extractUserMessageWithContext(Object? error, BuildContext context) =>
    extractUserMessage(error, context);
