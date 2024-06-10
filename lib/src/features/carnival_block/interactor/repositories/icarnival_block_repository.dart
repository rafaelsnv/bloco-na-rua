import 'dart:async';

import '../states/carnival_block_state.dart';

abstract interface class ICarnivalBlockRepository {
  Future<CarnivalBlockState> createCarnivalBlock(
    int id,
    String name,
    String owner,
  );

  Future<CarnivalBlockState> getCarnivalBlock(
    String email,
  );

  Future<CarnivalBlockState> updateCarnivalBlock(
    String id,
    String name,
    String owner,
  );

  Future<CarnivalBlockState> deleteCarnivalBlock();
}
