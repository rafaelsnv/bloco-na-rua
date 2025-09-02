// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// Definição das rotas da aplicação
class Routes {
  Routes._();

  // Rotas principais
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';

  // Rotas de blocos de carnaval
  static const String carnivalBlocks = '/carnival-blocks';

  // Rotas de membros
  static const String members = '/members';

  // Rotas de reuniões
  static const String meetings = '/meetings';

  // Rotas de presenças
  static const String meetingPresences = '/meeting-presences';

  // Rotas de perfil
  static const String profile = '/profile';
  static const String settings = '/settings';

  // Rotas de erro
  static const String notFound = '/404';
  static const String error = '/error';
}
