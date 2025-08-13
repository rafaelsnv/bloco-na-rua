// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:bloco_na_rua/config/dependencies.dart';
import 'package:bloco_na_rua/routing/router.dart';

/// Widget principal da aplicação
class BlocoNaRuaApp extends StatelessWidget {
  const BlocoNaRuaApp({
    super.key,
    this.host = 'localhost',
    this.port = 8080,
  });

  final String host;
  final int port;

  @override
  Widget build(BuildContext context) {
    // Inicializa as dependências
    Dependencies.initialize(host: host, port: port);

    // Inicializa o router
    AppRouter.initialize();

    return MaterialApp.router(
      title: 'Bloco na Rua',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
