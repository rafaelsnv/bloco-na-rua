// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'member_update.freezed.dart';
part 'member_update.g.dart';

@freezed
abstract class MemberUpdate with _$MemberUpdate {
  const factory MemberUpdate({
    String? name,
    String? email,
    String? phone,
    String? profileImage,
  }) = _MemberUpdate;

  factory MemberUpdate.fromJson(Map<String, dynamic> json) =>
      _$MemberUpdateFromJson(json);
}
