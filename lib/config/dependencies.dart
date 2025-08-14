// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:bloco_na_rua/data/repositories/carnival_block_member_repository.dart';
import 'package:bloco_na_rua/data/repositories/carnival_block_repository.dart';
import 'package:bloco_na_rua/data/repositories/meeting_presence_repository.dart';
import 'package:bloco_na_rua/data/repositories/meeting_repository.dart';
import 'package:bloco_na_rua/data/repositories/member_repository.dart';
import 'package:bloco_na_rua/data/repositories/repository_factory.dart';
import 'package:bloco_na_rua/data/services/api/api_service.dart';

/// Configuração de dependências da aplicação
class Dependencies {
  Dependencies._();

  static late final ApiService _apiService;
  static late final RepositoryFactory _repositoryFactory;
  static late final RepositoryCollection _repositories;

  /// Inicializa as dependências da aplicação
  static void initialize({String host = 'localhost', int port = 8080}) {
    _apiService = ApiService(host: host, port: port);
    _repositoryFactory = RepositoryFactory(host: host, port: port);
    _repositories = _repositoryFactory.createAllRepositories();
  }

  /// Retorna a instância do ApiService
  static ApiService get apiService => _apiService;

  /// Retorna a instância do RepositoryFactory
  static RepositoryFactory get repositoryFactory => _repositoryFactory;

  /// Retorna a coleção de repositories
  static RepositoryCollection get repositories => _repositories;

  /// Retorna o repository de blocos de carnaval
  static CarnivalBlockRepository get carnivalBlockRepository =>
      _repositories.carnivalBlockRepository;

  /// Retorna o repository de membros de blocos
  static CarnivalBlockMemberRepository get carnivalBlockMemberRepository =>
      _repositories.carnivalBlockMemberRepository;

  /// Retorna o repository de membros
  static MemberRepository get memberRepository =>
      _repositories.memberRepository;

  /// Retorna o repository de reuniões
  static MeetingRepository get meetingRepository =>
      _repositories.meetingRepository;

  /// Retorna o repository de presenças em reuniões
  static MeetingPresenceRepository get meetingPresenceRepository =>
      _repositories.meetingPresenceRepository;
}
