import 'package:bloco_na_rua/data/repositories/members/imembers_repository.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart';
import 'package:bloco_na_rua/domain/entities/meetings/meeting_entity.dart';
import 'package:bloco_na_rua/domain/entities/members/members_entity.dart';
import 'package:bloco_na_rua/domain/use_cases/auth/get_current_user_data.dart';
import 'package:logging/logging.dart';
import 'package:result_dart/result_dart.dart';

class GetHomeDataUseCase {
  GetHomeDataUseCase({
    required GetCurrentUserData getCurrentUserData,
    required IMembersRepository membersRepo,
  }) : _membersRepo = membersRepo,
       _getCurrentUserData = getCurrentUserData;

  final GetCurrentUserData _getCurrentUserData;
  final IMembersRepository _membersRepo;
  final _log = Logger('GetHomeDataUseCase');

  AsyncResult<List<CarnivalBlocksEntity>> getCarnivalBlocks() async {
    try {
      final userDataResult = await _getUserData();

      if (userDataResult.isError()) {
        return Failure(userDataResult.exceptionOrNull()!);
      }

      var userData = userDataResult.getOrNull()!;

      final memberBlockListResult = await _membersRepo.getBlocksByMemberId(
        userData.id,
      );
      if (memberBlockListResult.isError()) {
        _log.warning(
          'Failed to load block members: ${memberBlockListResult.exceptionOrNull()}',
        );
        return Failure(memberBlockListResult.exceptionOrNull()!);
      }
      var memberBlockList = memberBlockListResult.getOrNull();
      if (memberBlockList == null || memberBlockList.isEmpty) {
        _log.info('No block members found for user ID: ${userData.id}');
        return Success([]);
      }

      return Success(memberBlockList);
    } catch (e) {
      _log.severe('Unexpected error during load: $e');
      return Failure(Exception('Unexpected error: $e'));
    }
  }

  AsyncResult<List<MeetingEntity>> getMeetings() async {
    try {
      final userDataResult = await _getUserData();

      if (userDataResult.isError()) {
        return Failure(userDataResult.exceptionOrNull()!);
      }

      var userData = userDataResult.getOrNull()!;

      final meetingsListResult = await _membersRepo.getMeetingsByMemberId(
        userData.id,
      );

      if (meetingsListResult.isError()) {
        _log.warning(
          'Failed to load meetings: ${meetingsListResult.exceptionOrNull()}',
        );
        return Failure(meetingsListResult.exceptionOrNull()!);
      }

      var meetingsList = meetingsListResult.getOrNull();
      if (meetingsList == null || meetingsList.isEmpty) {
        _log.info('No meetings found for user ID: ${userData.id}');
        return Success([]);
      }

      return Success(meetingsList);
    } catch (e) {
      _log.severe('Unexpected error during load: $e');
      return Failure(Exception('Unexpected error: $e'));
    }
  }

  AsyncResult<MembersEntity> _getUserData() async {
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

    return Success(userData);
  }
}
