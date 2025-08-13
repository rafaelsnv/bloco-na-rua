// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:bloco_na_rua/data/repositories/carnival_block_member_repository.dart';
import 'package:bloco_na_rua/data/services/api/api_service.dart';
import 'package:bloco_na_rua/domain/models/api/carnival_block_member/carnival_block_member_create.dart';
import 'package:bloco_na_rua/domain/models/api/carnival_block_member/carnival_block_member_update.dart';
import 'package:bloco_na_rua/domain/models/api/roles_enum/roles_enum.dart';
import 'package:bloco_na_rua/utils/result.dart';

/// Implementação do repository para gerenciamento de membros de blocos de carnaval
class CarnivalBlockMemberRepositoryImpl implements CarnivalBlockMemberRepository {
  CarnivalBlockMemberRepositoryImpl(this._apiService);

  final ApiService _apiService;

  @override
  Future<Result<List<Map<String, dynamic>>>> getAllCarnivalBlockMembers() {
    return _apiService.getCarnivalBlockMembers();
  }

  @override
  Future<Result<List<Map<String, dynamic>>>> getCarnivalBlockMembersByBlock(int blockId) {
    return _apiService.getCarnivalBlockMembersByBlock(blockId);
  }

  @override
  Future<Result<void>> createCarnivalBlockMember(
    CarnivalBlockMemberCreate member,
    int loggedMemberId,
  ) {
    // Converter o valor int do role para RolesEnum
    final role = _intToRolesEnum(member.role);

    return _apiService.createCarnivalBlockMember(
      carnivalBlockId: member.carnivalBlockId,
      memberId: member.memberId,
      role: role,
      loggedMemberId: loggedMemberId,
    );
  }

  @override
  Future<Result<void>> updateCarnivalBlockMember(
    int id,
    CarnivalBlockMemberUpdate member,
    int loggedMemberId,
  ) {
    // Converter o valor int do role para RolesEnum
    final role = _intToRolesEnum(member.role);

    return _apiService.updateCarnivalBlockMember(
      id: id,
      carnivalBlockId: member.carnivalBlockId,
      memberId: member.memberId,
      role: role,
      loggedMemberId: loggedMemberId,
    );
  }

  @override
  Future<Result<void>> deleteCarnivalBlockMember(int id, int loggedMemberId) {
    return _apiService.deleteCarnivalBlockMember(
      id: id,
      loggedMemberId: loggedMemberId,
    );
  }

  /// Converte um valor int para RolesEnum
  RolesEnum _intToRolesEnum(int value) {
    switch (value) {
      case 0:
        return RolesEnum.member;
      case 1:
        return RolesEnum.admin;
      case 2:
        return RolesEnum.owner;
      default:
        return RolesEnum.member; // Valor padrão
    }
  }
}
