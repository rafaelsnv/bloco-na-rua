// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:bloco_na_rua/data/services/api/api_service.dart';
import 'package:bloco_na_rua/domain/models/api/roles_enum/roles_enum.dart';

/// Exemplo de uso da API do Bloco na Rua
class ApiUsageExample {
  final ApiService _apiService = ApiService(host: 'localhost', port: 8080);

  /// Exemplo de criação de um bloco de carnaval
  Future<void> createCarnivalBlockExample() async {
    print('Criando bloco de carnaval...');

    final result = await _apiService.createCarnivalBlock(
      name: 'Bloco do Samba',
      ownerId: 1,
      carnivalBlockImage: 'https://example.com/image.jpg',
    );

    result.when(
      ok: (_) => print('Bloco criado com sucesso!'),
      error: (error) => print('Erro ao criar bloco: $error'),
    );
  }

  /// Exemplo de listagem de blocos de carnaval
  Future<void> listCarnivalBlocksExample() async {
    print('Listando blocos de carnaval...');

    final result = await _apiService.getCarnivalBlocks();

    result.when(
      ok: (blocks) {
        print('Blocos encontrados: ${blocks.length}');
        for (final block in blocks) {
          print('- ${block['name']} (ID: ${block['id']})');
        }
      },
      error: (error) => print('Erro ao listar blocos: $error'),
    );
  }

  /// Exemplo de criação de um membro
  Future<void> createMemberExample() async {
    print('Criando membro...');

    final result = await _apiService.createMember(
      name: 'João Silva',
      email: 'joao@example.com',
      phone: '(11) 99999-9999',
      profileImage: 'https://example.com/profile.jpg',
    );

    result.when(
      ok: (_) => print('Membro criado com sucesso!'),
      error: (error) => print('Erro ao criar membro: $error'),
    );
  }

  /// Exemplo de adição de membro a um bloco
  Future<void> addMemberToBlockExample() async {
    print('Adicionando membro ao bloco...');

    final result = await _apiService.createCarnivalBlockMember(
      carnivalBlockId: 1,
      memberId: 1,
      role: RolesEnum.member,
      loggedMemberId: 1,
    );

    result.when(
      ok: (_) => print('Membro adicionado ao bloco com sucesso!'),
      error: (error) => print('Erro ao adicionar membro: $error'),
    );
  }

  /// Exemplo de criação de uma reunião
  Future<void> createMeetingExample() async {
    print('Criando reunião...');

    final result = await _apiService.createMeeting(
      name: 'Reunião de Ensaios',
      description: 'Ensaio geral para o carnaval',
      location: 'Quadra da escola de samba',
      meetingDateTime: DateTime.now().add(const Duration(days: 7)),
      carnivalBlockId: 1,
      loggedMemberId: 1,
    );

    result.when(
      ok: (_) => print('Reunião criada com sucesso!'),
      error: (error) => print('Erro ao criar reunião: $error'),
    );
  }

  /// Exemplo de registro de presença em reunião
  Future<void> registerMeetingPresenceExample() async {
    print('Registrando presença na reunião...');

    final result = await _apiService.createMeetingPresence(
      memberId: 1,
      meetingId: 1,
      carnivalBlockId: 1,
      isPresent: true,
      loggedMemberId: 1,
    );

    result.when(
      ok: (_) => print('Presença registrada com sucesso!'),
      error: (error) => print('Erro ao registrar presença: $error'),
    );
  }

  /// Exemplo de atualização de dados de um bloco
  Future<void> updateCarnivalBlockExample() async {
    print('Atualizando bloco de carnaval...');

    final result = await _apiService.updateCarnivalBlock(
      id: 1,
      loggedMemberId: 1,
      name: 'Bloco do Samba Atualizado',
      carnivalBlockImage: 'https://example.com/new-image.jpg',
    );

    result.when(
      ok: (_) => print('Bloco atualizado com sucesso!'),
      error: (error) => print('Erro ao atualizar bloco: $error'),
    );
  }

  /// Exemplo de exclusão de um bloco
  Future<void> deleteCarnivalBlockExample() async {
    print('Excluindo bloco de carnaval...');

    final result = await _apiService.deleteCarnivalBlock(
      id: 1,
      loggedMemberId: 1,
    );

    result.when(
      ok: (_) => print('Bloco excluído com sucesso!'),
      error: (error) => print('Erro ao excluir bloco: $error'),
    );
  }

  /// Exemplo de busca de reuniões por bloco
  Future<void> getMeetingsByBlockExample() async {
    print('Buscando reuniões do bloco...');

    final result = await _apiService.getMeetingsByBlock(1);

    result.when(
      ok: (meetings) {
        print('Reuniões encontradas: ${meetings.length}');
        for (final meeting in meetings) {
          print('- ${meeting['name']} em ${meeting['location']}');
        }
      },
      error: (error) => print('Erro ao buscar reuniões: $error'),
    );
  }

  /// Exemplo de busca de membros de um bloco
  Future<void> getBlockMembersExample() async {
    print('Buscando membros do bloco...');

    final result = await _apiService.getCarnivalBlockMembersByBlock(1);

    result.when(
      ok: (members) {
        print('Membros encontrados: ${members.length}');
        for (final member in members) {
          print('- ${member['memberName']} (${member['role']})');
        }
      },
      error: (error) => print('Erro ao buscar membros: $error'),
    );
  }

  /// Executa todos os exemplos
  Future<void> runAllExamples() async {
    print('=== Exemplos de Uso da API Bloco na Rua ===\n');

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

    // Comentado para não excluir dados de exemplo
    // await deleteCarnivalBlockExample();

    print('=== Fim dos Exemplos ===');
  }
}

/// Função principal para executar os exemplos
void main() async {
  final example = ApiUsageExample();
  await example.runAllExamples();
}
