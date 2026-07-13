/// Enum representing different types of API errors.
/// Used to categorize errors for appropriate user-facing messaging.
enum ApiErrorType {
  /// No internet connection or socket error
  network,

  /// Connection timeout
  timeout,

  /// Server errors (5xx)
  server,

  /// Authentication errors (401) or authorization (403)
  auth,

  /// Validation errors (400 bad request)
  validation,

  /// Resource not found (404)
  notFound,

  /// Unknown or unexpected errors
  unknown,
}
