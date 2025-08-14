// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'carnival_block_member_create.freezed.dart';
part 'carnival_block_member_create.g.dart';

@freezed
class CarnivalBlockMemberCreate with _$CarnivalBlockMemberCreate {
  const factory CarnivalBlockMemberCreate({
    required int carnivalBlockId,
    required int memberId,
    required int role, // Assuming RolesEnum is an int
  }) = _CarnivalBlockMemberCreate;

  factory CarnivalBlockMemberCreate.fromJson(Map<String, Object?> json) =>
      _$CarnivalBlockMemberCreateFromJson(json);
}
