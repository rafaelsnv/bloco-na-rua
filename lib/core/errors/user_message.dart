import "package:bloco_na_rua/core/api_error.dart";

/// Extracts a user-friendly message from the given error.
///
/// Handles [ApiError] with its user-facing message, raw [Exception]
/// messages, and unknown error types.
///
/// Centralized helper for translating errors to user-facing
/// messages across all cubits. Preserves:
/// - [ApiError.userMessage] handling
/// - Null fallback to "Erro desconhecido"
/// - `Exception` prefix stripping
/// - Generic `toString()` fallback
String extractUserMessage(Object? error) {
  if (error == null) return "Erro desconhecido";
  if (error is ApiError) return error.userMessage;
  if (error is Exception) {
    final msg = error.toString();
    if (msg.startsWith("Exception: ")) return msg.substring(11);
    return msg;
  }
  return error.toString();
}
