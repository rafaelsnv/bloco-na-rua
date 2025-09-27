import 'package:bloco_na_rua/data/repositories/interfaces/iauth_repository.dart';

class GetCurrentUserIdUseCase {
  final IAuthRepository authRepository;

  GetCurrentUserIdUseCase({required this.authRepository});

  Future<String?> call() {
    return authRepository.currentUserId;
  }
}
