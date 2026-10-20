import 'package:bloco_na_rua/data/repositories/auth/iauth_repository.dart';
import 'package:bloco_na_rua/data/repositories/members/imembers_repository.dart';
import 'package:bloco_na_rua/domain/entities/members/members_entity.dart';
import 'package:result_dart/result_dart.dart';

class GetCurrentUserData {
  GetCurrentUserData({
    required this.authRepository,
    required this.memberRepository,
  });

  final IAuthRepository authRepository;
  final IMembersRepository memberRepository;

  /// In-flight cache: if `call()` is invoked concurrently, all callers share
  /// the same `Future` instead of each triggering their own
  /// `getByUuidAsync` (which would fire duplicate API requests).
  AsyncResult<MembersEntity>? _inFlightResult;

  AsyncResult<MembersEntity> call() async {
    // Return cached member if AuthRepository already validated the session
    // (e.g. via the router redirect).
    final cached = authRepository.currentMember;
    if (cached != null) {
      return Success(cached);
    }

    // Return in-flight result if another call is already fetching user data.
    // This prevents duplicate API calls when HomeCubit fires multiple requests
    // in parallel via Future.wait().
    if (_inFlightResult != null) {
      return _inFlightResult!;
    }

    _inFlightResult = _fetchUserData();
    return _inFlightResult!;
  }

  AsyncResult<MembersEntity> _fetchUserData() async {
    try {
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

      // Cache the result in AuthRepository for other callers.
      authRepository.setCurrentMember(member);
      return memberResult;
    } finally {
      // Clear the in-flight cache after completion so a future call
      // (after logout/login) can fetch fresh data.
      _inFlightResult = null;
    }
  }
}
