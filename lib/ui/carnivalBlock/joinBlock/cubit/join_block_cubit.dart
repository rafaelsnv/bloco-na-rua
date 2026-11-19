import 'package:bloco_na_rua/data/repositories/carnivalBlockMembers/icarnival_block_members_repository.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/block_error.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/joinBlock/cubit/join_block_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JoinBlockCubit extends Cubit<JoinBlockState> {
  JoinBlockCubit({
    required ICarnivalBlockMembersRepository carnivalBlockMembersRepository,
  }) : _carnivalBlockMembersRepository = carnivalBlockMembersRepository,
       super(JoinBlockInitial());

  final ICarnivalBlockMembersRepository _carnivalBlockMembersRepository;
  bool _isLoading = false;

  Future<void> joinBlock(String inviteCode) async {
    if (_isLoading) return;
    _isLoading = true;

    if (inviteCode.isEmpty) {
      emit(const JoinBlockError(BlockError(BlockErrorKind.emptyInviteCode)));
      return;
    }

    emit(JoinBlockLoading());

    try {
      final joinResult = await _carnivalBlockMembersRepository
          .joinByInviteCodeAsync(inviteCode);

      joinResult.fold(
        (_) => emit(JoinBlockSuccess()),
        (failure) => emit(
          JoinBlockError(BlockError(BlockErrorKind.joinFailed, failure)),
        ),
      );
    } catch (e) {
      emit(JoinBlockError(BlockError(BlockErrorKind.unexpected, e)));
    } finally {
      _isLoading = false;
    }
  }
}
