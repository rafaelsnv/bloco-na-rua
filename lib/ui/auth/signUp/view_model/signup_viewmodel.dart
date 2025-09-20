import 'package:bloco_na_rua/data/repositories/interfaces/iauth_repository.dart';
import 'package:bloco_na_rua/data/repositories/interfaces/imembers_repository.dart';
import 'package:command_it/command_it.dart';
import 'package:logging/logging.dart';
import 'package:result_dart/result_dart.dart';

class SignUpViewModel {
  SignUpViewModel({
    required IAuthRepository authRepository,
    required IMembersRepository membersRepository,
  }) : _membersRepository = membersRepository,
       _authRepository = authRepository {
    signUp =
        Command.createAsync<
          (String email, String password, String phone),
          Result<void>
        >(initialValue: Failure(Exception('Not executed')), _signUp);
  }

  final IAuthRepository _authRepository;
  final IMembersRepository _membersRepository;
  final _log = Logger('SignUpViewModel');

  late Command<(String email, String password, String phone), Result<void>>
  signUp;

  AsyncResult<void> _signUp((String, String, String) credentials) async {
    final (email, password, phone) = credentials;
    final authResult = await _authRepository.signUp(
      email: email,
      password: password,
      phone: phone,
    );

    if (authResult.isError()) {
      _log.warning('SignUp failed', authResult.exceptionOrNull());
      return authResult;
    }

    final result = await _membersRepository.getAllAsync();

    return authResult;
  }
}
