// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'member_create.freezed.dart';
part 'member_create.g.dart';

@freezed
class MemberCreate with _$MemberCreate {
  const factory MemberCreate({
    String? name,
    String? email,
    String? phone,
    String? profileImage,
  }) = _MemberCreate;

  factory MemberCreate.fromJson(Map<String, Object?> json) =>
      _$MemberCreateFromJson(json);
}
