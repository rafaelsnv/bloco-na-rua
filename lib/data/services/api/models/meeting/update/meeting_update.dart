// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'meeting_update.freezed.dart';
part 'meeting_update.g.dart';

@freezed
abstract class MeetingUpdate with _$MeetingUpdate {
  const factory MeetingUpdate({
    String? name,
    String? description,
    String? location,
    DateTime? meetingDateTime,
  }) = _MeetingUpdate;

  factory MeetingUpdate.fromJson(Map<String, Object?> json) =>
      _$MeetingUpdateFromJson(json);
}
