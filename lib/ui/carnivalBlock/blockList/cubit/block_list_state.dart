import "package:equatable/equatable.dart";

import "package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart";

/// Status enum for BlockList state machine.
enum BlockListStatus { initial, loading, success, failure }

/// Immutable state class for BlockListCubit.
///
/// Tracks the current status, the list of carnival blocks, and an optional
/// error message when in failure state.
class BlockListState extends Equatable {
  const BlockListState({
    this.status = BlockListStatus.initial,
    this.blocks = const [],
    this.errorMessage,
  });

  /// Current status in the state machine.
  final BlockListStatus status;

  /// List of carnival blocks loaded from the repository.
  final List<CarnivalBlocksEntity> blocks;

  /// Error message present when status is [BlockListStatus.failure].
  final String? errorMessage;

  /// Factory constructor for the initial state.
  factory BlockListState.initial() => const BlockListState();

  /// Factory constructor for the loading state.
  factory BlockListState.loading() =>
      const BlockListState(status: BlockListStatus.loading);

  /// Factory constructor for a successful load with the given blocks.
  factory BlockListState.success(List<CarnivalBlocksEntity> blocks) =>
      BlockListState(status: BlockListStatus.success, blocks: blocks);

  /// Factory constructor for a failed load with the given error message.
  factory BlockListState.failure(String errorMessage) => BlockListState(
    status: BlockListStatus.failure,
    errorMessage: errorMessage,
  );

  /// Creates a new state with the given fields replaced.
  BlockListState copyWith({
    BlockListStatus? status,
    List<CarnivalBlocksEntity>? blocks,
    String? errorMessage,
  }) {
    return BlockListState(
      status: status ?? this.status,
      blocks: blocks ?? this.blocks,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, blocks, errorMessage];
}
