<!-- Context: project-intelligence/business-tech-bridge | Priority: high | Version: 3.1 | Updated: 2026-07-02 -->

# Business ↔ Technical Bridge — BlocoNaRua

**Core Concept**: Maps each business concept to its entity, repository, use case, and Cubit. Read top-down for "why this code exists."

---

## Concept → Code Map

| Business Concept | Entity (Domain)         | Repo (Data)                       | UseCase (Domain)            | Cubit (UI)             | Route                  |
| ---------------- | ----------------------- | --------------------------------- | --------------------------- | ---------------------- | ---------------------- |
| **Block**         | `CarnivalBlocksEntity`    | `ICarnivalBlocksRepository`         | (orchestrated by others)    | `BlockDetailsCubit`      | `/carnival-block/:id`    |
| **Member**        | `MembersEntity`           | `IMembersRepository`                | `GetCurrentUserData`        | `ProfileCubit`           | `/profile`              |
| **Block membership** | `CarnivalBlockMembersEntity` | `ICarnivalBlockMembersRepository` | `GetHomeDataUseCase` (part) | `JoinBlockCubit`          | `/join-block/:inviteCode` |
| **Meeting**       | `MeetingsEntity`          | `IMeetingsRepository`               | `GetUserMeetingsUseCase`    | `MeetingDetailsCubit`, `CreateMeetingCubit`, `EditMeetingCubit` | `/meeting/:id`, `/create-meeting/:blockId`, `/edit-meeting/:id` |
| **Presence (RSVP)** | `MeetingPresencesEntity`  | `IMeetingPresencesRepository`       | (used directly by Cubits)   | `MeetingDetailsCubit` (sub-state) | `/meeting-presences` |
| **Authentication** | (none — Supabase auth)    | `IAuthRepository`                   | (none — direct in repo)     | `AuthCubit`              | `/login`, `/register`   |
| **Dashboard**     | (composite)               | (composite)                          | `GetHomeDataUseCase`         | `HomeCubit`              | `/` (home)               |
| **Profile**       | `MembersEntity`           | `IMembersRepository`                | `GetCurrentUserData`        | `ProfileCubit`           | `/profile`              |
| **Settings**      | (none)                    | (none)                               | (none)                      | (none)                   | `/settings`             |

---

## Detailed Bridges

### 1. "Member joins a block via invite code"
- **UI**: User pastes invite code → `JoinBlockModal`
- **Cubit**: `JoinBlockCubit` (page-scoped). Exposes `joinBlock(String inviteCode)` which: (a) loads current user via `GetCurrentUserData`, (b) looks up the matching block by invite code via `ICarnivalBlocksRepository.getAllAsync()`, (c) calls `ICarnivalBlockMembersRepository.createAsync(blockId, userId, role=0)`. Emits `JoinBlockInitial` → `JoinBlockLoading` → `JoinBlockSuccess` / `JoinBlockError`.
- **UseCase**: None yet — recommend adding `JoinBlockWithCodeUseCase` to centralize invite-code validation and the blocks lookup (currently embedded in the cubit).
- **Repo**: `ICarnivalBlocksRepository.getAllAsync()` (lookup) + `ICarnivalBlockMembersRepository.createAsync(...)` (join)

> See: `lookup/cubits.md` — `JoinBlockCubit` row (scope, state file, dependencies).
> See: `lookup/ui-organization.md` — `lib/ui/carnivalBlock/joinBlock/{cubit, widgets}/` folder layout.

### 2. "Block leader schedules a meeting"
- **UI**: `CreateMeetingScreen` → date/time pickers
- **Cubit**: `CreateMeetingCubit` validates form + dispatches
- **UseCase**: None yet — recommend `CreateMeetingUseCase`
- **Repo**: `IMeetingsRepository.createAsync(...)`

### 3. "Member RSVPs to a meeting"
- **UI**: Toggle on `MeetingDetailsScreen`
- **Cubit**: `MeetingDetailsCubit` updates internal state (presence)
- **UseCase**: None — direct repo call from cubit
- **Repo**: `IMeetingPresencesRepository.createAsync(...)` / `updateByIdAsync(...)`

### 4. "User lands on home dashboard"
- **UI**: `HomeScreen`
- **Cubit**: `HomeCubit.loadHomeData()` → emits loading → success/failure
- **UseCases**: `GetHomeDataUseCase.getCarnivalBlocks()` + `getMeetings()` (parallel via `Future.wait`)
- **Repos**: `IMembersRepository.getBlocksByMemberId`, `getMeetingsByMemberId`
- **Auth**: `GetCurrentUserData` (internal to use case)

### 5. "User signs in"
- **UI**: `LoginScreen` form
- **Cubit**: `AuthCubit` (top-level, MultiProvider)
- **Repo**: `IAuthRepository.signIn(email, password)` (which calls `Supabase.auth.signInWithPassword`)
- **Side effect**: `SharedPreferencesService.saveToken(jwt)` + `notifyListeners()` → GoRouter refresh → redirect

---

## UseCase Coverage Map

| UseCase                  | Used By Cubit(s)         | Coverage                          |
| ------------------------ | ------------------------ | --------------------------------- |
| `GetCurrentUserData`       | `AuthCubit`, `GetHomeDataUseCase`, `GetUserMeetingsUseCase` | HIGH — auth context |
| `GetHomeDataUseCase`       | `HomeCubit`                | 100% — single consumer           |
| `GetUserMeetingsUseCase`   | `UserMeetingsCubit`        | 100% — single consumer           |

**Gap**: Many Cubits (e.g., `CreateMeetingCubit`, `AddMemberCubit`, `EditBlockCubit`) call repositories DIRECTLY without a UseCase. See `living-notes.md` for cleanup plan.

---

## Anti-Bridges (smells to avoid)

| Smell                                              | Better                                      |
| -------------------------------------------------- | ------------------------------------------- |
| Cubit imports `lib/data/repositories/...`           | Cubit should ONLY import `lib/domain/use_cases/` |
| Repo imports `lib/ui/...`                           | Keep data layer free of UI                 |
| Entity imports `package:flutter/...`                | Entities must be pure Dart                 |
| UseCase imports `package:dio/...`                   | UseCases orchestrate, don't transport      |

---

## Reference

- `lookup/entities.md` — full entity catalog
- `lookup/use-cases.md` — full use case catalog
- `lookup/cubits.md` — cubit catalog
- `lookup/routes.md` — route map
- `business-domain.md` — what these concepts mean
- `living-notes.md` — gaps in use case coverage
