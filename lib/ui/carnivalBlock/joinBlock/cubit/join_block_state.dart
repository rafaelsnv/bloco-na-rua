import 'package:equatable/equatable.dart';

sealed class JoinBlockState extends Equatable {
  const JoinBlockState();

  @override
  List<Object?> get props => [];
}

final class JoinBlockInitial extends JoinBlockState {}

final class JoinBlockLoading extends JoinBlockState {}

final class JoinBlockSuccess extends JoinBlockState {}

final class JoinBlockError extends JoinBlockState {
  final String message;

  const JoinBlockError(this.message);

  @override
  List<Object?> get props => [message];
}
