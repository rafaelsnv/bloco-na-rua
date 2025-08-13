// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:bloco_na_rua/data/repositories/carnival_block_repository.dart';
import 'package:bloco_na_rua/data/services/api/api_service.dart';
import 'package:bloco_na_rua/domain/models/api/carnival_block/carnival_block_create.dart';
import 'package:bloco_na_rua/domain/models/api/carnival_block/carnival_block_update.dart';
import 'package:bloco_na_rua/utils/result.dart';

/// Implementação do repository para gerenciamento de blocos de carnaval
class CarnivalBlockRepositoryImpl implements CarnivalBlockRepository {
  CarnivalBlockRepositoryImpl(this._apiService);

  final ApiService _apiService;

  @override
  Future<Result<List<Map<String, dynamic>>>> getAllCarnivalBlocks() {
    return _apiService.getCarnivalBlocks();
  }

  @override
  Future<Result<Map<String, dynamic>>> getCarnivalBlockById(int id) {
    return _apiService.getCarnivalBlock(id);
  }

  @override
  Future<Result<void>> createCarnivalBlock(CarnivalBlockCreate carnivalBlock) {
    return _apiService.createCarnivalBlock(
      name: carnivalBlock.name ?? '',
      ownerId: carnivalBlock.ownerId,
      carnivalBlockImage: carnivalBlock.carnivalBlockImage,
    );
  }

  @override
  Future<Result<void>> updateCarnivalBlock(
    int id,
    CarnivalBlockUpdate carnivalBlock,
    int loggedMemberId,
  ) {
    return _apiService.updateCarnivalBlock(
      id: id,
      loggedMemberId: loggedMemberId,
      name: carnivalBlock.name,
      carnivalBlockImage: carnivalBlock.carnivalBlockImage,
    );
  }

  @override
  Future<Result<void>> deleteCarnivalBlock(int id, int loggedMemberId) {
    return _apiService.deleteCarnivalBlock(
      id: id,
      loggedMemberId: loggedMemberId,
    );
  }
}
