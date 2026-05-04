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
  static const String carnivalBlock = '/carnival-block';
  static const String createBlock = '/create-block';
  static const String editBlock = '/edit-block';
  static const String joinBlock = '/join-block';

  // Rotas de membros
  static const String members = '/members';

  // Rotas de reuniões
  static const String meeting = '/meeting';
  static const String userMeetings = '/user-meetings';
  static const String editMeeting = '/edit-meeting';
  static const String createMeeting = '/create-meeting';

  // Rotas de presenças
  static const String meetingPresences = '/meeting-presences';

  // Rotas de perfil
  static const String profile = '/profile';
  static const String settings = '/settings';

  // Rotas de erro
  static const String notFound = '/404';
  static const String error = '/error';
}
