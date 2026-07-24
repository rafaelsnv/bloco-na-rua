// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get network => 'Sem conexão com a internet. Verifique sua rede Wi-Fi.';

  @override
  String get timeout =>
      'Conexão lenta. Verifique sua internet ou tente novamente.';

  @override
  String get server503 =>
      'Servidor temporariamente indisponível. Tente novamente mais tarde.';

  @override
  String get server5xx => 'Erro no servidor. Tente novamente mais tarde.';

  @override
  String get authExpired => 'Sessão expirada. Faça login novamente.';

  @override
  String get authForbidden => 'Você não tem permissão para esta ação.';

  @override
  String get notFound => 'Recurso não encontrado.';

  @override
  String get validation => 'Dados inválidos. Verifique as informações.';

  @override
  String get unknown => 'Algo inesperado aconteceu. Tente novamente.';
}
