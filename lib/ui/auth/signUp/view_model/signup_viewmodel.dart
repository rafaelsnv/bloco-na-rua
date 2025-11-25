import 'package:bloco_na_rua/data/repositories/auth/iauth_repository.dart';
import 'package:bloco_na_rua/data/services/auth/models/signup_request/signup_request.dart';
import 'package:command_it/command_it.dart';
import 'package:logging/logging.dart';
import 'package:result_dart/result_dart.dart';

class SignUpViewModel {
  SignUpViewModel({required IAuthRepository authRepository})
    : _authRepository = authRepository {
    signUp = Command.createAsync<SignUpRequest, Result<void>>(
      initialValue: Failure(Exception('Not executed')),
      _signUp,
    );
  }

  final IAuthRepository _authRepository;
  final _log = Logger('SignUpViewModel');

  late Command<SignUpRequest, Result<void>> signUp;

  AsyncResult<void> _signUp(SignUpRequest credentials) async {
    final authResult = await _authRepository.signUp(credentials);

    if (authResult.isError()) {
      _log.warning('SignUp failed', authResult.exceptionOrNull());
      return authResult;
    }

    var userData = authResult.getOrNull();
    if (userData == null) {
      _log.warning('Login response is null', userData);
      return Failure(Exception('Login response is null'));
    }
    return authResult;
  }
}
