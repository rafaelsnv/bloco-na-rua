import 'package:bloco_na_rua/data/repositories/interfaces/imembers_repository.dart';
import 'package:bloco_na_rua/domain/entities/members_entity.dart';
import 'package:command_it/command_it.dart';
import 'package:logging/logging.dart';
import 'package:result_dart/result_dart.dart';

class MembersViewModel {
  MembersViewModel({required IMembersRepository membersRepository})
    : _membersRepository = membersRepository {
    loadMembers = Command.createAsyncNoParam(
      _loadMembers,
      initialValue: Failure(Exception('Not executed')),
    );
  }

  final IMembersRepository _membersRepository;
  final _log = Logger('MembersViewModel');

  late Command<void, Result<List<MembersEntity>>> loadMembers;

  AsyncResult<List<MembersEntity>> _loadMembers() async {
    final result = await _membersRepository.getAllAsync();

    if (result.isError()) {
      _log.warning('Load members failed', result.exceptionOrNull());
      return result;
    }
    return result;
  }
}
