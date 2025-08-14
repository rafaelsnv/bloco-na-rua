// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'carnival_block_member_update.freezed.dart';
part 'carnival_block_member_update.g.dart';

@freezed
class CarnivalBlockMemberUpdate with _$CarnivalBlockMemberUpdate {
  const factory CarnivalBlockMemberUpdate({
    required int carnivalBlockId,
    required int memberId,
    required int role, // Assuming RolesEnum is an int
  }) = _CarnivalBlockMemberUpdate;

  factory CarnivalBlockMemberUpdate.fromJson(Map<String, Object?> json) =>
      _$CarnivalBlockMemberUpdateFromJson(json);
}
