import 'package:bloco_na_rua/data/repositories/interfaces/iauth_repository.dart';
import 'package:command_it/command_it.dart';
import 'package:logging/logging.dart';
import 'package:result_dart/result_dart.dart';

class SignUpViewModel {
  SignUpViewModel({required IAuthRepository authRepository})
    : _authRepository = authRepository {
    signUp =
        Command.createAsync<
          (String email, String password, String phone),
          Result<void>
        >(initialValue: Failure(Exception('Not executed')), _signUp);
  }

  final IAuthRepository _authRepository;
  final _log = Logger('SignUpViewModel');

  late Command<(String email, String password, String phone), Result<void>>
  signUp;

  AsyncResult<void> _signUp((String, String, String) credentials) async {
    final (email, password, phone) = credentials;
    final result = await _authRepository.signUp(
      email: email,
      password: password,
      phone: phone,
    );

    if (result.isError()) {
      _log.warning('Logout failed', result.exceptionOrNull());
      return result;
    }
    return result;
  }
}
