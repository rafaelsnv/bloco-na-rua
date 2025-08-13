// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'routes.dart';

/// Configuração do router da aplicação
class AppRouter {
  AppRouter._();

  static late final GoRouter _router;

  /// Inicializa o router da aplicação
  static void initialize() {
    _router = GoRouter(
      initialLocation: Routes.home,
      routes: _buildRoutes(),
      errorBuilder: (context, state) => _buildErrorPage(context, state),
    );
  }

  /// Retorna a instância do router
  static GoRouter get router => _router;

  /// Constrói as rotas da aplicação
  static List<RouteBase> _buildRoutes() {
    return [
      // Rota inicial
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Página Inicial - Bloco na Rua'),
          ),
        ),
      ),

      // Rota de login
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Página de Login'),
          ),
        ),
      ),

      // Rota de registro
      GoRoute(
        path: Routes.register,
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Página de Registro'),
          ),
        ),
      ),

      // Rotas de blocos de carnaval
      GoRoute(
        path: Routes.carnivalBlocks,
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Lista de Blocos de Carnaval'),
          ),
        ),
      ),

      GoRoute(
        path: Routes.carnivalBlockDetails,
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return Scaffold(
            body: Center(
              child: Text('Detalhes do Bloco $id'),
            ),
          );
        },
      ),

      GoRoute(
        path: Routes.createCarnivalBlock,
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Criar Novo Bloco'),
          ),
        ),
      ),

      GoRoute(
        path: Routes.editCarnivalBlock,
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return Scaffold(
            body: Center(
              child: Text('Editar Bloco $id'),
            ),
          );
        },
      ),

      // Rotas de membros
      GoRoute(
        path: Routes.members,
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Lista de Membros'),
          ),
        ),
      ),

      GoRoute(
        path: Routes.memberDetails,
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return Scaffold(
            body: Center(
              child: Text('Detalhes do Membro $id'),
            ),
          );
        },
      ),

      GoRoute(
        path: Routes.createMember,
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Criar Novo Membro'),
          ),
        ),
      ),

      GoRoute(
        path: Routes.editMember,
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return Scaffold(
            body: Center(
              child: Text('Editar Membro $id'),
            ),
          );
        },
      ),

      // Rotas de reuniões
      GoRoute(
        path: Routes.meetings,
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Lista de Reuniões'),
          ),
        ),
      ),

      GoRoute(
        path: Routes.meetingDetails,
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return Scaffold(
            body: Center(
              child: Text('Detalhes da Reunião $id'),
            ),
          );
        },
      ),

      GoRoute(
        path: Routes.createMeeting,
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Criar Nova Reunião'),
          ),
        ),
      ),

      GoRoute(
        path: Routes.editMeeting,
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return Scaffold(
            body: Center(
              child: Text('Editar Reunião $id'),
            ),
          );
        },
      ),

      // Rotas de presenças
      GoRoute(
        path: Routes.meetingPresences,
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Lista de Presenças'),
          ),
        ),
      ),

      GoRoute(
        path: Routes.meetingPresenceDetails,
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return Scaffold(
            body: Center(
              child: Text('Detalhes da Presença $id'),
            ),
          );
        },
      ),

      // Rotas de perfil
      GoRoute(
        path: Routes.profile,
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Perfil do Usuário'),
          ),
        ),
      ),

      GoRoute(
        path: Routes.settings,
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Configurações'),
          ),
        ),
      ),

      // Rota de erro 404
      GoRoute(
        path: Routes.notFound,
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Página não encontrada'),
          ),
        ),
      ),
    ];
  }

  /// Constrói a página de erro
  static Widget _buildErrorPage(BuildContext context, GoRouterState state) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Erro: ${state.error}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(Routes.home),
              child: const Text('Voltar ao Início'),
            ),
          ],
        ),
      ),
    );
  }
}
