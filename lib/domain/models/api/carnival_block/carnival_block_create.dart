// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'carnival_block_create.freezed.dart';
part 'carnival_block_create.g.dart';

@freezed
class CarnivalBlockCreate with _$CarnivalBlockCreate {
  const factory CarnivalBlockCreate({
    String? name,
    required int ownerId,
    String? carnivalBlockImage,
  }) = _CarnivalBlockCreate;

  factory CarnivalBlockCreate.fromJson(Map<String, Object?> json) =>
      _$CarnivalBlockCreateFromJson(json);
}
