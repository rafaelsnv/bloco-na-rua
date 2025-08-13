// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:bloco_na_rua/data/repositories/meeting_repository.dart';
import 'package:bloco_na_rua/data/services/api/api_service.dart';
import 'package:bloco_na_rua/domain/models/api/meeting/meeting_create.dart';
import 'package:bloco_na_rua/domain/models/api/meeting/meeting_update.dart';
import 'package:bloco_na_rua/utils/result.dart';

/// Implementação do repository para gerenciamento de reuniões
class MeetingRepositoryImpl implements MeetingRepository {
  MeetingRepositoryImpl(this._apiService);

  final ApiService _apiService;

  @override
  Future<Result<List<Map<String, dynamic>>>> getAllMeetings() {
    return _apiService.getMeetings();
  }

  @override
  Future<Result<List<Map<String, dynamic>>>> getMeetingsByBlock(int blockId) {
    return _apiService.getMeetingsByBlock(blockId);
  }

  @override
  Future<Result<void>> createMeeting(
    MeetingCreate meeting,
    int loggedMemberId,
  ) {
    return _apiService.createMeeting(
      name: meeting.name ?? '',
      description: meeting.description ?? '',
      location: meeting.location ?? '',
      meetingDateTime: meeting.meetingDateTime ?? DateTime.now(),
      carnivalBlockId: meeting.carnivalBlockId,
      loggedMemberId: loggedMemberId,
    );
  }

  @override
  Future<Result<void>> updateMeeting(
    int id,
    MeetingUpdate meeting,
    int loggedMemberId,
  ) {
    return _apiService.updateMeeting(
      id: id,
      loggedMemberId: loggedMemberId,
      name: meeting.name,
      description: meeting.description,
      location: meeting.location,
      meetingDateTime: meeting.meetingDateTime,
    );
  }

  @override
  Future<Result<void>> deleteMeeting(int id, int loggedMemberId) {
    return _apiService.deleteMeeting(
      id: id,
      loggedMemberId: loggedMemberId,
    );
  }
}
