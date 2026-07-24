# Task Context: Code Review Fix — All 32 Issues

Session ID: 2026-07-11-code-review-fix
Created: 2026-07-11T00:00:00Z
Status: completed
Completed: 2026-07-13T00:00:00Z

## Current Request
Fix all 32 code review issues identified by CodeReviewer across lib/. Phase 1 (critical security) skipped — requires backend API changes.

## Context Files (Standards to Follow)
- .opencode/context/standards/overrides.md (local decisions — READ FIRST)
- .opencode/context/project-intelligence/concepts/architecture.md
- .opencode/context/project-intelligence/technical-component-pattern.md
- .opencode/context/project-intelligence/concepts/bloc-state-pattern.md
- .opencode/context/project-intelligence/concepts/freezed-entity.md
- .opencode/context/project-intelligence/concepts/result-handling.md
- .opencode/context/project-intelligence/lookup/naming-conventions.md
- .opencode/context/project-intelligence/lookup/token-discipline.md

## Reference Files (Source Material)
All files under lib/ — see full structure below.

## Components
Phase 2 (High Priority):
  - H1: N+1 fix — BlockDetailsScreen member loading
  - H2: Invite-code endpoint — JoinBlockCubit refactor
  - H3: Reflection removal — BaseApiClient explicit endpoints
  - H4: getAllAsync 404 fix — MeetingPresencesRepository
  - H5: currentUuid race — AuthRepository caching
  - H6: markPresence snackbar — listenWhen in MeetingDetailsScreen

Phase 3 (Medium Priority):
  - M1: _extractUserMessage extraction to core/errors/
  - M2: Remove profileImage: 'TODO' literal
  - M3: Remove stub meetingPresences route
  - M4: Fix freezed orphan files
  - M5: Separate AuthListenable from AuthRepository
  - M6: Fix dynamic meeting type
  - M7: Fix MemberCreate.fromJson signature
  - M8: Fix logout return type
  - M9: Fix signUp null check symmetry
  - M10: Add mounted guards
  - M11: Use design tokens instead of magic numbers

Phase 4 (Low Priority):
  - L1: Enforce single quote style
  - L2: Remove unused imports
  - L3: Fix CachedNetworkImage cache key
  - L4: Configure disk cache max age
  - L5: DateTime.parse try-catch in HomeCubit
  - L6: Gate logging by build mode
  - L7: Add unit tests
  - L8: Remove/stub integration_test dependency
  - L9: Promote ImageUrlValidator to wrapper
  - L10: Add PT-BR accents to UI strings
  - L11: Document isPresent API contract

## Constraints
- Phase 1 (C1-C4) SKIPPED — requires backend API changes
- All changes are frontend-only (lib/)
- Flutter/Dart project at C:\Repos\bloco-na-rua

## Exit Criteria
- [x] All Phase 2 (H1-H6) issues fixed and validated
- [x] All Phase 3 (M1-M11) issues fixed and validated
- [x] All Phase 4 (L1-L11) issues fixed and validated
- [x] No new lint warnings introduced
- [x] dart analyze passes clean

## Completion Summary
- `flutter analyze lib/` → No issues found
- `flutter test` → 15 new tests pass (1 pre-existing widget_test failure unrelated)
- Phase 1 (C1-C4) skipped pending backend changes — documented in PENDING_BACKEND_FIXES.md
- 28 subtasks executed across 10 batches via CoderAgent subagents
- All subtasks from .tmp/tasks/code-review-fix/ marked completed
