import 'package:bloco_na_rua/core/api_error.dart';
import 'package:bloco_na_rua/core/error_types.dart';
import 'package:bloco_na_rua/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

/// Generic fallback message used when no [BuildContext] is available.
/// ponytail: non-localized, single string — add context param to localize.
const _genericErrorMessage = 'Erro desconhecido';

/// Extracts a user-friendly message from the given error.
///
/// Uses [AppLocalizations] for proper localization when [context] is provided.
/// When [context] is unavailable, falls back to a generic non-localized string.
String extractUserMessage(Object? error, [BuildContext? context]) {
  if (error == null) return _genericErrorMessage;
  if (context != null) {
    final l10n = AppLocalizations.of(context);
    if (l10n != null && error is ApiError) {
      return _localizeApiError(error, l10n);
    }
  }
  if (error is ApiError) return error.userMessage;
  if (error is Exception) {
    final msg = error.toString();
    if (msg.startsWith('Exception: ')) return msg.substring(11);
    return msg;
  }
  return error.toString();
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
String extractUserMessageWithContext(Object? error, BuildContext context) {
  if (error == null) return _genericErrorMessage;
  if (error is ApiError) {
    final l10n = AppLocalizations.of(context);
    if (l10n != null) return _localizeApiError(error, l10n);
    return error.userMessage;
  }
  if (error is Exception) {
    final msg = error.toString();
    if (msg.startsWith('Exception: ')) return msg.substring(11);
    return msg;
  }
  return error.toString();
}
