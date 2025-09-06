import 'package:bloco_na_rua/data/repositories/interfaces/iauth_repository.dart';
import 'package:bloco_na_rua/data/services/api/api_client.dart';
import 'package:bloco_na_rua/data/services/auth/auth_api_client.dart';
import 'package:bloco_na_rua/data/services/auth/models/login_request/login_request.dart';
import 'package:bloco_na_rua/data/services/auth/models/signup_request/signup_request.dart';
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

  bool? _isAuthenticated;
  String? _authToken;
  final _log = Logger('AuthRepository');

  Future<void> _fetchToken() async {
    final result = await _sharedPreferencesService.fetchToken();
    if (result.isError()) {
      _log.severe('Failed to fetch Token from SharedPreferences');
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
      final loginRequest = LoginRequest(email: email, password: password);

      final result = await _authApiClient.logIn(loginRequest);

      if (result.isError()) {
        _log.severe('Failed to login', result.exceptionOrNull());
        return result;
      }

      final loginResponse = result.getOrNull();
      if (loginResponse == null) {
        _log.warning('Login response is null');
        return result;
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
  AsyncResult<void> signUp({
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final signUpRequest = SignUpRequest(
        email: email,
        password: password,
        phone: phone,
      );

      final result = await _authApiClient.signUp(signUpRequest);
      if (result.isError()) {
        _log.severe('Failed to sign up', result.exceptionOrNull());
        return result;
      }

      final signUpResponse = result.getOrNull();
      if (signUpResponse == null) {
        _log.warning('Sign up response is null');
        return result;
      }

      _log.info('Sign up successful');
      _isAuthenticated = true;
      _authToken = signUpResponse.accessToken;
      return await _sharedPreferencesService.saveToken(
        signUpResponse.accessToken,
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
  AsyncResult<void> resetPassword(String email) async {
    try {
      final result = await _authApiClient.resetPassword(email);
      if (result.isError()) {
        _log.severe('Failed to reset password');
        return result;
      }

      _log.info('Password reset email sent');
      return result;
    } finally {
      notifyListeners();
    }
  }
}
