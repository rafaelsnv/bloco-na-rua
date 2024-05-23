import 'package:bloco_na_rua/src/features/auth/data/services/adapters/user_adapter.dart';
import 'package:bloco_na_rua/src/features/auth/interactor/services/iauth_service.dart';
import 'package:bloco_na_rua/src/features/auth/interactor/states/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      // await result.user?.updatePhoneNumber(phone as PhoneAuthCredential); // TO-DO
      final user = UserAdapter.fromFirebaseUser(result.user!);
      return LoggedAuthState(user: user);
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
      final user = UserAdapter.fromFirebaseUser(result.user!);
      return LoggedAuthState(user: user);
    } catch (e) {
      return const LogoutedAuthState();
    }
  }

  @override
  Future<AuthState> logout() async {
    await firebaseAuth.signOut();
    return const LogoutedAuthState();
  }

  @override
  AuthState getUser() {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      return const LogoutedAuthState();
    }
    final userEntity = UserAdapter.fromFirebaseUser(user);
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
