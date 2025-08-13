# Camada de Repositories - Bloco na Rua

Esta camada implementa o padrão Repository Pattern para abstrair o acesso aos dados e fornecer uma interface limpa para a camada de domínio.

## Estrutura

```
repositories/
├── carnival_block_repository.dart           # Interface para blocos de carnaval
├── carnival_block_member_repository.dart    # Interface para membros de blocos
├── member_repository.dart                   # Interface para membros
├── meeting_repository.dart                  # Interface para reuniões
├── meeting_presence_repository.dart         # Interface para presenças
├── repository_factory.dart                  # Factory para criação de repositories
├── repositories.dart                        # Barrel export
├── impl/                                    # Implementações
│   ├── carnival_block_repository_impl.dart
│   ├── carnival_block_member_repository_impl.dart
│   ├── member_repository_impl.dart
│   ├── meeting_repository_impl.dart
│   └── meeting_presence_repository_impl.dart
└── README.md                               # Este arquivo
```

## Interfaces dos Repositories

### CarnivalBlockRepository
Gerencia operações relacionadas a blocos de carnaval:
- `getAllCarnivalBlocks()` - Lista todos os blocos
- `getCarnivalBlockById(int id)` - Busca bloco por ID
- `createCarnivalBlock(CarnivalBlockCreate)` - Cria novo bloco
- `updateCarnivalBlock(int id, CarnivalBlockUpdate, int loggedMemberId)` - Atualiza bloco
- `deleteCarnivalBlock(int id, int loggedMemberId)` - Exclui bloco

### CarnivalBlockMemberRepository
Gerencia membros de blocos de carnaval:
- `getAllCarnivalBlockMembers()` - Lista todos os membros de blocos
- `getCarnivalBlockMembersByBlock(int blockId)` - Lista membros de um bloco
- `createCarnivalBlockMember(CarnivalBlockMemberCreate, int loggedMemberId)` - Adiciona membro
- `updateCarnivalBlockMember(int id, CarnivalBlockMemberUpdate, int loggedMemberId)` - Atualiza membro
- `deleteCarnivalBlockMember(int id, int loggedMemberId)` - Remove membro

### MemberRepository
Gerencia membros do sistema:
- `getAllMembers()` - Lista todos os membros
- `getMemberById(int id)` - Busca membro por ID
- `createMember(MemberCreate)` - Cria novo membro
- `updateMember(int id, MemberUpdate, int loggedMemberId)` - Atualiza membro
- `deleteMember(int id, int loggedMemberId)` - Exclui membro

### MeetingRepository
Gerencia reuniões:
- `getAllMeetings()` - Lista todas as reuniões
- `getMeetingsByBlock(int blockId)` - Lista reuniões de um bloco
- `createMeeting(MeetingCreate, int loggedMemberId)` - Cria nova reunião
- `updateMeeting(int id, MeetingUpdate, int loggedMemberId)` - Atualiza reunião
- `deleteMeeting(int id, int loggedMemberId)` - Exclui reunião

### MeetingPresenceRepository
Gerencia presenças em reuniões:
- `getAllMeetingPresences()` - Lista todas as presenças
- `getMeetingPresenceById(int id)` - Busca presença por ID
- `createMeetingPresence(MeetingPresenceCreate, int loggedMemberId)` - Registra presença
- `updateMeetingPresence(int id, MeetingPresenceUpdate, int loggedMemberId)` - Atualiza presença
- `deleteMeetingPresence(int id, int loggedMemberId)` - Exclui presença

## Implementações

Todas as implementações (`*RepositoryImpl`) utilizam o `ApiService` para comunicação com a API REST. Elas:

- Implementam as interfaces correspondentes
- Fazem conversões de tipos quando necessário (ex: int para RolesEnum)
- Delegam as operações para o ApiService
- Mantêm a mesma assinatura de métodos das interfaces

## RepositoryFactory

O `RepositoryFactory` facilita a criação de repositories:

```dart
// Criar factory
final factory = RepositoryFactory(host: 'localhost', port: 8080);

// Criar repository individual
final carnivalBlockRepo = factory.createCarnivalBlockRepository();

// Ou criar todos os repositories de uma vez
final repositories = factory.createAllRepositories();
```

## RepositoryCollection

A `RepositoryCollection` agrupa todos os repositories em uma única instância:

```dart
final repositories = factory.createAllRepositories();

// Usar repositories
await repositories.carnivalBlockRepository.getAllCarnivalBlocks();
await repositories.memberRepository.createMember(member);
await repositories.meetingRepository.getMeetingsByBlock(1);
```

## Uso Básico

### Configuração
```dart
final factory = RepositoryFactory(host: 'localhost', port: 8080);
final repositories = factory.createAllRepositories();
```

### Criar um bloco
```dart
final carnivalBlock = CarnivalBlockCreate(
  name: 'Meu Bloco',
  ownerId: 1,
  carnivalBlockImage: 'https://example.com/image.jpg',
);

final result = await repositories.carnivalBlockRepository.createCarnivalBlock(carnivalBlock);

result.when(
  ok: (_) => print('Bloco criado com sucesso!'),
  error: (error) => print('Erro: $error'),
);
```

### Listar blocos
```dart
final result = await repositories.carnivalBlockRepository.getAllCarnivalBlocks();

result.when(
  ok: (blocks) => print('Encontrados ${blocks.length} blocos'),
  error: (error) => print('Erro: $error'),
);
```

### Adicionar membro a um bloco
```dart
final member = CarnivalBlockMemberCreate(
  carnivalBlockId: 1,
  memberId: 1,
  role: 0, // member
);

final result = await repositories.carnivalBlockMemberRepository.createCarnivalBlockMember(
  member,
  1, // loggedMemberId
);
```

## Vantagens do Repository Pattern

1. **Abstração**: Oculta detalhes da implementação da API
2. **Testabilidade**: Facilita a criação de mocks para testes
3. **Flexibilidade**: Permite trocar implementações sem afetar o código cliente
4. **Separação de Responsabilidades**: Isola a lógica de acesso a dados
5. **Reutilização**: Repositories podem ser usados por diferentes partes da aplicação

## Tratamento de Erros

Todos os métodos retornam `Result<T>` que pode ser:
- `Result.ok(T value)`: Operação bem-sucedida
- `Result.error(Object error)`: Erro ocorreu

```dart
final result = await repository.someMethod();

result.when(
  ok: (value) => handleSuccess(value),
  error: (error) => handleError(error),
);
```

## Exemplo Completo

Veja o arquivo `lib/examples/repository_usage_example.dart` para exemplos completos de uso de todos os repositories.

## Próximos Passos

1. **Cache Local**: Implementar cache nos repositories para melhor performance
2. **Validação**: Adicionar validação de dados nos repositories
3. **Logging**: Implementar logging detalhado
4. **Retry Logic**: Adicionar retry automático para falhas de rede
5. **Offline Support**: Implementar sincronização offline
