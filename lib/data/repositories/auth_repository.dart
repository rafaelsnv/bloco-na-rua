import 'package:bloco_na_rua/data/repositories/interfaces/iauth_repository.dart';
import 'package:bloco_na_rua/data/services/api/api_client.dart';
import 'package:bloco_na_rua/data/services/auth/auth_api_client.dart';
import 'package:bloco_na_rua/data/services/auth/models/login_request/login_request.dart';
import 'package:bloco_na_rua/data/services/shared_preferencies_service.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:result_dart/result_dart.dart';

class AuthRepository extends ChangeNotifier implements IAuthRepository {
  AuthRepository({
    required ApiClient apiClient,
    required AuthApiClient authApiClient,
    required SharedPreferencesService sharedPreferencesService,
  }) : _apiClient = apiClient,
       _authApiClient = authApiClient,
       _sharedPreferencesService = sharedPreferencesService;

  final ApiClient _apiClient;
  final AuthApiClient _authApiClient;
  final SharedPreferencesService _sharedPreferencesService;

  bool? _isAuthenticated; //TODO: inicializar como false?
  String? _authToken;
  final _log = Logger('AuthRepositoryRemote');

  Future<void> _fetchToken() async {
    final result = await _sharedPreferencesService.fetchToken();
    if (result.isError()) {
      _log.severe(
        'Failed to fetch Token from SharedPreferences',
        result.exceptionOrNull(),
      );
      return;
    }
    _authToken = result.getOrNull();
    _isAuthenticated = _authToken != null;
  }

  @override
  Future<bool> get isAuthenticated async {
    if (_isAuthenticated != null) {
      return _isAuthenticated!;
    }
    await _fetchToken();
    return _isAuthenticated ?? false;
  }

  @override
  AsyncResult<void> login({
    required String email,
    required String password,
    String? phone = '',
  }) async {
    try {
      final loginRequest = LoginRequest(
        email: email,
        password: password,
        phone: phone.toString(),
      );

      final result = await _authApiClient.logIn(loginRequest);
      if (result.isError()) {
        _log.warning('Failed to login', result.exceptionOrNull());
        return Failure(
          result.exceptionOrNull() ?? Exception('Failed to login'),
        );
      }

      final loginResponse = result.getOrNull();
      if (loginResponse == null) {
        _log.warning('Login response is null');
        return Failure(Exception('Login response is null'));
      }

      _log.info('Login successful');
      _isAuthenticated = true;
      _authToken = loginResponse.accessToken;
      return await _sharedPreferencesService.saveToken(
        loginResponse.accessToken,
      );
    } finally {
      notifyListeners();
    }
  }

  @override
  AsyncResult<void> logout() async {
    _log.info('Logging out');
    try {
      final result = await _sharedPreferencesService.saveToken(null);
      if (result.isError()) {
        _log.severe('Failed to clear stored auth token');
      }
      _authToken = null;
      _isAuthenticated = false;
      return result;
    } finally {
      notifyListeners();
    }
  }

  @override
  AsyncResult<void> signUp({required String email, required String password}) {
    // TODO: implement signIn
    throw UnimplementedError();
  }
}
