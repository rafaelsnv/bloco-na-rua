import 'package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart';
import 'package:equatable/equatable.dart';

sealed class BlockDetailsState extends Equatable {
  const BlockDetailsState();

  @override
  List<Object?> get props => [];
}

final class BlockDetailsInitial extends BlockDetailsState {}

final class BlockDetailsLoading extends BlockDetailsState {}

final class BlockDetailsLoaded extends BlockDetailsState {
  final CarnivalBlocksEntity carnivalBlock;
  final int? currentMemberId;
  final int? currentMemberRole;
  final bool canManageMembers;

  const BlockDetailsLoaded({
    required this.carnivalBlock,
    this.currentMemberId,
    this.currentMemberRole,
    this.canManageMembers = false,
  });

  BlockDetailsLoaded copyWith({
    CarnivalBlocksEntity? carnivalBlock,
    int? currentMemberId,
    int? currentMemberRole,
    bool? canManageMembers,
  }) {
    return BlockDetailsLoaded(
      carnivalBlock: carnivalBlock ?? this.carnivalBlock,
      currentMemberId: currentMemberId ?? this.currentMemberId,
      currentMemberRole: currentMemberRole ?? this.currentMemberRole,
      canManageMembers: canManageMembers ?? this.canManageMembers,
    );
  }

  @override
  List<Object?> get props => [
    carnivalBlock,
    currentMemberId,
    currentMemberRole,
    canManageMembers,
  ];
}

final class BlockDetailsError extends BlockDetailsState {
  final String message;

  const BlockDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
