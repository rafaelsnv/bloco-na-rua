import 'package:flutter/material.dart';

/// Definição das rotas da aplicação
class Routes {
  Routes._();

  /// Global route observer for listening to navigation events.
  static final RouteObserver<ModalRoute<Object?>> routeObserver =
      RouteObserver<ModalRoute<Object?>>();

  // Rotas principais
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';

  // Rotas de blocos de carnaval
  static const String carnivalBlock = '/carnival-block';
  static const String carnivalBlocks = '/carnival-blocks';
  static const String createBlock = '/create-block';
  static const String editBlock = '/edit-block';
  static const String joinBlock = '/join-block';

  // Rotas de encontros
  static const String meeting = '/meeting';
  static const String userMeetings = '/user-meetings';
  static const String editMeeting = '/edit-meeting';
  static const String createMeeting = '/create-meeting';

  // Rotas dinâmicas de membros
  static const String addMember = '/add-member';

  // Rotas de perfil
  static const String profile = '/profile';
  static const String settings = '/settings';

  // Rotas de autenticação
  static const String onboarding = '/onboarding';

  // Padrões de rotas dinâmicas (com :param) usados no router
  static String get createMeetingPath => '$createMeeting/:blockId';
  static String get addMemberPath => '$addMember/:blockId';
  static String get editBlockPath => '$editBlock/:id';

  // Helpers para construir caminhos com parâmetros
  static String createMeetingFor(String blockId) => '$createMeeting/$blockId';
  static String addMemberFor(String blockId) => '$addMember/$blockId';
  static String editBlockFor(String id) => '$editBlock/$id';
}
