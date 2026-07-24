import 'package:equatable/equatable.dart';
import 'package:bloco_na_rua/domain/entities/members/members_entity.dart';

enum AddMemberStatus { initial, loading, success, error }

class AddMemberState extends Equatable {
  const AddMemberState({
    this.status = AddMemberStatus.initial,
    this.allMembers = const [],
    this.filteredMembers = const [],
    this.searchQuery = '',
    this.errorMessage,
  });

  final AddMemberStatus status;
  final List<MembersEntity> allMembers;
  final List<MembersEntity> filteredMembers;
  final String searchQuery;
  final String? errorMessage;

  AddMemberState copyWith({
    AddMemberStatus? status,
    List<MembersEntity>? allMembers,
    List<MembersEntity>? filteredMembers,
    String? searchQuery,
    String? errorMessage,
  }) {
    return AddMemberState(
      status: status ?? this.status,
      allMembers: allMembers ?? this.allMembers,
      filteredMembers: filteredMembers ?? this.filteredMembers,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    allMembers,
    filteredMembers,
    searchQuery,
    errorMessage,
  ];
}
