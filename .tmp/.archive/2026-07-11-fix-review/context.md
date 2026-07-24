# Task Context: Fix All Code Review Issues

Session ID: 2026-07-11-fix-review
Created: 2026-07-11T00:00:00
Status: completed
Completed: 2026-07-13T00:00:00Z

## Current Request
Fix all 32 code review issues identified in the codebase review. Phase 1 (critical security fixes) is SKIPPED — requires backend API changes that will be handled separately. Proceeding with Phases 2, 3, and 4.

## Context Files (Standards to Follow)

### Local Project Standards
- `.opencode/context/paths.json` — context root: `.opencode/context/`
- `.opencode/context/standards/overrides.md` — **CRITICAL**: Local override: Cubit UI State Pattern uses plain `Equatable` + `enum Status`, NOT sealed classes (overrides global dart.md lines 47–61). **LOCAL WINS**
- `.opencode/context/standards/references.md` — links to global standards
- `.opencode/context/project-intelligence/concepts/bloc-state-pattern.md` — local authoritative Cubit state decision tree
- `.opencode/context/project-intelligence/concepts/freezed-entity.md` — freezed entity pattern with `EntityBase` superclass
- `.opencode/context/project-intelligence/concepts/dio-pipeline.md` — Dio request pipeline + Supabase hybrid transport
- `.opencode/context/project-intelligence/concepts/result-handling.md` — `AsyncResult<T>` / `Result<T>` conventions
- `.opencode/context/project-intelligence/guides/adding-feature.md` — 9-step feature checklist (5-layer contract)
- `.opencode/context/project-intelligence/technical-component-pattern.md` — 5-layer component contract (Screen → Cubit → UseCase → Repository → ApiClient)
- `.opencode/context/project-intelligence/decisions-log.md` — architecture decisions log
- `.opencode/context/project-intelligence/lookup/naming-conventions.md` — naming conventions
- `.opencode/context/standards/flutter-state-management.md` — Flutter state management patterns
- `.opencode/context/standards/flutter-ui-patterns.md` — Flutter UI/component guide

### Global Standards (via references)
- `@~/.config/opencode/context/core/standards/code-quality.md` — modular/functional/maintainable, pure functions, immutability
- `@~/.config/opencode/context/core/standards/dart.md` — Dart conventions (⚠️ OVERRIDDEN by local)
- `@~/.config/opencode/context/core/standards/security-patterns.md` — validation, secret handling
- `@~/.config/opencode/context/development/principles/clean-code.md` — naming, SRP, DRY

## Reference Files (Source Material)

### Key Files to Modify
- `lib/data/services/api/base/base_api_client.dart` — reflection-based endpoint derivation (H3)
- `lib/data/repositories/meetingPresences/meeting_presences_repository.dart` — getAllAsync 404 (H4)
- `lib/data/repositories/auth/auth_repository.dart` — currentUuid race (H5), logout return type (M8)
- `lib/ui/meetings/meetingsList/widgets/meeting_list_screen.dart` — design tokens (M11)
- `lib/ui/carnivalBlock/blockDetails/widgets/block_details_screen.dart` — N+1 (H1), mounted guards (M10)
- `lib/ui/carnivalBlock/joinBlock/cubit/join_block_cubit.dart` — full table scan (H2)
- `lib/ui/meetings/meetingDetails/cubit/meeting_details_cubit.dart` — snackbar repetition (H6)
- `lib/ui/meetings/meetingDetails/widgets/meeting_details_screen.dart` — dynamic type (M6), magic numbers (M11)
- `lib/ui/profile/cubit/profile_cubit.dart` — freezed orphan (M4)
- `lib/ui/core/widgets/cards/block_card.dart` — cache (L4)
- `lib/ui/core/widgets/display/app_avatar.dart` — cache key (L3)
- `lib/data/services/api/members/create/member_create.dart` — fromJson signature (M7)
- `lib/data/services/api/members/update/member_update.dart` — fromJson signature (M7)
- `lib/data/services/auth/auth_api_client.dart` — signUp null check (M9)
- `lib/main.dart` — logging level (L6)
- `pubspec.yaml` — integration_test dep (L8)
- `lib/routing/router.dart` — meetingPresences stub (M3)
- `lib/ui/home/cubit/home_cubit.dart` — DateTime.parse (L5)
- `lib/config/dependencies.dart` — ChangeNotifier pattern (M5)

### 12 Cubits with duplicated _extractUserMessage (M1)
`home_cubit.dart`, `block_list_cubit.dart`, `create_meeting_cubit.dart`, `edit_meeting_cubit.dart`, `meeting_details_cubit.dart`, `user_meetings_cubit.dart`, `create_block_cubit.dart`, `edit_block_cubit.dart`, `add_member_cubit.dart`, `join_block_cubit.dart`, `members_cubit.dart`, `profile_cubit.dart`

