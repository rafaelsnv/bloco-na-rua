// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'meeting_presence_create.freezed.dart';
part 'meeting_presence_create.g.dart';

@freezed
abstract class MeetingPresenceCreate with _$MeetingPresenceCreate {
  const factory MeetingPresenceCreate({
    required int memberId,
    required int meetingId,
    required int carnivalBlockId,
    required bool isPresent,
  }) = _MeetingPresenceCreate;

  factory MeetingPresenceCreate.fromJson(Map<String, Object?> json) =>
      _$MeetingPresenceCreateFromJson(json);
}
