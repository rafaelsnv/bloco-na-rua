import 'package:bloco_na_rua/data/repositories/auth/iauth_repository.dart';
import 'package:bloco_na_rua/data/repositories/members/imembers_repository.dart';
import 'package:bloco_na_rua/domain/entities/members/members_entity.dart';
import 'package:result_dart/result_dart.dart';

class GetCurrentUserData {
  final IAuthRepository authRepository;
  final IMembersRepository memberRepository;

  GetCurrentUserData({
    required this.authRepository,
    required this.memberRepository,
  });

  AsyncResult<MembersEntity> call() async {
    // Return cached member if AuthRepository already validated the session
    // (e.g. via the router redirect). This avoids duplicate
    // GET /Members/uuid/{uuid} calls when HomeCubit (and the meetings
    // use case) fire in parallel right after the redirect.
    final cached = authRepository.currentMember;
    if (cached != null) {
      return Success(cached);
    }

    var uuid = await authRepository.currentUuid;
    if (uuid == null || uuid.isEmpty) {
      return Failure(Exception('Failed to get current user UUID'));
    }

    var memberResult = await memberRepository.getByUuidAsync(uuid);
    if (memberResult.isError()) {
      return memberResult;
    }

    var member = memberResult.getOrNull();
    if (member == null) {
      return memberResult;
    }
    return memberResult;
  }
}
