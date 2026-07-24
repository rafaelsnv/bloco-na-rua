import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloco_na_rua/core/errors/user_message.dart';
import 'package:bloco_na_rua/data/repositories/auth/iauth_repository.dart';
import 'package:bloco_na_rua/data/repositories/members/imembers_repository.dart';
import 'package:bloco_na_rua/domain/entities/members/members_entity.dart';

part 'profile_cubit.freezed.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required IAuthRepository authRepository,
    required IMembersRepository membersRepository,
  }) : _authRepository = authRepository,
       _membersRepository = membersRepository,
       super(const ProfileState.initial());

  final IAuthRepository _authRepository;
  final IMembersRepository _membersRepository;

  Future<void> loadProfile() async {
    emit(const ProfileState.loading());

    final uuidResult = await _authRepository.currentUuid;
    if (uuidResult == null) {
      emit(const ProfileState.error('Usuário não autenticado'));
      return;
    }

    final result = await _membersRepository.getByUuidAsync(uuidResult);

    result.fold(
      (member) => emit(ProfileState.loaded(member: member)),
      (error) => emit(ProfileState.error(extractUserMessage(error))),
    );
  }

  Future<void> logout() async {
    emit(const ProfileState.loading());
    final result = await _authRepository.logout();

    result.fold(
      (_) => emit(const ProfileState.initial()),
      (error) => emit(ProfileState.error(extractUserMessage(error))),
    );
  }
}
