// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

enum RolesEnum {
  @JsonValue(0)
  member,
  @JsonValue(1)
  admin,
  @JsonValue(2)
  owner,
}

extension RolesEnumExtension on RolesEnum {
  int get value {
    switch (this) {
      case RolesEnum.member:
        return 0;
      case RolesEnum.admin:
        return 1;
      case RolesEnum.owner:
        return 2;
    }
  }
}