## External Docs Fetched
None required — Phase 1 (Dio validateStatus fix, flutter_secure_storage) skipped.

## Components

### Phase 2 — High Priority Correctness (6 tasks)
| ID  | Fix | Files |
|-----|-----|-------|
| H1  | Fix N+1 in BlockDetailsScreen — use Future.wait or backend expand | `block_details_screen.dart` |
| H2  | Add invite-code lookup — refactor JoinBlockCubit to use `GET /CarnivalBlocks/by-invite/{code}` | `join_block_cubit.dart` + new API client |
| H3  | Remove reflection-based endpoint — explicit endpoint in each API client | `base_api_client.dart` + all API clients |
| H4  | Fix getAllAsync 404 — implement properly or remove | `meeting_presences_repository.dart` |
| H5  | Fix currentUuid race — cache `Future<String?>` not resolved value | `auth_repository.dart` |
| H6  | Fix markPresence snackbar — add listenWhen to BlocListener | `meeting_details_screen.dart` |

### Phase 3 — Medium Priority Quality (11 tasks)
| ID  | Fix | Files |
|-----|-----|-------|
| M1  | Extract _extractUserMessage to core/errors/ | 12 cubits + `base_api_client.dart` |
| M2  | Remove profileImage: 'TODO' literal | `member_create.dart`, `auth_repository.dart`, `signup_screen.dart` |
| M3  | Remove stub meetingPresences route | `router.dart`, `meeting_presences_cubit.dart`, `meeting_presences_screen.dart` |
| M4  | Fix freezed orphan files — add annotation or delete .freezed.dart | `profile_cubit.dart`, `meeting_presences_cubit.dart` |
| M5  | Separate AuthListenable from AuthRepository | `auth_repository.dart`, `dependencies.dart`, `router.dart` |
| M6  | Fix dynamic meeting type → MeetingsEntity | `meeting_details_screen.dart` |
| M7  | Fix MemberCreate.fromJson signature → Map<String, dynamic> | `member_create.dart`, `member_update.dart` |
| M8  | Fix logout return type → AsyncResult<void> with Success(unit()) | `auth_repository.dart` |
| M9  | Fix signUp null check symmetry — also check response.user | `auth_api_client.dart` |
| M10 | Add mounted guards after async gaps | `edit_meeting_screen.dart`, `block_details_screen.dart` |
| M11 | Use design tokens instead of magic numbers | `meeting_details_screen.dart` + other files |

### Phase 4 — Low Priority Polish (11 tasks)
| ID  | Fix | Files |
|-----|-----|-------|
| L1  | Enforce single quote style — dart format | All files |
| L2  | Remove unused imports | `base_api_client.dart`, `meeting_details_screen.dart` |
| L3  | Fix CachedNetworkImage cache key — append version token | `app_avatar.dart` |
| L4  | Configure disk cache max age (7 days) | `block_card.dart`, `block_details_screen.dart` |
| L5  | Fix DateTime.parse — use DateTime.tryParse | `home_cubit.dart` |
| L6  | Gate logging by build mode | `main.dart` |
| L7  | Add unit tests for auth, presence, invite-join | `test/` (create) |
| L8  | Remove/stub integration_test dependency | `pubspec.yaml` |
| L9  | Promote ImageUrlValidator to wrapper widget | New: `core/widgets/validated_network_image.dart` |
| L10 | Add PT-BR accents to UI strings | All UI string literals |
| L11 | Document isPresent API contract | `meeting_details_cubit.dart` |

## Constraints
- **SKIP Phase 1** (C1-C4): Admin API removal, secure storage, header removal, Dio validateStatus fix — requires backend changes
- Follow local Cubit state pattern: plain `Equatable` + `enum Status` (NOT sealed classes)
- Follow 5-layer component contract: Screen → Cubit → UseCase → Repository → ApiClient
- Use Provider for DI (NOT Modular)
- All API clients must use explicit endpoint constants (remove reflection)
- Design tokens must be used via `Spacing.*` constants
- Run `dart fix --apply` and `dart format` after changes

## Exit Criteria
- [x] Phase 2: All 6 H-tasks completed (H1-H6)
- [x] Phase 3: All 11 M-tasks completed (M1-M11)
- [x] Phase 4: All 11 L-tasks completed (L1-L11)
- [x] `flutter analyze` passes with no errors
- [x] `dart build_runner build` completes successfully (for freezed changes)
- [x] No regressions in existing functionality

## Completion Summary
- `flutter analyze lib/` → No issues found
- `flutter test` → 15 new tests pass (1 pre-existing widget_test failure unrelated)
- Phase 1 (C1-C4) skipped pending backend changes — documented in PENDING_BACKEND_FIXES.md
- 28 subtasks executed across 10 batches via CoderAgent subagents
- All subtasks from .tmp/tasks/code-review-fix/ marked completed
