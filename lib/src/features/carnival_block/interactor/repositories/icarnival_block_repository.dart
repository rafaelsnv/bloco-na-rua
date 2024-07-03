import 'dart:async';

import 'package:bloco_na_rua/src/features/carnival_block/interactor/entities/carnival_block_entity.dart';

import '../states/carnival_block_state.dart';

abstract interface class ICarnivalBlockRepository {
  Future<CarnivalBlockState> createCarnivalBlock(
    int id,
    String name,
    String owner,
  );

  Future<String> getInviteCode(
    CarnivalBlockEntity carnivalBlock,
  );

  Future<List<CarnivalBlockEntity>> getCarnivalBlocksList(
    String email,
  );

  Future<CarnivalBlockState> updateCarnivalBlock(
    String id,
    String name,
    String owner,
  );

  Future<CarnivalBlockState> joinCarnivalBlock(
    String code,
    String email,
  );

  Future<CarnivalBlockState> deleteCarnivalBlock(
    String email,
    CarnivalBlockEntity carnivalBlock,
  );
}
