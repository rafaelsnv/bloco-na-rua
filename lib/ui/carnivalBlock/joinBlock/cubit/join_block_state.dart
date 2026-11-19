import 'package:bloco_na_rua/ui/carnivalBlock/block_error.dart';
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
  final BlockError error;

  const JoinBlockError(this.error);

  @override
  List<Object?> get props => [error];
}
