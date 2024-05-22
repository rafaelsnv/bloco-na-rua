import 'package:bloco_na_rua/src/features/auth/interactor/services/iauth_service.dart';
import 'package:bloco_na_rua/src/features/auth/interactor/states/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../events/auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  final IAuthService service;

  AuthBloc(this.service) : super(const LogoutedAuthState()){
    on<LoginAuthEvent>(_loginAuthEvent);
    on<LogoutAuthEvent>(_logoutAuthEvent);
  }

  Future<void> _loginAuthEvent(LoginAuthEvent event, emit) async {
    emit(const LoadingAuthState());

    final newState = await service.login(
      event.email, 
      event.password,
      );
    emit(newState);
  }

  Future<void> _logoutAuthEvent(event, emit) async {
    emit(const LoadingAuthState());
    await service.logout();
    emit(const LogoutedAuthState());
  }

}