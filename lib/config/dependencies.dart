// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:bloco_na_rua/data/repositories/auth_repository.dart';
import 'package:bloco_na_rua/data/repositories/interfaces/iauth_repository.dart';
import 'package:bloco_na_rua/data/repositories/interfaces/imembers_repository.dart';
import 'package:bloco_na_rua/data/repositories/members_repository.dart';
import 'package:bloco_na_rua/data/services/api/api_client.dart';
import 'package:bloco_na_rua/data/services/auth/auth_api_client.dart';
import 'package:bloco_na_rua/data/services/shared_preferencies_service.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

var baseOptions = BaseOptions(
  baseUrl: 'https://bloconarua-dev.azurewebsites.net',
  receiveDataWhenStatusError: true,
);

var supabaseClient = Supabase.instance.client;

List<SingleChildWidget> get providers {
  return [
    Provider<SupabaseClient>(create: (context) => supabaseClient),
    Provider(
      create: (context) => AuthApiClient(supabaseClient: supabaseClient),
    ),
    Provider(
      create: (context) => ApiClient(
        clientFactory: (options) {
          final client = Dio(options);
          client.interceptors.add(PrettyDioLogger());
          return client;
        },
        options: baseOptions,
      ),
    ),
    Provider(create: (context) => SharedPreferencesService()),
    Provider(
      create: (context) =>
          AuthApiClient(supabaseClient: context.read<SupabaseClient>()),
    ),
    Provider<IMembersRepository>(
      create: (context) => MembersRepository(apiClient: context.read()),
    ),
    ChangeNotifierProvider<IAuthRepository>(
      create: (context) => AuthRepository(
        apiClient: context.read(),
        authApiClient: context.read(),
        sharedPreferencesService: context.read(),
      ),
    ),
  ];
}
