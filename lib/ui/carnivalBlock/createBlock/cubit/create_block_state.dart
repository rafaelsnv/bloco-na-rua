import 'package:equatable/equatable.dart';

sealed class CreateBlockState extends Equatable {
  const CreateBlockState();

  @override
  List<Object?> get props => [];
}

final class CreateBlockInitial extends CreateBlockState {}

final class CreateBlockLoading extends CreateBlockState {}

final class CreateBlockSuccess extends CreateBlockState {}

final class CreateBlockError extends CreateBlockState {
  final String message;

  const CreateBlockError(this.message);

  @override
  List<Object?> get props => [message];
}
