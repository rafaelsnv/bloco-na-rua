import 'package:get_storage/get_storage.dart';
import '../entities/carnival_block_entity.dart';

sealed class CarnivalBlockState {}

class LoadingCarnivalBlockState implements CarnivalBlockState {
  final GetStorage storage;

  const LoadingCarnivalBlockState({required this.storage});
}

class CreatedCarnivalBlockState implements CarnivalBlockState {
  final CarnivalBlockEntity carnivalBlock;

  const CreatedCarnivalBlockState({
    required this.carnivalBlock,
  });
}

class InvitedCarnivalBlockState implements CarnivalBlockState {
  final String inviteCode;

  const InvitedCarnivalBlockState({
    required this.inviteCode,
  });
}

class UpdatedCarnivalBlockState implements CarnivalBlockState {
  final CarnivalBlockEntity carnivalBlock;

  const UpdatedCarnivalBlockState({
    required this.carnivalBlock,
  });
}

class FailedCarnivalBlockState implements CarnivalBlockState {
  final String errorMessage;
  const FailedCarnivalBlockState(this.errorMessage);
}

class DeletedCarnivalBlockState implements CarnivalBlockState {
  const DeletedCarnivalBlockState();
}

class LoadedCarnivalBlockState implements CarnivalBlockState {
  final String sessionEmail;
  final List<CarnivalBlockEntity> blockList;

  const LoadedCarnivalBlockState({
    required this.blockList,
    required this.sessionEmail,
  });
}
