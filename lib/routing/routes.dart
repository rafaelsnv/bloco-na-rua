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
  static const String carnivalBlockDetails = '/carnival-blocks/:id';
  static const String createCarnivalBlock = '/carnival-blocks/create';
  static const String editCarnivalBlock = '/carnival-blocks/:id/edit';

  // Rotas de membros
  static const String members = '/members';
  static const String memberDetails = '/members/:id';
  static const String createMember = '/members/create';
  static const String editMember = '/members/:id/edit';

  // Rotas de reuniões
  static const String meetings = '/meetings';
  static const String meetingDetails = '/meetings/:id';
  static const String createMeeting = '/meetings/create';
  static const String editMeeting = '/meetings/:id/edit';

  // Rotas de presenças
  static const String meetingPresences = '/meeting-presences';
  static const String meetingPresenceDetails = '/meeting-presences/:id';

  // Rotas de perfil
  static const String profile = '/profile';
  static const String settings = '/settings';

  // Rotas de erro
  static const String notFound = '/404';
  static const String error = '/error';
}
