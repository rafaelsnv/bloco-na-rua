# Bloco na Rua — Plano de Implementação

## Estado: Em Desenvolvimento

---

## Funcionalidades do TCC

### ✅ (A) Cadastro de Membros — STATUS: PARCIAL

| Aspecto | Status |
|---------|--------|
| Cadastro de usuário (nome, email, senha, telefone) | ✅ Feito |
| Adicionar membros a um bloco específico | ✅ Feito |
| Entrar em um bloco via código de convite | ✅ Feito (JoinBlockModal) |
| Tela de adicionar/remover membros | ✅ Feito |
| Tela de visualização de membros do bloco | ✅ Feito (BlockDetailsScreen) |
| Editar bloco | ✅ Feito (EditBlockScreen) |

### ✅ (B) Controle de Presença — STATUS: IMPLEMENTADO

| Aspecto | Status |
|---------|--------|
| API endpoint `/api/v1/MeetingPresences` | ✅ Existe (backend) |
| `MeetingPresencesApiClient` | ✅ Feito |
| `MeetingPresencesRepository` | ✅ Feito |
| Tela de marcar presença | ✅ Feito (MeetingDetailsScreen) |
| Ver lista de presenças | ✅ Feito (MeetingDetailsScreen) |
| Confirmar/Negar presença | ✅ Feito (MeetingDetailsScreen - botões "Eu Vou" / "Não Vou") |

### ✅ (C) Calendário de Encontros — STATUS: IMPLEMENTADO

| Aspecto | Status |
|---------|--------|
| Listar encontros do usuário | ✅ Feito (UserMeetingsScreen) |
| Ver encontros na Home | ✅ Feito |
| Criar encontro | ✅ Feito (CreateMeetingScreen + Cubit) |
| Editar encontro | ✅ Feito (EditMeetingScreen + Cubit) |
| Excluir encontro | ✅ Feito (MeetingDetailsScreen AppBar) |

---

## Features Futuras (TCC Conclusão)

| Feature | Status | Complexidade |
|---------|--------|-------------|
| Enquetes para decisões do bloco | 🟡 Backlog | Média |
| Notificações push | 🟡 Backlog | Média |
| Controle de presença via GPS | 🟡 Backlog | Alta |

---

## Correções Críticas

| # | Problema | Status | Arquivos |
|---|----------|--------|----------|
| 1 | `CreateBlockScreen` ignorava texto digitado | ✅ Corrigido | `ui/carnivalBlock/createBlock/` |
| 2 | `BlockDetailsScreen` sem lista de membros, FAB não funcional | ✅ Corrigido | `ui/carnivalBlock/blockDetails/` |
| 3 | `MeetingDetailsScreen` não permitia marcar presença | ✅ Corrigido | `ui/meetings/meetingDetails/` |
| 4 | `BlockDetailsScreen` sem adicionar/remover membros | ✅ Corrigido | `ui/carnivalBlock/blockDetails/`, `addMember/` |

---

## Checklist de Verificação Final

```
Login/Cadastro                    ✅ OK
Home (blocos + encontros)          ✅ OK
Criar bloco                       ✅ OK
Entrar em bloco                   ✅ OK (JoinBlockModal)
Detalhes do bloco
  - ver membros                   ✅ OK
  - adicionar membro              ✅ OK
  - remover membro                ✅ OK
  - editar bloco                  ✅ OK
Criar encontro                    ✅ OK
Detalhes do encontro
  - meus encontros                ✅ OK (UserMeetingsScreen)
  - marcar presença               ✅ OK
  - confirmar presença            ✅ OK
  - negar presença                ✅ OK
  - ver presenças                 ✅ OK
Editar encontro                   ✅ OK
Excluir encontro                  ✅ OK
Membros do bloco                  ✅ OK
Enquetes                         🟡 Backlog
Notificações push                🟡 Backlog
GPS                              🟡 Backlog
```

