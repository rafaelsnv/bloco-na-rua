// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'carnival_block_update.freezed.dart';
part 'carnival_block_update.g.dart';

@freezed
class CarnivalBlockUpdate with _$CarnivalBlockUpdate {
  const factory CarnivalBlockUpdate({
    String? name,
    String? carnivalBlockImage,
  }) = _CarnivalBlockUpdate;

  factory CarnivalBlockUpdate.fromJson(Map<String, Object?> json) =>
      _$CarnivalBlockUpdateFromJson(json);
}
