import 'package:bloco_na_rua/domain/entities/members/members_entity.dart';
import 'package:equatable/equatable.dart';

enum MembersStatus { initial, loading, success, error }

class MembersState extends Equatable {
  const MembersState({
    this.status = MembersStatus.initial,
    this.members = const [],
    this.errorMessage,
  });

  final MembersStatus status;
  final List<MembersEntity> members;
  final String? errorMessage;

  MembersState copyWith({
    MembersStatus? status,
    List<MembersEntity>? members,
    String? errorMessage,
  }) {
    return MembersState(
      status: status ?? this.status,
      members: members ?? this.members,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, members, errorMessage];
}
