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

class UpdatedCarnivalBlockState implements CarnivalBlockState {
  final CarnivalBlockEntity carnivalBlock;

  const UpdatedCarnivalBlockState({
    required this.carnivalBlock,
  });
}

class FailedCarnivalBlockState implements CarnivalBlockState {
  const FailedCarnivalBlockState();
}
