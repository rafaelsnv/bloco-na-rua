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

  const BlockDetailsLoaded(this.carnivalBlock);

  @override
  List<Object?> get props => [carnivalBlock];
}

final class BlockDetailsError extends BlockDetailsState {
  final String message;

  const BlockDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
