// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:bloco_na_rua/domain/models/api/member/member_create.dart';
import 'package:bloco_na_rua/domain/models/api/member/member_update.dart';
import 'package:bloco_na_rua/utils/result.dart';

/// Interface do repository para gerenciamento de membros
abstract class MemberRepository {
  /// Busca todos os membros
  Future<Result<List<Map<String, dynamic>>>> getAllMembers();

  /// Busca um membro por ID
  Future<Result<Map<String, dynamic>>> getMemberById(int id);

  /// Cria um novo membro
  Future<Result<void>> createMember(MemberCreate member);

  /// Atualiza um membro existente
  Future<Result<void>> updateMember(
    int id,
    MemberUpdate member,
    int loggedMemberId,
  );

  /// Exclui um membro
  Future<Result<void>> deleteMember(int id, int loggedMemberId);
}
