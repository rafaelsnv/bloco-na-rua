import 'package:bloco_na_rua/data/repositories/carnivalBlocks/icarnival_blocks_repository.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart';
import 'package:command_it/command_it.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:result_dart/result_dart.dart';

class ShowBlockViewModel extends ChangeNotifier {
  ShowBlockViewModel({
    required ICarnivalBlocksRepository carnivalBlocksRepository,
    required this.carnivalBlockId,
  }) : _carnivalBlocksRepository = carnivalBlocksRepository {
    loadCarnivalBlocks = Command.createAsyncNoParam(
      _loadBlocks,
      initialValue: Failure(Exception('Not executed')),
    )..execute();
  }

  final ICarnivalBlocksRepository _carnivalBlocksRepository;
  final String carnivalBlockId;
  final _log = Logger('ShowBlockViewModel');

  late Command<void, Result<CarnivalBlocksEntity>> loadCarnivalBlocks;

  AsyncResult<CarnivalBlocksEntity> _loadBlocks() async {
    final result = await _carnivalBlocksRepository.getByIdAsync(
      int.parse(carnivalBlockId),
    );

    if (result.isError()) {
      _log.warning('Load carnival blocks failed', result.exceptionOrNull());
      return result;
    }
    return result;
  }
}
