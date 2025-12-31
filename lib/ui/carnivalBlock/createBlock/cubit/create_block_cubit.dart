import 'package:bloco_na_rua/ui/carnivalBlock/createBlock/cubit/create_block_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateBlockCubit extends Cubit<CreateBlockState> {
  CreateBlockCubit() : super(CreateBlockInitial());

  // Logic for creating a block would go here
  Future<void> createBlock(String name) async {
    emit(CreateBlockLoading());
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    emit(CreateBlockSuccess());
  }
}
