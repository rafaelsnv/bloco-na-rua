import 'package:bloco_na_rua/ui/carnivalBlock/block_error.dart';
import 'package:equatable/equatable.dart';

sealed class CreateBlockState extends Equatable {
  const CreateBlockState();

  @override
  List<Object?> get props => [];
}

final class CreateBlockInitial extends CreateBlockState {}

final class CreateBlockLoading extends CreateBlockState {}

final class CreateBlockSuccess extends CreateBlockState {
  final int blockId;

  const CreateBlockSuccess(this.blockId);
}

final class CreateBlockError extends CreateBlockState {
  final BlockError error;

  const CreateBlockError(this.error);

  @override
  List<Object?> get props => [error];
}
