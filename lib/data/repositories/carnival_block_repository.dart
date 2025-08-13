// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:bloco_na_rua/domain/models/api/carnival_block/carnival_block_create.dart';
import 'package:bloco_na_rua/domain/models/api/carnival_block/carnival_block_update.dart';
import 'package:bloco_na_rua/utils/result.dart';

/// Interface do repository para gerenciamento de blocos de carnaval
abstract class CarnivalBlockRepository {
  /// Busca todos os blocos de carnaval
  Future<Result<List<Map<String, dynamic>>>> getAllCarnivalBlocks();

  /// Busca um bloco de carnaval por ID
  Future<Result<Map<String, dynamic>>> getCarnivalBlockById(int id);

  /// Cria um novo bloco de carnaval
  Future<Result<void>> createCarnivalBlock(CarnivalBlockCreate carnivalBlock);

  /// Atualiza um bloco de carnaval existente
  Future<Result<void>> updateCarnivalBlock(
    int id,
    CarnivalBlockUpdate carnivalBlock,
    int loggedMemberId,
  );

  /// Exclui um bloco de carnaval
  Future<Result<void>> deleteCarnivalBlock(int id, int loggedMemberId);
}
