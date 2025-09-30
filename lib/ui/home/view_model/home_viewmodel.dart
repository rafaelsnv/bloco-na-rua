import 'package:bloco_na_rua/data/repositories/interfaces/icarnival_block_members_repository.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlockMembers/carnival_block_members_entity.dart';
import 'package:bloco_na_rua/domain/use_cases/auth/get_current_user_data.dart';
import 'package:command_it/command_it.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:result_dart/result_dart.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required ICarnivalBlockMembersRepository blockMembersRepo,
    required GetCurrentUserData getCurrentUserData,
  }) : _blockMembersRepo = blockMembersRepo,
       _getCurrentUserData = getCurrentUserData {
    load = Command.createAsyncNoParam(
      _load,
      initialValue: Failure(Exception('Not executed')),
    )..execute();
  }

  final ICarnivalBlockMembersRepository _blockMembersRepo;
  final GetCurrentUserData _getCurrentUserData;
  final _log = Logger('HomeViewModel');

  late Command<void, Result<List<CarnivalBlockMembersEntity>>> load;

  AsyncResult<List<CarnivalBlockMembersEntity>> _load() async {
    try {
      final userDataResult = await _getCurrentUserData();

      if (userDataResult.isError()) {
        _log.warning('Failed to get user data');
        return Failure(userDataResult.exceptionOrNull()!);
      }

      var userData = userDataResult.getOrNull();
      if (userData == null) {
        _log.warning('User data is null');
        return Failure(userDataResult.exceptionOrNull()!);
      }

      final membersBlockResult = await _blockMembersRepo.getByMemberIdAsync(
        userData.id,
      );
      if (membersBlockResult.isError()) {
        _log.warning(
          'Failed to load block members: ${membersBlockResult.exceptionOrNull()}',
        );
        return Failure(membersBlockResult.exceptionOrNull()!);
      }
      var membersBlock = membersBlockResult.getOrNull();
      if (membersBlock == null || membersBlock.isEmpty) {
        _log.info('No block members found for user ID: $userDataResult');
        return Failure(membersBlockResult.exceptionOrNull()!);
      }
      return Success(membersBlock);
    } catch (e) {
      _log.severe('Unexpected error during load: $e');
      return Failure(Exception('Unexpected error: $e'));
    } finally {
      notifyListeners();
    }
  }
}
