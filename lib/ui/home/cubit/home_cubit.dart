import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloco_na_rua/core/errors/user_message.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart';
import 'package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart';
import 'package:bloco_na_rua/domain/use_cases/home/get_home_data_use_case.dart';
import 'package:bloco_na_rua/ui/home/cubit/home_state.dart';
import 'package:logging/logging.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required GetHomeDataUseCase getHomeDataUseCase})
    : _getHomeDataUseCase = getHomeDataUseCase,
      super(const HomeState());

  final GetHomeDataUseCase _getHomeDataUseCase;
  final _log = Logger('HomeCubit');

  Future<void> loadHomeData() async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      final results = await Future.wait([
        _getHomeDataUseCase.getCarnivalBlocks(),
        _getHomeDataUseCase.getMeetings(),
      ]);

      final blocksResult = results[0];
      final meetingsResult = results[1];

      if (blocksResult.isError() || meetingsResult.isError()) {
        final error =
            blocksResult.exceptionOrNull() ?? meetingsResult.exceptionOrNull();
        _log.warning('Failed to load home data', error);
        emit(
          state.copyWith(
            status: HomeStatus.failure,
            errorMessage: extractUserMessage(error),
          ),
        );
        return;
      }

      final blocks =
          (blocksResult.getOrNull() as List?)?.cast<CarnivalBlocksEntity>() ??
          [];
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final meetings =
          (meetingsResult.getOrNull() as List?)?.cast<MeetingsEntity>().where((
            m,
          ) {
            final meetingDate = m.meetingDateTime;
            if (meetingDate == null) return false;
            final meetingDay = DateTime(
              meetingDate.year,
              meetingDate.month,
              meetingDate.day,
            );
            return !meetingDay.isBefore(today);
          }).toList() ??
          [];

      emit(
        state.copyWith(
          status: HomeStatus.success,
          blocks: blocks,
          meetings: meetings,
        ),
      );
    } catch (e) {
      _log.severe('Unexpected error during loadHomeData', e);
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: extractUserMessage(e),
        ),
      );
    }
  }
}
