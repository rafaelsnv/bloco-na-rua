// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:bloco_na_rua/data/repositories/carnival_block_repository.dart';
import 'package:bloco_na_rua/data/repositories/carnival_block_member_repository.dart';
import 'package:bloco_na_rua/data/repositories/member_repository.dart';
import 'package:bloco_na_rua/data/repositories/meeting_repository.dart';
import 'package:bloco_na_rua/data/repositories/meeting_presence_repository.dart';
import 'package:bloco_na_rua/data/repositories/impl/carnival_block_repository_impl.dart';
import 'package:bloco_na_rua/data/repositories/impl/carnival_block_member_repository_impl.dart';
import 'package:bloco_na_rua/data/repositories/impl/member_repository_impl.dart';
import 'package:bloco_na_rua/data/repositories/impl/meeting_repository_impl.dart';
import 'package:bloco_na_rua/data/repositories/impl/meeting_presence_repository_impl.dart';
import 'package:bloco_na_rua/data/services/api/api_service.dart';

/// Factory para criação de repositories
class RepositoryFactory {
  RepositoryFactory({String? host, int? port})
    : _apiService = ApiService(host: host, port: port);

  final ApiService _apiService;

  /// Cria uma instância do CarnivalBlockRepository
  CarnivalBlockRepository createCarnivalBlockRepository() {
    return CarnivalBlockRepositoryImpl(_apiService);
  }

  /// Cria uma instância do CarnivalBlockMemberRepository
  CarnivalBlockMemberRepository createCarnivalBlockMemberRepository() {
    return CarnivalBlockMemberRepositoryImpl(_apiService);
  }

  /// Cria uma instância do MemberRepository
  MemberRepository createMemberRepository() {
    return MemberRepositoryImpl(_apiService);
  }

  /// Cria uma instância do MeetingRepository
  MeetingRepository createMeetingRepository() {
    return MeetingRepositoryImpl(_apiService);
  }

  /// Cria uma instância do MeetingPresenceRepository
  MeetingPresenceRepository createMeetingPresenceRepository() {
    return MeetingPresenceRepositoryImpl(_apiService);
  }

  /// Cria todas as instâncias de repositories
  RepositoryCollection createAllRepositories() {
    return RepositoryCollection(
      carnivalBlockRepository: createCarnivalBlockRepository(),
      carnivalBlockMemberRepository: createCarnivalBlockMemberRepository(),
      memberRepository: createMemberRepository(),
      meetingRepository: createMeetingRepository(),
      meetingPresenceRepository: createMeetingPresenceRepository(),
    );
  }
}

/// Coleção de todos os repositories
class RepositoryCollection {
  const RepositoryCollection({
    required this.carnivalBlockRepository,
    required this.carnivalBlockMemberRepository,
    required this.memberRepository,
    required this.meetingRepository,
    required this.meetingPresenceRepository,
  });

  final CarnivalBlockRepository carnivalBlockRepository;
  final CarnivalBlockMemberRepository carnivalBlockMemberRepository;
  final MemberRepository memberRepository;
  final MeetingRepository meetingRepository;
  final MeetingPresenceRepository meetingPresenceRepository;
}
