import 'package:bloco_na_rua/src/features/auth/data/adapters/user_adapter.dart';
import 'package:bloco_na_rua/src/features/auth/interactor/services/iauth_service.dart';
import 'package:bloco_na_rua/src/features/auth/interactor/states/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

class FirebaseAuthService implements IAuthService {
  final FirebaseAuth firebaseAuth;

  FirebaseAuthService({required this.firebaseAuth});

  @override
  Future<AuthState> createUser(
    String email,
    String password,
    String name,
    String phone,
  ) async {
    try {
      final result = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user == null) {
        return const LogoutedAuthState();
      }
      await result.user?.updateDisplayName(name);
      // TODO: await result.user?.updatePhoneNumber(phone as PhoneAuthCredential);

      return await getUser();
    } catch (e) {
      return const LogoutedAuthState();
    }
  }

  @override
  Future<AuthState> login(String email, String password) async {
    try {
      final result = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user == null) {
        return const LogoutedAuthState();
      }
      final userEntity = UserAdapter.fromFirebaseUser(result.user!);
      final storage = GetStorage();
      await storage.write('email', userEntity.email);
      return LoggedAuthState(user: userEntity);
    } catch (e) {
      return const LogoutedAuthState();
    }
  }

  @override
  Future<AuthState> logout() async {
    final storage = GetStorage();
    await storage.remove('email');
    await firebaseAuth.signOut();
    return const LogoutedAuthState();
  }

  @override
  Future<AuthState> getUser() async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      return const LogoutedAuthState();
    }
    final userEntity = UserAdapter.fromFirebaseUser(user);
    final storage = GetStorage();
    await storage.write('email', userEntity.email);
    return LoggedAuthState(user: userEntity);
  }

  @override
  Future<AuthState> deleteUser() async {
    final user = firebaseAuth.currentUser;

    if (user != null) {
      await user.delete();
    }

    return const LogoutedAuthState();
  }
}
