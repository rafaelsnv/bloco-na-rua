// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:bloco_na_rua/data/services/api/api_client.dart';
import 'package:bloco_na_rua/data/services/api/models/carnival_block/create/carnival_block_create.dart';
import 'package:bloco_na_rua/data/services/api/models/carnival_block/update/carnival_block_update.dart';
import 'package:bloco_na_rua/data/services/api/models/carnival_block_member/create/carnival_block_member_create.dart';
import 'package:bloco_na_rua/data/services/api/models/carnival_block_member/update/carnival_block_member_update.dart';
import 'package:bloco_na_rua/data/services/api/models/meeting/create/meeting_create.dart';
import 'package:bloco_na_rua/data/services/api/models/meeting/update/meeting_update.dart';
import 'package:bloco_na_rua/data/services/api/models/meeting_presence/create/meeting_presence_create.dart';
import 'package:bloco_na_rua/data/services/api/models/meeting_presence/update/meeting_presence_update.dart';
import 'package:bloco_na_rua/data/services/api/models/member/create/member_create.dart';
import 'package:bloco_na_rua/data/services/api/models/member/update/member_update.dart';
import 'package:bloco_na_rua/data/services/api/models/roles_enum/roles_enum.dart';
import 'package:bloco_na_rua/utils/result.dart';

/// Serviço de API que encapsula o ApiClient e fornece uma interface mais amigável
class ApiService {
  ApiService({String? host, int? port})
    : _apiClient = ApiClient(host: host, port: port);

  final ApiClient _apiClient;

  // CarnivalBlocks
  Future<Result<List<Map<String, dynamic>>>> getCarnivalBlocks() {
    return _apiClient.getCarnivalBlocks();
  }

  Future<Result<Map<String, dynamic>>> getCarnivalBlock(int id) {
    return _apiClient.getCarnivalBlock(id);
  }

  Future<Result<void>> createCarnivalBlock({
    required String name,
    required int ownerId,
    String? carnivalBlockImage,
  }) {
    final carnivalBlock = CarnivalBlockCreate(
      name: name,
      ownerId: ownerId,
      carnivalBlockImage: carnivalBlockImage,
    );
    return _apiClient.createCarnivalBlock(carnivalBlock);
  }

  Future<Result<void>> updateCarnivalBlock({
    required int id,
    required int loggedMemberId,
    String? name,
    String? carnivalBlockImage,
  }) {
    final carnivalBlock = CarnivalBlockUpdate(
      name: name,
      carnivalBlockImage: carnivalBlockImage,
    );
    return _apiClient.updateCarnivalBlock(id, carnivalBlock, loggedMemberId);
  }

  Future<Result<void>> deleteCarnivalBlock({
    required int id,
    required int loggedMemberId,
  }) {
    return _apiClient.deleteCarnivalBlock(id, loggedMemberId);
  }

  // CarnivalBlockMembers
  Future<Result<List<Map<String, dynamic>>>> getCarnivalBlockMembers() {
    return _apiClient.getCarnivalBlockMembers();
  }

  Future<Result<List<Map<String, dynamic>>>> getCarnivalBlockMembersByBlock(
    int blockId,
  ) {
    return _apiClient.getCarnivalBlockMembersByBlock(blockId);
  }

  Future<Result<void>> createCarnivalBlockMember({
    required int carnivalBlockId,
    required int memberId,
    required RolesEnum role,
    required int loggedMemberId,
  }) {
    final member = CarnivalBlockMemberCreate(
      carnivalBlockId: carnivalBlockId,
      memberId: memberId,
      role: role.value,
    );
    return _apiClient.createCarnivalBlockMember(member, loggedMemberId);
  }

  Future<Result<void>> updateCarnivalBlockMember({
    required int id,
    required int carnivalBlockId,
    required int memberId,
    required RolesEnum role,
    required int loggedMemberId,
  }) {
    final member = CarnivalBlockMemberUpdate(
      carnivalBlockId: carnivalBlockId,
      memberId: memberId,
      role: role.value,
    );
    return _apiClient.updateCarnivalBlockMember(id, member, loggedMemberId);
  }

