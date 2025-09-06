import 'package:bloco_na_rua/data/repositories/interfaces/iauth_repository.dart';
import 'package:command_it/command_it.dart';
import 'package:logging/logging.dart';
import 'package:result_dart/result_dart.dart';

class LoginViewModel {
  LoginViewModel({required IAuthRepository authRepository})
    : _authRepository = authRepository {
    login = Command.createAsync<(String email, String password), Result<void>>(
      initialValue: Failure(Exception('Not executed')),
      _login,
    );
  }

  final IAuthRepository _authRepository;
  final _log = Logger('LoginViewmodel');

  late Command<(String email, String password), Result<void>> login;

  AsyncResult<void> _login((String, String) credentials) async {
    final (email, password) = credentials;
    final result = await _authRepository.login(
      email: email,
      password: password,
    );

    if (result.isError()) {
      _log.warning('Login failed: ${result.exceptionOrNull()}');
      return result;
    }

    _log.info('Login successful');
    return result;
  }

  AsyncResult<void> resetPassword(String email) async {
    var result = await _authRepository.resetPassword(email);
    if (result.isError()) {
      _log.warning('Failed to reset password', result.exceptionOrNull());
      return result;
    }

    _log.info('Password reset email sent');
    return result;
  }
}
