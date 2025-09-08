import 'package:bloco_na_rua/data/repositories/interfaces/iauth_repository.dart';
import 'package:command_it/command_it.dart';
import 'package:logging/logging.dart';
import 'package:result_dart/result_dart.dart';

class LogoutViewModel {
  LogoutViewModel({required IAuthRepository authRepository})
    : _authRepository = authRepository {
    logout = Command.createAsyncNoParamNoResult(_logout);
  }

  final IAuthRepository _authRepository;
  final _log = Logger('LogoutViewmodel');

  late Command logout;

  AsyncResult<void> _logout() async {
    final result = await _authRepository.logout();

    if (result.isError()) {
      _log.warning('Logout failed', result.exceptionOrNull());
      return result;
    }
    return result;
  }
}
