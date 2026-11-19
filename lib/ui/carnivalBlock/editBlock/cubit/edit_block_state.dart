import 'package:bloco_na_rua/ui/carnivalBlock/block_error.dart';
import 'package:equatable/equatable.dart';

sealed class EditBlockState extends Equatable {
  const EditBlockState();

  @override
  List<Object?> get props => [];
}

final class EditBlockInitial extends EditBlockState {}

final class EditBlockLoading extends EditBlockState {}

final class EditBlockLoaded extends EditBlockState {
  final int id;
  final String name;
  final String carnivalBlockImage;

  const EditBlockLoaded({
    required this.id,
    required this.name,
    required this.carnivalBlockImage,
  });

  @override
  List<Object?> get props => [id, name, carnivalBlockImage];
}

final class EditBlockSaving extends EditBlockState {}

final class EditBlockSuccess extends EditBlockState {}

/// Deliberately duplicates [EditBlockLoaded] fields: the delete confirmation
/// UI keeps rendering the block while deletion is in flight, so the loaded
/// data must survive the state transition.
final class EditBlockDeleting extends EditBlockState {
  final int id;
  final String name;
  final String carnivalBlockImage;

  const EditBlockDeleting({
    required this.id,
    required this.name,
    required this.carnivalBlockImage,
  });

  @override
  List<Object?> get props => [id, name, carnivalBlockImage];
}

final class EditBlockError extends EditBlockState {
  final BlockError error;

  const EditBlockError(this.error);

  @override
  List<Object?> get props => [error];
}

final class EditBlockDeleted extends EditBlockState {}
