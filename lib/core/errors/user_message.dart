import 'dart:ui';

import 'package:bloco_na_rua/core/api_error.dart';
import 'package:bloco_na_rua/core/error_types.dart';
import 'package:flutter/widgets.dart';

/// Cached device locale for use when no BuildContext is available.
/// Set during app initialization via [initializeLocale].
Locale? _cachedDeviceLocale;

/// Initializes the cached device locale from the platform dispatcher.
/// Call this once at app startup (e.g., in main() before runApp).
void initializeLocale() {
  _cachedDeviceLocale = PlatformDispatcher.instance.locale;
}

/// Extracts a user-friendly message from the given error.
///
/// Uses the cached device locale for [ApiError] localization when no
/// [BuildContext] is available. Falls back to the English userMessage
/// if no locale is cached.
String extractUserMessage(Object? error) {
  if (error == null) return "Erro desconhecido";
  if (error is ApiError) {
    // Try to use cached locale for localization
    if (_cachedDeviceLocale != null) {
      // Create a minimal context-like lookup using AppLocalizations
      return _localizeApiError(error, _cachedDeviceLocale!);
    }
    return error.userMessage;
  }
  if (error is Exception) {
    final msg = error.toString();
    if (msg.startsWith("Exception: ")) return msg.substring(11);
    return msg;
  }
  return error.toString();
}

/// Localizes an ApiError using the device locale.
String _localizeApiError(ApiError error, Locale locale) {
  // We can't use BuildContext here, so manually lookup the localization
  switch (error.type) {
    case ApiErrorType.network:
      return locale.languageCode == 'pt'
          ? 'Sem conexão com a internet. Verifique sua rede Wi-Fi.'
          : error.userMessage;
    case ApiErrorType.timeout:
      return locale.languageCode == 'pt'
          ? 'Conexão lenta. Verifique sua internet ou tente novamente.'
          : error.userMessage;
    case ApiErrorType.validation:
      return locale.languageCode == 'pt'
          ? 'Dados inválidos. Verifique as informações.'
          : error.userMessage;
    case ApiErrorType.notFound:
      return locale.languageCode == 'pt'
          ? 'Recurso não encontrado.'
          : error.userMessage;
    case ApiErrorType.unknown:
      return locale.languageCode == 'pt'
          ? 'Algo inesperado aconteceu. Tente novamente.'
          : error.userMessage;
    case ApiErrorType.server:
      return locale.languageCode == 'pt'
          ? (error.statusCode == 503
              ? 'Servidor temporariamente indisponível. Tente novamente mais tarde.'
              : 'Erro no servidor. Tente novamente mais tarde.')
          : error.userMessage;
    case ApiErrorType.auth:
      return locale.languageCode == 'pt'
          ? (error.statusCode == 401
              ? 'Sessão expirada. Faça login novamente.'
              : 'Você não tem permissão para esta ação.')
          : error.userMessage;
  }
}

/// Extracts a localized user-friendly message from the given error.
///
/// When [ApiError] is provided and [context] is available, returns the
/// message localized via [AppLocalizations]. Falls back to the cached
/// device locale or non-localized message when context is unavailable.
String extractUserMessageWithContext(Object? error, BuildContext context) {
  if (error == null) return "Erro desconhecido";
  if (error is ApiError) return error.toUserMessage(context);
  if (error is Exception) {
    final msg = error.toString();
    if (msg.startsWith("Exception: ")) return msg.substring(11);
    return msg;
  }
  return error.toString();
}