  Future<Result<void>> deleteCarnivalBlockMember({
    required int id,
    required int loggedMemberId,
  }) {
    return _apiClient.deleteCarnivalBlockMember(id, loggedMemberId);
  }

  // Members
  Future<Result<List<Map<String, dynamic>>>> getMembers() {
    return _apiClient.getMembers();
  }

  Future<Result<Map<String, dynamic>>> getMember(int id) {
    return _apiClient.getMember(id);
  }

  Future<Result<void>> createMember({
    required String name,
    required String email,
    String? phone,
    String? profileImage,
  }) {
    final member = MemberCreate(
      name: name,
      email: email,
      phone: phone,
      profileImage: profileImage,
    );
    return _apiClient.createMember(member);
  }

  Future<Result<void>> updateMember({
    required int id,
    required int loggedMemberId,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
  }) {
    final member = MemberUpdate(
      name: name,
      email: email,
      phone: phone,
      profileImage: profileImage,
    );
    return _apiClient.updateMember(id, member, loggedMemberId);
  }

  Future<Result<void>> deleteMember({
    required int id,
    required int loggedMemberId,
  }) {
    return _apiClient.deleteMember(id, loggedMemberId);
  }

  // Meetings
  Future<Result<List<Map<String, dynamic>>>> getMeetings() {
    return _apiClient.getMeetings();
  }

  Future<Result<List<Map<String, dynamic>>>> getMeetingsByBlock(int blockId) {
    return _apiClient.getMeetingsByBlock(blockId);
  }

  Future<Result<void>> createMeeting({
    required String name,
    required String description,
    required String location,
    required DateTime meetingDateTime,
    required int carnivalBlockId,
    required int loggedMemberId,
  }) {
    final meeting = MeetingCreate(
      name: name,
      description: description,
      location: location,
      meetingDateTime: meetingDateTime,
      carnivalBlockId: carnivalBlockId,
    );
    return _apiClient.createMeeting(meeting, loggedMemberId);
  }

  Future<Result<void>> updateMeeting({
    required int id,
    required int loggedMemberId,
    String? name,
    String? description,
    String? location,
    DateTime? meetingDateTime,
  }) {
    final meeting = MeetingUpdate(
      name: name,
      description: description,
      location: location,
      meetingDateTime: meetingDateTime,
    );
    return _apiClient.updateMeeting(id, meeting, loggedMemberId);
  }

  Future<Result<void>> deleteMeeting({
    required int id,
    required int loggedMemberId,
  }) {
    return _apiClient.deleteMeeting(id, loggedMemberId);
  }

  // MeetingPresences
  Future<Result<List<Map<String, dynamic>>>> getMeetingPresences() {
    return _apiClient.getMeetingPresences();
  }

  Future<Result<Map<String, dynamic>>> getMeetingPresence(int id) {
    return _apiClient.getMeetingPresence(id);
  }

  Future<Result<void>> createMeetingPresence({
    required int memberId,
    required int meetingId,
    required int carnivalBlockId,
    required bool isPresent,
    required int loggedMemberId,
  }) {
    final presence = MeetingPresenceCreate(
      memberId: memberId,
      meetingId: meetingId,
      carnivalBlockId: carnivalBlockId,
      isPresent: isPresent,
    );
    return _apiClient.createMeetingPresence(presence, loggedMemberId);
  }

  Future<Result<void>> updateMeetingPresence({
    required int id,
    required bool isPresent,
    required int loggedMemberId,
  }) {
    final presence = MeetingPresenceUpdate(isPresent: isPresent);
    return _apiClient.updateMeetingPresence(id, presence, loggedMemberId);
  }

  Future<Result<void>> deleteMeetingPresence({
    required int id,
    required int loggedMemberId,
  }) {
    return _apiClient.deleteMeetingPresence(id, loggedMemberId);
  }
}
