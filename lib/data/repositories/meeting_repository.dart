// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:bloco_na_rua/domain/models/api/meeting/meeting_create.dart';
import 'package:bloco_na_rua/domain/models/api/meeting/meeting_update.dart';
import 'package:bloco_na_rua/utils/result.dart';

/// Interface do repository para gerenciamento de reuniões
abstract class MeetingRepository {
  /// Busca todas as reuniões
  Future<Result<List<Map<String, dynamic>>>> getAllMeetings();

  /// Busca reuniões de um bloco específico
  Future<Result<List<Map<String, dynamic>>>> getMeetingsByBlock(int blockId);

  /// Cria uma nova reunião
  Future<Result<void>> createMeeting(
    MeetingCreate meeting,
    int loggedMemberId,
  );

  /// Atualiza uma reunião existente
  Future<Result<void>> updateMeeting(
    int id,
    MeetingUpdate meeting,
    int loggedMemberId,
  );

  /// Exclui uma reunião
  Future<Result<void>> deleteMeeting(int id, int loggedMemberId);
}
