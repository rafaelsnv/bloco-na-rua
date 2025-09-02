import 'package:bloco_na_rua/data/repositories/auth_repository.dart';
import 'package:command_it/command_it.dart';
import 'package:logging/logging.dart';
import 'package:result_dart/result_dart.dart';

class LoginViewModel {
  LoginViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository {
    login = Command.createAsync<(String email, String password), void>(
      _login,
      initialValue: null,
    );
  }

  final AuthRepository _authRepository;
  final _log = Logger('LoginViewmodel');

  late Command login;

  AsyncResult<void> _login((String, String) credentials) async {
    final (email, password) = credentials;
    final result = await _authRepository.login(
      email: email,
      password: password,
    );

    if (result.isError()) {
      _log.warning('Login failed', result.exceptionOrNull());
    }
    return result;
  }
}
