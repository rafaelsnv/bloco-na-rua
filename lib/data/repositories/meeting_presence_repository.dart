// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:bloco_na_rua/data/services/api/models/meeting_presence/create/meeting_presence_create.dart';
import 'package:bloco_na_rua/data/services/api/models/meeting_presence/update/meeting_presence_update.dart';
import 'package:bloco_na_rua/utils/result.dart';

/// Interface do repository para gerenciamento de presenças em reuniões
abstract class MeetingPresenceRepository {
  /// Busca todas as presenças em reuniões
  Future<Result<List<Map<String, dynamic>>>> getAllMeetingPresences();

  /// Busca uma presença específica por ID
  Future<Result<Map<String, dynamic>>> getMeetingPresenceById(int id);

  /// Registra uma nova presença em reunião
  Future<Result<void>> createMeetingPresence(
    MeetingPresenceCreate presence,
    int loggedMemberId,
  );

  /// Atualiza uma presença em reunião
  Future<Result<void>> updateMeetingPresence(
    int id,
    MeetingPresenceUpdate presence,
    int loggedMemberId,
  );

  /// Exclui uma presença em reunião
  Future<Result<void>> deleteMeetingPresence(int id, int loggedMemberId);
}
