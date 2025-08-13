# API do Bloco na Rua

Este diretório contém toda a implementação da API para o projeto Bloco na Rua, baseada no swagger.json fornecido.

## Estrutura

```
api/
├── api_client.dart          # Cliente HTTP para comunicação com a API
├── api_service.dart         # Serviço que encapsula o cliente com interface amigável
├── model/                   # Modelos de dados
│   ├── carnival_block/      # Modelos para blocos de carnaval
│   ├── carnival_block_member/ # Modelos para membros de blocos
│   ├── member/              # Modelos para membros
│   ├── meeting/             # Modelos para reuniões
│   ├── meeting_presence/    # Modelos para presenças em reuniões
│   └── roles_enum/          # Enumeração de roles
└── README.md               # Este arquivo
```

## Modelos

Todos os modelos são gerados usando `freezed` e `json_serializable` para garantir type safety e serialização JSON.

### CarnivalBlock
- `CarnivalBlockCreate`: Para criação de blocos
- `CarnivalBlockUpdate`: Para atualização de blocos

### CarnivalBlockMember
- `CarnivalBlockMemberCreate`: Para adicionar membros a blocos
- `CarnivalBlockMemberUpdate`: Para atualizar membros de blocos

### Member
- `MemberCreate`: Para criação de membros
- `MemberUpdate`: Para atualização de membros

### Meeting
- `MeetingCreate`: Para criação de reuniões
- `MeetingUpdate`: Para atualização de reuniões

### MeetingPresence
- `MeetingPresenceCreate`: Para registro de presenças
- `MeetingPresenceUpdate`: Para atualização de presenças

### RolesEnum
Enumeração dos possíveis roles:
- `member` (0): Membro comum
- `admin` (1): Administrador
- `owner` (2): Proprietário

## Uso

### ApiClient

O `ApiClient` é a classe de baixo nível que faz as requisições HTTP:

```dart
final apiClient = ApiClient(host: 'localhost', port: 8080);

// Criar um bloco
final result = await apiClient.createCarnivalBlock(
  CarnivalBlockCreate(
    name: 'Meu Bloco',
    ownerId: 1,
    carnivalBlockImage: 'https://example.com/image.jpg',
  ),
);
```

### ApiService

O `ApiService` fornece uma interface mais amigável:

```dart
final apiService = ApiService(host: 'localhost', port: 8080);

// Criar um bloco
final result = await apiService.createCarnivalBlock(
  name: 'Meu Bloco',
  ownerId: 1,
  carnivalBlockImage: 'https://example.com/image.jpg',
);

// Listar blocos
final blocksResult = await apiService.getCarnivalBlocks();
blocksResult.when(
  ok: (blocks) => print('Encontrados ${blocks.length} blocos'),
  error: (error) => print('Erro: $error'),
);
```

## Endpoints Disponíveis

### CarnivalBlocks
- `GET /api/v1/CarnivalBlocks` - Listar todos os blocos
- `GET /api/v1/CarnivalBlocks/{id}` - Buscar bloco por ID
- `POST /api/v1/CarnivalBlocks` - Criar novo bloco
- `PUT /api/v1/CarnivalBlocks/{id}` - Atualizar bloco (requer X-Logged-Member)
- `DELETE /api/v1/CarnivalBlocks/{id}` - Excluir bloco (requer X-Logged-Member)

### CarnivalBlockMembers
- `GET /api/v1/CarnivalBlockMembers` - Listar todos os membros de blocos
- `GET /api/v1/CarnivalBlockMembers/block/{blockId}` - Listar membros de um bloco específico
- `POST /api/v1/CarnivalBlockMembers` - Adicionar membro a bloco (requer X-Logged-Member)
- `PUT /api/v1/CarnivalBlockMembers/{id}` - Atualizar membro de bloco (requer X-Logged-Member)
- `DELETE /api/v1/CarnivalBlockMembers/{id}` - Remover membro de bloco (requer X-Logged-Member)

### Members
- `GET /api/v1/Members` - Listar todos os membros
- `GET /api/v1/Members/{id}` - Buscar membro por ID
- `POST /api/v1/Members` - Criar novo membro
- `PUT /api/v1/Members/{id}` - Atualizar membro (requer X-Logged-Member)
- `DELETE /api/v1/Members/{id}` - Excluir membro (requer X-Logged-Member)

### Meetings
- `GET /api/v1/Meetings` - Listar todas as reuniões
- `GET /api/v1/Meetings/block/{blockId}` - Listar reuniões de um bloco específico
- `POST /api/v1/Meetings` - Criar nova reunião (requer X-Logged-Member)
- `PUT /api/v1/Meetings/{id}` - Atualizar reunião (requer X-Logged-Member)
- `DELETE /api/v1/Meetings/{id}` - Excluir reunião (requer X-Logged-Member)

### MeetingPresences
- `GET /api/v1/MeetingPresences` - Listar todas as presenças
- `GET /api/v1/MeetingPresences/{id}` - Buscar presença por ID
- `POST /api/v1/MeetingPresences` - Registrar presença (requer X-Logged-Member)
- `PUT /api/v1/MeetingPresences/{id}` - Atualizar presença (requer X-Logged-Member)
- `DELETE /api/v1/MeetingPresences/{id}` - Excluir presença (requer X-Logged-Member)

## Tratamento de Erros

Todos os métodos retornam um `Result<T>` que pode ser:
- `Result.ok(T value)`: Operação bem-sucedida
- `Result.error(Object error)`: Erro ocorreu

Exemplo de uso:

```dart
final result = await apiService.createCarnivalBlock(
  name: 'Meu Bloco',
  ownerId: 1,
);

result.when(
  ok: (_) => print('Bloco criado com sucesso!'),
  error: (error) => print('Erro ao criar bloco: $error'),
);
```

## Headers de Autenticação

Alguns endpoints requerem o header `X-Logged-Member` com o ID do membro logado. O `ApiService` automaticamente adiciona este header quando necessário.

## Exemplo Completo

Veja o arquivo `lib/examples/api_usage_example.dart` para exemplos completos de uso de todos os endpoints.

## Geração de Código

Para regenerar os arquivos de código gerado (freezed e json_serializable), execute:

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## Dependências

- `freezed`: Para classes imutáveis e pattern matching
- `json_annotation`: Para serialização JSON
- `dart:io`: Para requisições HTTP
- `dart:convert`: Para codificação/decodificação JSON
