// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:bloco_na_rua/core/entity_base.dart';
import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';

class ApiClient {
  ApiClient({BaseOptions? options, Dio Function(BaseOptions?)? clientFactory})
    : _clientFactory = clientFactory ?? Dio.new,
      _options = options;

  final Dio Function(BaseOptions?) _clientFactory;
  final BaseOptions? _options;

  AsyncResult<List<TEntity>> getAllAsync<TEntity extends EntityBase>(
    JsonFactory<TEntity> fromJsonFactory,
  ) async {
    var client = _clientFactory(_options);
    try {
      String endpoint = TEntity.toString().replaceAll('Entity', '');
      final request = await client.get('/api/v1/$endpoint');
      if (request.statusCode != 200) {
        return Failure(Exception('Failed to load data: ${request.statusCode}'));
      }

      final response = await request.data;
      final responseBody = jsonEncode(response);
      final json = jsonDecode(responseBody) as List<dynamic>;

      return Success(
        json.map((e) => fromJsonFactory(e as Map<String, dynamic>)).toList(),
      );
    } catch (error) {
      client.close();
      return Failure(Exception('An error occurred: $error'));
    }
  }
}
