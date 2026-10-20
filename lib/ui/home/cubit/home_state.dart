import 'package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart';
import 'package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart';
import 'package:equatable/equatable.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.blocks = const [],
    this.meetings = const [],
    this.errorMessage,
  });

  final HomeStatus status;
  final List<CarnivalBlocksEntity> blocks;
  final List<MeetingsEntity> meetings;
  final String? errorMessage;

  HomeState copyWith({
    HomeStatus? status,
    List<CarnivalBlocksEntity>? blocks,
    List<MeetingsEntity>? meetings,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      blocks: blocks ?? this.blocks,
      meetings: meetings ?? this.meetings,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, blocks, meetings, errorMessage];
}
