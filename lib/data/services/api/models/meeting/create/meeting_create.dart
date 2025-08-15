// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'meeting_create.freezed.dart';
part 'meeting_create.g.dart';

@freezed
abstract class MeetingCreate with _$MeetingCreate {
  const factory MeetingCreate({
    String? name,
    String? description,
    String? location,
    DateTime? meetingDateTime,
    required int carnivalBlockId,
  }) = _MeetingCreate;

  factory MeetingCreate.fromJson(Map<String, Object?> json) =>
      _$MeetingCreateFromJson(json);
}
