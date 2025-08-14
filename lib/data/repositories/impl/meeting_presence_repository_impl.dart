// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:bloco_na_rua/data/repositories/meeting_presence_repository.dart';
import 'package:bloco_na_rua/data/services/api/api_service.dart';
import 'package:bloco_na_rua/data/services/api/models/meeting_presence/create/meeting_presence_create.dart';
import 'package:bloco_na_rua/data/services/api/models/meeting_presence/update/meeting_presence_update.dart';
import 'package:bloco_na_rua/utils/result.dart';

/// Implementação do repository para gerenciamento de presenças em reuniões
class MeetingPresenceRepositoryImpl implements MeetingPresenceRepository {
  MeetingPresenceRepositoryImpl(this._apiService);

  final ApiService _apiService;

  @override
  Future<Result<List<Map<String, dynamic>>>> getAllMeetingPresences() {
    return _apiService.getMeetingPresences();
  }

  @override
  Future<Result<Map<String, dynamic>>> getMeetingPresenceById(int id) {
    return _apiService.getMeetingPresence(id);
  }

  @override
  Future<Result<void>> createMeetingPresence(
    MeetingPresenceCreate presence,
    int loggedMemberId,
  ) {
    return _apiService.createMeetingPresence(
      memberId: presence.memberId,
      meetingId: presence.meetingId,
      carnivalBlockId: presence.carnivalBlockId,
      isPresent: presence.isPresent,
      loggedMemberId: loggedMemberId,
    );
  }

  @override
  Future<Result<void>> updateMeetingPresence(
    int id,
    MeetingPresenceUpdate presence,
    int loggedMemberId,
  ) {
    return _apiService.updateMeetingPresence(
      id: id,
      isPresent: presence.isPresent,
      loggedMemberId: loggedMemberId,
    );
  }

  @override
  Future<Result<void>> deleteMeetingPresence(int id, int loggedMemberId) {
    return _apiService.deleteMeetingPresence(
      id: id,
      loggedMemberId: loggedMemberId,
    );
  }
}
