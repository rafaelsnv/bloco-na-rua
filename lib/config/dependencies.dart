// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:bloco_na_rua/data/repositories/auth_repository.dart';
import 'package:bloco_na_rua/data/repositories/interfaces/iauth_repository.dart';
import 'package:bloco_na_rua/data/repositories/interfaces/imembers_repository.dart';
import 'package:bloco_na_rua/data/repositories/members_repository.dart';
import 'package:bloco_na_rua/data/services/api/base/base_api_client.dart';
import 'package:bloco_na_rua/data/services/api/base/ibase_api_client.dart';
import 'package:bloco_na_rua/data/services/api/members/imembers_api_client.dart';
import 'package:bloco_na_rua/data/services/api/members/members_api_client.dart';
import 'package:bloco_na_rua/data/services/auth/auth_api_client.dart';
import 'package:bloco_na_rua/data/services/shared_preferencies_service.dart';
import 'package:bloco_na_rua/domain/use_cases/auth/get_current_user_id_use_case.dart'; // New import
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

var baseOptions = BaseOptions(
  baseUrl: dotenv.env['API_URL']!,
  receiveDataWhenStatusError: true,
  validateStatus: (status) => status! < 500,
);

var supabaseClient = Supabase.instance.client;

List<SingleChildWidget> get providers {
  return [
    Provider<SupabaseClient>(create: (context) => supabaseClient),
    Provider(
      create: (context) => AuthApiClient(supabaseClient: supabaseClient),
    ),
    Provider<IBaseApiClient>(
      create: (context) => BaseApiClient(
        clientFactory: (options) {
          final client = Dio(options);
          client.interceptors.add(PrettyDioLogger());
          return client;
        },
        options: baseOptions,
      ),
    ),
    Provider<IMembersApiClient>(
      create: (context) => MembersApiClient(context.read<IBaseApiClient>()),
    ),
    Provider(create: (context) => SharedPreferencesService()),
    Provider(
      create: (context) =>
          AuthApiClient(supabaseClient: context.read<SupabaseClient>()),
    ),
    Provider<IMembersRepository>(
      create: (context) => MembersRepository(membersApiClient: context.read()),
    ),
    ChangeNotifierProvider<IAuthRepository>(
      create: (context) => AuthRepository(
        membersRepository: context.read(),
        authApiClient: context.read(),
        sharedPreferencesService: context.read(),
      ),
    ),
    Provider<GetCurrentUserIdUseCase>(
      create: (context) =>
          GetCurrentUserIdUseCase(authRepository: context.read()),
    ),
  ];
}
