import 'package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart';
import 'package:bloco_na_rua/domain/entities/meetings/meeting_entity.dart';
import 'package:bloco_na_rua/domain/use_cases/home/get_home_data_use_case.dart';
import 'package:command_it/command_it.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:result_dart/result_dart.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required GetHomeDataUseCase getHomeDataUseCase})
    : _getHomeDataUseCase = getHomeDataUseCase {
    loadCarnivalBlocks = Command.createAsyncNoParam(
      _loadBlocks,
      initialValue: Failure(Exception('Not executed')),
    )..execute();
    loadMeetings = Command.createAsyncNoParam(
      _loadMeetings,
      initialValue: Failure(Exception('Not executed')),
    )..execute();
  }

  final GetHomeDataUseCase _getHomeDataUseCase;
  final _log = Logger('HomeViewModel');

  late Command<void, Result<List<CarnivalBlocksEntity>>> loadCarnivalBlocks;
  late Command<void, Result<List<MeetingEntity>>> loadMeetings;

  AsyncResult<List<MeetingEntity>> _loadMeetings() async {
    final result = await _getHomeDataUseCase.getMeetings();

    if (result.isError()) {
      _log.warning('Load meetings failed', result.exceptionOrNull());
      return result;
    }
    return result;
  }

  AsyncResult<List<CarnivalBlocksEntity>> _loadBlocks() async {
    final result = await _getHomeDataUseCase.getCarnivalBlocks();

    if (result.isError()) {
      _log.warning('Load meetings failed', result.exceptionOrNull());
      return result;
    }
    return result;
  }
}
