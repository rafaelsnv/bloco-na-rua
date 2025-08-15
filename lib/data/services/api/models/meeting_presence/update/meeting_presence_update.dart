// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'meeting_presence_update.freezed.dart';
part 'meeting_presence_update.g.dart';

@freezed
abstract class MeetingPresenceUpdate with _$MeetingPresenceUpdate {
  const factory MeetingPresenceUpdate({required bool isPresent}) =
      _MeetingPresenceUpdate;

  factory MeetingPresenceUpdate.fromJson(Map<String, Object?> json) =>
      _$MeetingPresenceUpdateFromJson(json);
}
