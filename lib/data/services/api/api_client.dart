// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:bloco_na_rua/core/entity_base.dart';
import 'package:result_dart/result_dart.dart';

class ApiClient {
  ApiClient({String? host, int? port, HttpClient Function()? clientFactory})
    : _host = host ?? 'https://bloconarua-dev.azurewebsites.net/',
      _port = port ?? 8080,
      _clientFactory = clientFactory ?? HttpClient.new;

  final String _host;
  final int _port;
  final HttpClient Function() _clientFactory;

  AsyncResult<List<TEntity>> getAllAsync<TEntity extends EntityBase>() async {
    var client = _clientFactory();
    try {
      var test = TEntity;
      var test2 = test.runtimeType;
      String endpoint = TEntity.runtimeType.toString().replaceAll('Entity', '');
      Uri uri = Uri.parse('$_host/api/v1/$endpoint');
      final request = await client.getUrl(uri);
      final response = await request.close();

      if (response.statusCode != 200) {
        return Failure(
          Exception('Failed to load data: ${response.statusCode}'),
        );
      }

      final responseBody = await response.transform(utf8.decoder).join();
      final json = jsonDecode(responseBody) as List<dynamic>;
      return Success(
        json
            .map((e) => TEntity.fromJson(e as Map<String, dynamic>) as TEntity)
            .toList(),
      );
    } catch (error) {
      client.close();
      return Failure(Exception('An error occurred: $error'));
    }
  }
}

extension on Type {
  fromJson(Map<String, dynamic> e) {}
}
