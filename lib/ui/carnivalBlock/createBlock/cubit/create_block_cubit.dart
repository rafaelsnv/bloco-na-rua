import 'dart:math';

import 'package:bloco_na_rua/data/repositories/carnivalBlocks/icarnival_blocks_repository.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/createBlock/cubit/create_block_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateBlockCubit extends Cubit<CreateBlockState> {
  CreateBlockCubit({
    required ICarnivalBlocksRepository carnivalBlocksRepository,
  }) : _carnivalBlocksRepository = carnivalBlocksRepository,
       super(CreateBlockInitial());

  final ICarnivalBlocksRepository _carnivalBlocksRepository;

  Future<void> createBlock(String name) async {
    emit(CreateBlockLoading());

    final inviteCode = _generateInviteCode();
    final data = {
      'name': name,
      'ownerId': 0,
      'inviteCode': inviteCode,
      'managersInviteCode': inviteCode,
      'carnivalBlockImage': '',
    };

    final result = await _carnivalBlocksRepository.createAsync(data);

    result.fold(
      (_) => emit(CreateBlockSuccess()),
      (failure) => emit(CreateBlockError(failure.toString())),
    );
  }

  String _generateInviteCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(6, (_) => chars[random.nextInt(chars.length)]).join();
  }
}
