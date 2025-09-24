import 'package:bloco_na_rua/data/repositories/interfaces/iauth_repository.dart';
import 'package:bloco_na_rua/data/repositories/interfaces/imembers_repository.dart';
import 'package:bloco_na_rua/data/services/api/members/create/member_create.dart';
import 'package:bloco_na_rua/data/services/auth/auth_api_client.dart';
import 'package:bloco_na_rua/data/services/auth/models/login_request/login_request.dart';
import 'package:bloco_na_rua/data/services/auth/models/login_response/login_response.dart';
import 'package:bloco_na_rua/data/services/auth/models/signup_request/signup_request.dart';
import 'package:bloco_na_rua/data/services/shared_preferencies_service.dart';
import 'package:bloco_na_rua/domain/entities/members_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:result_dart/result_dart.dart';

class AuthRepository extends ChangeNotifier implements IAuthRepository {
  AuthRepository({
    required IMembersRepository membersRepository,
    required AuthApiClient authApiClient,
    required SharedPreferencesService sharedPreferencesService,
  }) : _membersRepository = membersRepository,
       _authApiClient = authApiClient,
       _sharedPreferencesService = sharedPreferencesService;

  final IMembersRepository _membersRepository;
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
  AsyncResult<LoginResponse> login({
    required String email,
    required String password,
    String? phone = '',
  }) async {
    try {
      final loginRequest = LoginRequest(email: email, password: password);

      final loginResult = await _authApiClient.logIn(loginRequest);

      if (loginResult.isError()) {
        _log.severe('Failed to login', loginResult.exceptionOrNull());
        return loginResult;
      }

      final loginResponse = loginResult.getOrNull();
      if (loginResponse == null) {
        _log.warning('Login response is null');
        return loginResult;
      }

      _log.info('Login successful');
      _isAuthenticated = true;
      _authToken = loginResponse.accessToken;

      var tokenResult = await _sharedPreferencesService.saveToken(
        loginResponse.accessToken,
      );
      if (tokenResult.isError()) {
        _log.warning('Failed to login', loginResult.exceptionOrNull());
        return Failure(tokenResult.exceptionOrNull()!);
      }

      return loginResult;
    } finally {
      notifyListeners();
    }
  }

  @override
  AsyncResult<LoginResponse> signUp(SignUpRequest signUpRequest) async {
    try {
      final authResult = await _authApiClient.signUp(signUpRequest);
      if (authResult.isError() || authResult.getOrNull() == null) {
        _log.severe(
          'Failed to sign up',
          authResult.exceptionOrNull() ?? authResult.getOrNull(),
        );

        return authResult;
      }

      var userData = authResult.getOrNull();
      if (userData == null) {
        return Failure(Exception('User data is null'));
      }

      var membersResult = await _registerMember(
        signUpRequest,
        userData.userUuid,
      );
      if (membersResult.isError()) {
        return Failure(membersResult.exceptionOrNull()!);
      }

      _log.info('Sign up successful');
      _isAuthenticated = true;
      _authToken = userData.accessToken;
      var tokenResult = await _sharedPreferencesService.saveToken(
        userData.accessToken,
      );
      if (tokenResult.isError()) {
        _log.severe('Failed to save token', tokenResult.exceptionOrNull());
        return Failure(tokenResult.exceptionOrNull()!);
      }
      _log.info('Token saved successfully');
      return authResult;
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

  AsyncResult<MembersEntity> _registerMember(
    SignUpRequest signUpData,
    String uuid,
  ) async {
    final model = MemberCreate(
      uuid: uuid,
      name: signUpData.name,
      email: signUpData.email,
      phone: signUpData.phone,
      profileImage: 'TODO', //TO-DO
    );
    _log.info('Registering member');
    var membersResult = await _membersRepository.createAsync(model);
    if (membersResult.isError() || membersResult.getOrNull() == null) {
      _log.severe(
        'Failed to register member',
        membersResult.exceptionOrNull() ?? membersResult.getOrNull(),
      );
      _authApiClient.deleteUser(model.uuid);
      await _sharedPreferencesService.saveToken(null);
      return Failure(membersResult.exceptionOrNull()!);
    }
    _log.info('Member registered successfully');
    return membersResult;
  }
}
