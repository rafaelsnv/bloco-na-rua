import 'package:bloco_na_rua/src/features/auth/interactor/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserAdapter {

  static UserEntity fromFirebaseUser(User user){
    return UserEntity(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
      phone: user.phoneNumber ?? '',
      profileImage: user.photoURL ?? '',
      token: '',
    );
  }
}