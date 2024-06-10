import 'dart:async';
import 'package:bloco_na_rua/src/features/carnival_block/interactor/events/carnival_block_event.dart';
import 'package:bloco_na_rua/src/features/carnival_block/interactor/repositories/icarnival_block_repository.dart';
import 'package:bloco_na_rua/src/features/carnival_block/interactor/states/carnival_block_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

class CarnivalBlockBloc extends Bloc<CarnivalBlockEvent, CarnivalBlockState> {
  final ICarnivalBlockRepository repository;
  GetStorage get storage => GetStorage();

  CarnivalBlockBloc(this.repository)
      : super(LoadingCarnivalBlockState(storage: GetStorage())) {
    on<LoadCarnivalBlockEvent>(_loadCarnivalBlockEvent);
    on<CreateCarnivalBlockEvent>(_createCarnivalBlockEvent);
    on<DeleteCarnivalBlockEvent>(_deleteCarnivalBlockEvent);
  }

  FutureOr<void> _loadCarnivalBlockEvent(
    LoadCarnivalBlockEvent event,
    Emitter<CarnivalBlockState> emit,
  ) async {
    final email = storage.read('email');
    final newState = await repository.getCarnivalBlock(email);
    emit(newState);
  }

  Future<void> _createCarnivalBlockEvent(
    CreateCarnivalBlockEvent event,
    emit,
  ) async {
    emit(LoadingCarnivalBlockState(storage: GetStorage()));

    final newState = await repository.createCarnivalBlock(
      event.id,
      event.name,
      event.owner,
    );

    emit(newState);
  }

  Future<void> _deleteCarnivalBlockEvent(
    DeleteCarnivalBlockEvent event,
    emit,
  ) async {
    emit(LoadingCarnivalBlockState(storage: storage));
    final newState = await repository.deleteCarnivalBlock();
    emit(newState);
  }
}
