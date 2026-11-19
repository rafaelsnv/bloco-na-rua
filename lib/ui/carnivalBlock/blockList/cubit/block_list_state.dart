import "package:equatable/equatable.dart";

import "package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart";

/// Status enum for BlockList state machine.
enum BlockListStatus { initial, loading, success, failure }

/// Immutable state class for BlockListCubit.
///
/// Tracks the current status, the list of carnival blocks, and an optional
/// raw failure when in failure state. The failure is converted to a
/// user-facing message at render time by `extractUserMessage`.
class BlockListState extends Equatable {
  const BlockListState({
    this.status = BlockListStatus.initial,
    this.blocks = const [],
    this.error,
  });

  /// Current status in the state machine.
  final BlockListStatus status;

  /// List of carnival blocks loaded from the repository.
  final List<CarnivalBlocksEntity> blocks;

  /// Raw failure present when status is [BlockListStatus.failure].
  final Object? error;

  /// Factory constructor for the initial state.
  factory BlockListState.initial() => const BlockListState();

  /// Factory constructor for the loading state.
  factory BlockListState.loading() =>
      const BlockListState(status: BlockListStatus.loading);

  /// Factory constructor for a successful load with the given blocks.
  factory BlockListState.success(List<CarnivalBlocksEntity> blocks) =>
      BlockListState(status: BlockListStatus.success, blocks: blocks);

  /// Factory constructor for a failed load with the given raw failure.
  factory BlockListState.failure(Object error) =>
      BlockListState(status: BlockListStatus.failure, error: error);

  /// Creates a new state with the given fields replaced.
  BlockListState copyWith({
    BlockListStatus? status,
    List<CarnivalBlocksEntity>? blocks,
    Object? error,
  }) {
    return BlockListState(
      status: status ?? this.status,
      blocks: blocks ?? this.blocks,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, blocks, error];
}
