// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:bloco_na_rua/domain/models/api/carnival_block_member/carnival_block_member_create.dart';
import 'package:bloco_na_rua/domain/models/api/carnival_block_member/carnival_block_member_update.dart';
import 'package:bloco_na_rua/utils/result.dart';

/// Interface do repository para gerenciamento de membros de blocos de carnaval
abstract class CarnivalBlockMemberRepository {
  /// Busca todos os membros de blocos de carnaval
  Future<Result<List<Map<String, dynamic>>>> getAllCarnivalBlockMembers();

  /// Busca membros de um bloco específico
  Future<Result<List<Map<String, dynamic>>>> getCarnivalBlockMembersByBlock(int blockId);

  /// Adiciona um membro a um bloco de carnaval
  Future<Result<void>> createCarnivalBlockMember(
    CarnivalBlockMemberCreate member,
    int loggedMemberId,
  );

  /// Atualiza um membro de bloco de carnaval
  Future<Result<void>> updateCarnivalBlockMember(
    int id,
    CarnivalBlockMemberUpdate member,
    int loggedMemberId,
  );

  /// Remove um membro de um bloco de carnaval
  Future<Result<void>> deleteCarnivalBlockMember(int id, int loggedMemberId);
}
