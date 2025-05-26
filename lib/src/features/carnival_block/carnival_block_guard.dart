import 'dart:async';

import 'package:bloco_na_rua/src/features/carnival_block/interactor/blocs/carnival_block_bloc.dart';
import 'package:bloco_na_rua/src/features/carnival_block/interactor/states/carnival_block_state.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CarnivalBlockGuard extends RouteGuard {
  CarnivalBlockGuard() : super(redirectTo: '/block/view_block');

  @override
  FutureOr<bool> canActivate(String path, ParallelRoute route) async {
    final state = Modular.get<CarnivalBlockBloc>().state;
    return state is LoadedCarnivalBlockState;
  }
}