---

## Endpoints da API (swagger.json)

| Endpoint | Descrição | Gap |
|----------|-----------|-----|
| `POST/GET/DELETE /api/v1/MeetingPresences` | Controle de presença | ✅ Implementado |
| `POST/DELETE /api/v1/CarnivalBlockMembers/{id}` | Adicionar/remover membros | ✅ Implementado |
| `POST /api/v1/Meetings` | Criar encontro | ✅ CreateMeetingScreen |
| `PUT/DELETE /api/v1/Meetings/{id}` | Editar/excluir encontro | ✅ EditMeetingScreen |
| `GET /api/v1/Members/{id}/blocks` | Blocos de um membro | ✅ Usado em GetHomeDataUseCase |

---

## Tarefas (To-Dos)

### ✅ High Priority — COMPLETADO

- [x] Fix `CreateBlockScreen` — text input ignored, passes "Novo Bloco" hardcoded
- [x] Improve `BlockDetailsScreen` — add member list, FAB functionality
- [x] Implement `MeetingPresencesApiClient` + interface
- [x] Implement `MeetingPresencesRepository` + interface
- [x] Update `MeetingDetailsScreen` — allow marking attendance
- [x] Implement `CreateMeetingScreen`
- [x] Implement `EditMeetingScreen`
- [x] Implement `MeetingPresencesScreen`
- [x] Implement `ProfileScreen`
- [x] Implement `SettingsScreen`
- [x] Implement `NotFoundScreen`
- [x] Implement `ErrorScreen`
- [x] Integrate new screens into `lib/routing/router.dart`
- [x] Run `flutter pub get` and `build_runner build`

### 🔴 Medium Priority — COMPLETADO

- [x] Implement `CarnivalBlockMembersApiClient` (já existe interface)
- [x] Implement `CarnivalBlockMembersRepository` (já existe interface)
- [x] Adicionar/remover membros de um bloco (tela)

### 🟢 Low Priority

- [ ] Implementar Enquetes (TCC futuro)
- [ ] Implementar Notificações Push (TCC futuro)
- [ ] Implementar controle de presença via GPS (TCC futuro)

### ✅ User Journey Alignment — COMPLETADO (2026-05-03)

- [x] Atualizar rotas (`routes.dart`, `router.dart`) — novas rotas `userMeetings`, `joinBlock`, `editBlock`
- [x] Implementar `UserMeetingsPage` (Cubit + Screen) — listar encontros do usuário
- [x] Implementar `JoinBlockModal` (Cubit + Widget) — entrar em bloco via código
- [x] Implementar `EditBlockPage` (Cubit + Screen) — editar informações do bloco
- [x] Alinhar interação de encontro (Confirm/Deny) — botões "Eu Vou" / "Não Vou"
- [x] Integrar gatilhos na `HomeScreen` — UserMeetings, JoinBlock, CreateBlock
- [x] Integrar gatilhos na `BlockDetailsScreen` — EditBlock, CreateMeeting

---

## Infraestrutura

### Android Configuration

| Arquivo | Configuração | Status |
|---------|--------------|--------|
| `android/app/build.gradle.kts` | `ndkVersion = "28.2.13676358"` | ✅ Configurado |
| `android/app/src/main/AndroidManifest.xml` | `android:enableOnBackInvokedCallback="true"` | ✅ Configurado |

### Testes

| Teste | Status |
|-------|--------|
| `integration_test/app_test.dart` | ✅ 6 testes passando |

---

## Notas

- Autenticação: Supabase (evoluiu do Firebase do TCC original)
- Backend: REST API em `/api/v1/` (evoluiu do Firestore do TCC original)
- Arquitetura: Clean Architecture com Provider + flutter_bloc (Cubit)
- Localização: Português (pt_BR) padrão, Inglês (en) fallback
- Code generation: `flutter pub run build_runner build --delete-conflicting-outputs`
