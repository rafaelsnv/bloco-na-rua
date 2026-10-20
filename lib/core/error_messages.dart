import 'package:flutter/widgets.dart';
import 'package:bloco_na_rua/l10n/app_localizations.dart';

import 'package:bloco_na_rua/core/error_types.dart';

/// Catalog of user-facing error messages via AppLocalizations.
/// Use [forType] to get a localized message given an error type and status code.
class ErrorMessages {
  ErrorMessages._();

  /// Returns the localized message for the given error type and HTTP status code.
  ///
  /// The [type] is the API error type. The [statusCode] is used to distinguish
  /// between semantically different messages that share the same type (e.g.
  /// 401 vs 403 for auth, 503 vs other 5xx for server).
  static String forType(BuildContext context, ApiErrorType type, int? statusCode) {
    final l10n = AppLocalizations.of(context)!;

    switch (type) {
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
        // Distinguish 503 from generic 5xx
        if (statusCode == 503) return l10n.server503;
        return l10n.server5xx;
      case ApiErrorType.auth:
        // Distinguish 401 (expired) from 403 (forbidden)
        if (statusCode == 401) return l10n.authExpired;
        return l10n.authForbidden;
    }
  }
}
