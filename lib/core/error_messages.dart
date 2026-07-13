/// Catalog of user-facing error messages in pt_BR.
/// Used by ApiError to provide consistent, localized error messaging.
class ErrorMessages {
  ErrorMessages._();

  /// No internet connection or socket error
  static const network =
      'Sem conexão com a internet. Verifique sua rede Wi-Fi.';

  /// Connection timeout
  static const timeout =
      'Conexão lenta. Verifique sua internet ou tente novamente.';

  /// Server temporarily unavailable (503)
  static const server503 =
      'Servidor temporariamente indisponível. Tente novamente mais tarde.';

  /// Generic 5xx server errors
  static const server5xx = 'Erro no servidor. Tente novamente mais tarde.';

  /// Authentication expired (401)
  static const authExpired = 'Sessão expirada. Faça login novamente.';

  /// Authorization forbidden (403)
  static const authForbidden = 'Você não tem permissão para esta ação.';

  /// Resource not found (404)
  static const notFound = 'Recurso não encontrado.';

  /// Validation error (400)
  static const validation = 'Dados inválidos. Verifique as informações.';

  /// Unknown or unexpected error
  static const unknown = 'Algo inesperado aconteceu. Tente novamente.';
}
