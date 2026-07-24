import 'package:bloco_na_rua/data/repositories/members/imembers_repository.dart';
import 'package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart';
import 'package:bloco_na_rua/domain/use_cases/auth/get_current_user_data.dart';
import 'package:logging/logging.dart';
import 'package:result_dart/result_dart.dart';

class GetUserMeetingsUseCase {
  GetUserMeetingsUseCase({
    required GetCurrentUserData getCurrentUserData,
    required IMembersRepository membersRepo,
  }) : _membersRepo = membersRepo,
       _getCurrentUserData = getCurrentUserData;

  final GetCurrentUserData _getCurrentUserData;
  final IMembersRepository _membersRepo;
  final _log = Logger('GetUserMeetingsUseCase');

  AsyncResult<List<MeetingsEntity>> call() async {
    try {
      final userDataResult = await _getCurrentUserData();
      if (userDataResult.isError()) {
        _log.warning('Failed to get user data');
        return Failure(userDataResult.exceptionOrNull()!);
      }
      final userData = userDataResult.getOrNull();
      if (userData == null) {
        _log.warning('User data is null');
        return Failure(userDataResult.exceptionOrNull()!);
      }

      final meetingsListResult = await _membersRepo.getMeetingsByMemberId(
        userData.id,
      );

      if (meetingsListResult.isError()) {
        _log.warning(
          'Failed to load meetings: ${meetingsListResult.exceptionOrNull()}',
        );
        return Failure(meetingsListResult.exceptionOrNull()!);
      }

      final meetingsList = meetingsListResult.getOrNull();
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
}
