// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:bloco_na_rua/data/repositories/auth_repository.dart';
import 'package:bloco_na_rua/data/repositories/members_repository.dart';
import 'package:bloco_na_rua/data/services/api/api_client.dart';
import 'package:bloco_na_rua/data/services/auth/auth_api_client.dart';
import 'package:bloco_na_rua/data/services/shared_preferencies_service.dart';
import 'package:bloco_na_rua/ui/members/view_models/members_viewmodel.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

var baseOptions = BaseOptions(
  baseUrl: 'https://bloconarua-dev.azurewebsites.net',
  receiveDataWhenStatusError: true,
);

final supabaseClient = Supabase.instance.client;

List<SingleChildWidget> get providers {
  return [
    Provider<SupabaseClient>(create: (context) => supabaseClient),
    Provider(
      create: (context) => AuthApiClient(supabaseClient: supabaseClient),
    ),
    Provider(create: (context) => ApiClient(options: baseOptions)),
    Provider(create: (context) => SharedPreferencesService()),
    Provider(
      create: (context) =>
          AuthApiClient(supabaseClient: context.read<SupabaseClient>()),
    ),
    Provider(create: (context) => MembersRepository(apiClient: context.read())),
    ChangeNotifierProvider(
      create: (context) => AuthRepository(
        apiClient: context.read(),
        authApiClient: context.read(),
        sharedPreferencesService: context.read(),
      ),
    ),
    Provider(
      create: (context) => MembersViewModel(membersRepository: context.read()),
    ),
  ];
}
