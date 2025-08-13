// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:bloco_na_rua/data/repositories/repository_factory.dart';
import 'package:bloco_na_rua/domain/models/api/carnival_block/carnival_block_create.dart';
import 'package:bloco_na_rua/domain/models/api/carnival_block/carnival_block_update.dart';
import 'package:bloco_na_rua/domain/models/api/carnival_block_member/carnival_block_member_create.dart';
import 'package:bloco_na_rua/domain/models/api/member/member_create.dart';
import 'package:bloco_na_rua/domain/models/api/meeting/meeting_create.dart';
import 'package:bloco_na_rua/domain/models/api/meeting_presence/meeting_presence_create.dart';

/// Exemplo de uso dos repositories do Bloco na Rua
class RepositoryUsageExample {
  late final RepositoryCollection _repositories;

  RepositoryUsageExample() {
    final factory = RepositoryFactory(host: 'localhost', port: 8080);
    _repositories = factory.createAllRepositories();
  }

  /// Exemplo de criação de um bloco de carnaval usando repository
  Future<void> createCarnivalBlockExample() async {
    print('Criando bloco de carnaval via repository...');

    final carnivalBlock = CarnivalBlockCreate(
      name: 'Bloco do Samba',
      ownerId: 1,
      carnivalBlockImage: 'https://example.com/image.jpg',
    );

    final result = await _repositories.carnivalBlockRepository.createCarnivalBlock(carnivalBlock);

    result.when(
      ok: (_) => print('Bloco criado com sucesso via repository!'),
      error: (error) => print('Erro ao criar bloco via repository: $error'),
    );
  }

  /// Exemplo de listagem de blocos usando repository
  Future<void> listCarnivalBlocksExample() async {
    print('Listando blocos de carnaval via repository...');

    final result = await _repositories.carnivalBlockRepository.getAllCarnivalBlocks();

    result.when(
      ok: (blocks) {
        print('Blocos encontrados via repository: ${blocks.length}');
        for (final block in blocks) {
          print('- ${block['name']} (ID: ${block['id']})');
        }
      },
      error: (error) => print('Erro ao listar blocos via repository: $error'),
    );
  }

  /// Exemplo de criação de um membro usando repository
  Future<void> createMemberExample() async {
    print('Criando membro via repository...');

    final member = MemberCreate(
      name: 'João Silva',
      email: 'joao@example.com',
      phone: '(11) 99999-9999',
      profileImage: 'https://example.com/profile.jpg',
    );

    final result = await _repositories.memberRepository.createMember(member);

    result.when(
      ok: (_) => print('Membro criado com sucesso via repository!'),
      error: (error) => print('Erro ao criar membro via repository: $error'),
    );
  }

  /// Exemplo de adição de membro a um bloco usando repository
  Future<void> addMemberToBlockExample() async {
    print('Adicionando membro ao bloco via repository...');

    final member = CarnivalBlockMemberCreate(
      carnivalBlockId: 1,
      memberId: 1,
      role: 0, // member
    );

    final result = await _repositories.carnivalBlockMemberRepository.createCarnivalBlockMember(
      member,
      1, // loggedMemberId
    );

    result.when(
      ok: (_) => print('Membro adicionado ao bloco com sucesso via repository!'),
      error: (error) => print('Erro ao adicionar membro via repository: $error'),
    );
  }

  /// Exemplo de criação de uma reunião usando repository
  Future<void> createMeetingExample() async {
    print('Criando reunião via repository...');

    final meeting = MeetingCreate(
      name: 'Reunião de Ensaios',
      description: 'Ensaio geral para o carnaval',
      location: 'Quadra da escola de samba',
      meetingDateTime: DateTime.now().add(const Duration(days: 7)),
      carnivalBlockId: 1,
    );

    final result = await _repositories.meetingRepository.createMeeting(meeting, 1);

    result.when(
      ok: (_) => print('Reunião criada com sucesso via repository!'),
      error: (error) => print('Erro ao criar reunião via repository: $error'),
    );
  }

  /// Exemplo de registro de presença em reunião usando repository
  Future<void> registerMeetingPresenceExample() async {
    print('Registrando presença na reunião via repository...');

    final presence = MeetingPresenceCreate(
      memberId: 1,
      meetingId: 1,
      carnivalBlockId: 1,
      isPresent: true,
    );

    final result = await _repositories.meetingPresenceRepository.createMeetingPresence(
      presence,
      1, // loggedMemberId
    );

    result.when(
      ok: (_) => print('Presença registrada com sucesso via repository!'),
      error: (error) => print('Erro ao registrar presença via repository: $error'),
    );
  }

  /// Exemplo de busca de reuniões por bloco usando repository
  Future<void> getMeetingsByBlockExample() async {
    print('Buscando reuniões do bloco via repository...');

    final result = await _repositories.meetingRepository.getMeetingsByBlock(1);

    result.when(
      ok: (meetings) {
        print('Reuniões encontradas via repository: ${meetings.length}');
        for (final meeting in meetings) {
          print('- ${meeting['name']} em ${meeting['location']}');
        }
      },
      error: (error) => print('Erro ao buscar reuniões via repository: $error'),
    );
  }

  /// Exemplo de busca de membros de um bloco usando repository
  Future<void> getBlockMembersExample() async {
    print('Buscando membros do bloco via repository...');

    final result = await _repositories.carnivalBlockMemberRepository.getCarnivalBlockMembersByBlock(1);

    result.when(
      ok: (members) {
        print('Membros encontrados via repository: ${members.length}');
        for (final member in members) {
          print('- ${member['memberName']} (${member['role']})');
        }
      },
      error: (error) => print('Erro ao buscar membros via repository: $error'),
    );
  }

  /// Exemplo de atualização de um bloco usando repository
  Future<void> updateCarnivalBlockExample() async {
    print('Atualizando bloco de carnaval via repository...');

    final update = CarnivalBlockUpdate(
      name: 'Bloco do Samba Atualizado',
      carnivalBlockImage: 'https://example.com/new-image.jpg',
    );

    final result = await _repositories.carnivalBlockRepository.updateCarnivalBlock(
      1, // id
      update,
      1, // loggedMemberId
    );

    result.when(
      ok: (_) => print('Bloco atualizado com sucesso via repository!'),
      error: (error) => print('Erro ao atualizar bloco via repository: $error'),
    );
  }

  /// Exemplo de busca de um membro específico usando repository
  Future<void> getMemberByIdExample() async {
    print('Buscando membro específico via repository...');

    final result = await _repositories.memberRepository.getMemberById(1);

    result.when(
      ok: (member) {
        print('Membro encontrado via repository:');
        print('- Nome: ${member['name']}');
        print('- Email: ${member['email']}');
        print('- Telefone: ${member['phone']}');
      },
      error: (error) => print('Erro ao buscar membro via repository: $error'),
    );
  }

  /// Executa todos os exemplos
  Future<void> runAllExamples() async {
    print('=== Exemplos de Uso dos Repositories ===\n');

    await createCarnivalBlockExample();
    print('');

    await listCarnivalBlocksExample();
    print('');

    await createMemberExample();
    print('');

    await addMemberToBlockExample();
    print('');

    await createMeetingExample();
    print('');

    await registerMeetingPresenceExample();
    print('');

    await updateCarnivalBlockExample();
    print('');

    await getMeetingsByBlockExample();
    print('');

    await getBlockMembersExample();
    print('');

    await getMemberByIdExample();
    print('');

    print('=== Fim dos Exemplos dos Repositories ===');
  }
}

/// Função principal para executar os exemplos
void main() async {
  final example = RepositoryUsageExample();
  await example.runAllExamples();
}
