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
  final String message;

  const EditBlockError(this.message);

  @override
  List<Object?> get props => [message];
}

final class EditBlockDeleted extends EditBlockState {}
