// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:bloco_na_rua/data/repositories/members_repository.dart';
import 'package:bloco_na_rua/data/services/api/api_client.dart';
import 'package:bloco_na_rua/data/services/api/api_client_dio.dart';
import 'package:bloco_na_rua/ui/members/view_models/members_viewmodel.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

var baseOptions = BaseOptions(
  baseUrl: 'https://bloconarua-dev.azurewebsites.net',
  receiveDataWhenStatusError: true,
);

List<SingleChildWidget> get providers {
  return [
    Provider(create: (context) => ApiClient()),
    Provider(create: (context) => ApiClientDio(options: baseOptions)),
    Provider(create: (context) => MembersRepository(apiClient: context.read())),
    ChangeNotifierProvider(
      create: (context) => MembersViewModel(membersRepository: context.read()),
    ),
  ];
}
