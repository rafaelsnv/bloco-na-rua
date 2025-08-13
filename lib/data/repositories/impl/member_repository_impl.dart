// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:bloco_na_rua/data/repositories/member_repository.dart';
import 'package:bloco_na_rua/data/services/api/api_service.dart';
import 'package:bloco_na_rua/domain/models/api/member/member_create.dart';
import 'package:bloco_na_rua/domain/models/api/member/member_update.dart';
import 'package:bloco_na_rua/utils/result.dart';

/// Implementação do repository para gerenciamento de membros
class MemberRepositoryImpl implements MemberRepository {
  MemberRepositoryImpl(this._apiService);

  final ApiService _apiService;

  @override
  Future<Result<List<Map<String, dynamic>>>> getAllMembers() {
    return _apiService.getMembers();
  }

  @override
  Future<Result<Map<String, dynamic>>> getMemberById(int id) {
    return _apiService.getMember(id);
  }

  @override
  Future<Result<void>> createMember(MemberCreate member) {
    return _apiService.createMember(
      name: member.name ?? '',
      email: member.email ?? '',
      phone: member.phone,
      profileImage: member.profileImage,
    );
  }

  @override
  Future<Result<void>> updateMember(
    int id,
    MemberUpdate member,
    int loggedMemberId,
  ) {
    return _apiService.updateMember(
      id: id,
      loggedMemberId: loggedMemberId,
      name: member.name,
      email: member.email,
      phone: member.phone,
      profileImage: member.profileImage,
    );
  }

  @override
  Future<Result<void>> deleteMember(int id, int loggedMemberId) {
    return _apiService.deleteMember(
      id: id,
      loggedMemberId: loggedMemberId,
    );
  }
}
