import 'package:equatable/equatable.dart';
import 'package:bloco_na_rua/domain/entities/members/members_entity.dart';

enum AddMemberStatus { initial, loading, success, error }

class AddMemberState extends Equatable {
  const AddMemberState({
    this.status = AddMemberStatus.initial,
    this.allMembers = const [],
    this.filteredMembers = const [],
    this.searchQuery = '',
    this.error,
  });

  final AddMemberStatus status;
  final List<MembersEntity> allMembers;
  final List<MembersEntity> filteredMembers;
  final String searchQuery;

  /// Raw failure captured from the repository, or null when the last load
  /// succeeded. Converted to a user-facing message at render time by
  /// `extractUserMessage`.
  final Object? error;

  AddMemberState copyWith({
    AddMemberStatus? status,
    List<MembersEntity>? allMembers,
    List<MembersEntity>? filteredMembers,
    String? searchQuery,
    Object? error,
  }) {
    return AddMemberState(
      status: status ?? this.status,
      allMembers: allMembers ?? this.allMembers,
      filteredMembers: filteredMembers ?? this.filteredMembers,
      searchQuery: searchQuery ?? this.searchQuery,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    allMembers,
    filteredMembers,
    searchQuery,
    error,
  ];
}
