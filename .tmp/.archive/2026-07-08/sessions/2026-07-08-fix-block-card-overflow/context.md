# Task Context: Fix BlockCard overflow + dedupe auth API call

Session ID: 2026-07-08-fix-block-card-overflow
Created: 2026-07-08T15:30:00Z
Completed: 2026-07-08T18:35:00Z
Status: completed

## Original Request
Fix two issues found via `dart_mcp_get_runtime_errors` + `dart_mcp_get_app_logs`:
1. RenderFlex vertical overflow (4px) in `lib/ui/core/widgets/cards/block_card.dart:57:14`
2. Duplicate `GET /Members/uuid/{uuid}` API calls on app boot

Then expand to fix two horizontal Row overflows discovered during validation:
3. Horizontal Row overflow (45px) in `block_card.dart:123` (long invite code)
4. Horizontal Row overflow (97px) in `block_details_screen.dart:484` (long invite/manager code)

## Context Files (Standards Followed)
- `.opencode/context/project-intelligence/concepts/architecture.md` — Clean Architecture (UI → Domain → Data)
- `.opencode/context/project-intelligence/errors/common-errors.md` — Cubit/Bloc state patterns
- `.opencode/context/project-intelligence/concepts/result-handling.md` — `AsyncResult<T>` (result_dart) pattern

## Reference Files Touched
- `lib/ui/core/widgets/cards/block_card.dart` — image 120→100, ClipRect wrap, 2× Flexible+ellipsis
- `lib/ui/home/widgets/home_screen.dart` — `IntrinsicHeight` reverted to `SizedBox(height: 200)` + comment
- `lib/data/repositories/auth/auth_repository.dart` — `_currentMember` cache, `currentMember` getter, populate/clear lifecycle
- `lib/data/repositories/auth/iauth_repository.dart` — `currentMember` getter in interface
- `lib/domain/use_cases/auth/get_current_user_data.dart` — cache-first read with API fallback
- `lib/ui/carnivalBlock/blockDetails/widgets/block_details_screen.dart` — `_InviteCodeRow` code text → Flexible+ellipsis

## External Docs Fetched
(none needed)

## Components
1. **BlockCard widget** (UI layer)
2. **AppCard widget** (UI layer)
3. **Home screen** (UI layer)
4. **AuthRepository** (Data layer)
5. **IAuthRepository** (Domain layer)
6. **GetCurrentUserData use case** (Domain layer)
7. **Block details screen** (UI layer)

## Constraints Applied
- Clean Architecture: cache at Data layer (`AuthRepository`), expose via Domain interface (`IAuthRepository`)
- `AsyncResult<T>` (result_dart) for new methods, no raw throws
- `AuthRepository` extends `ChangeNotifier` — all state mutations are correct
- All hardcoded `120` references in `block_card.dart` updated to `100`
- `AppSpacing` tokens remain the design system source of truth

## Exit Criteria — FINAL

### Original vertical overflow fix
- [x] BlockCard image height is 100px (no other value) — **5/5 occurrences updated** (lines 73, 76, 81, 84, 92)
- [x] BlockCard has ClipRect wrap as defensive guard — `block_card.dart:60`
- [x] Home screen sized correctly — `SizedBox(height: 200)` (carousel design choice) with explanatory comment
- [x] AuthRepository caches member on successful `validateSession()` — `auth_repository.dart:97`
- [x] IAuthRepository exposes `MembersEntity? get currentMember` (sync getter) — `iauth_repository.dart:15`
- [x] GetCurrentUserData returns cached member when available, falls back to API — `get_current_user_data.dart:23-27`
- [x] No new compile errors — `dart_mcp_analyze_files` returns "No errors"
- [x] Hot reload succeeds — `dart_mcp_hot_reload` returned "Hot reload succeeded"
- [x] Runtime errors list no longer contains the BlockCard vertical overflow — `dart_mcp_get_runtime_errors` returns 0
- [⚠️] App logs show only ONE `GET /Members/uuid/{uuid}` per app load — **partial: 2 calls** (race condition, see Code Review H1 + H3 and Findings below)

### Horizontal overflow fixes
- [x] BlockCard info Row no longer overflows — `Flexible` + ellipsis on member count + invite code texts
- [x] `_InviteCodeRow` no longer overflows — `Flexible` + ellipsis on code text
- [x] Hot reload succeeded after fixes
- [x] Runtime errors = 0 after hot reload (block_details_screen verified; block_card.dart needs visual confirmation by user navigating back to home)

## Code Review Results (CodeReviewer subagent, 2026-07-08T18:32:00Z)

**Verdict:** Solid implementation. 0 critical, 3 high, 4 medium, 3 low.

### High (worth addressing)
- **H1**: `signUp` doesn't backfill `_currentMember` from `_registerMember` result → wastes an API call right after signup. **File**: `auth_repository.dart:182-188`
- **H2**: No invalidation hook when member is updated server-side → latent stale-cache risk. **File**: `auth_repository.dart:30, 72, 97`
- **H3**: `GetCurrentUserData` cache-miss path doesn't write back to cache → only one duplicate eliminated per render frame. **File**: `get_current_user_data.dart:30-39`

### Medium
- **M1**: Misleading log message `"Failed to login"` in token-save-failure branch. **File**: `auth_repository.dart:144`
- **M2**: Dead null-check `if (member == null) return memberResult;` is a no-op. **File**: `get_current_user_data.dart:36-39`
- **M3**: `SizedBox(height: 200)` will overflow if `tags` ever non-null (commented as known risk)
- **M4**: `ClipRect` redundant vs. Card's own `clipBehavior` (harmless; defensive)

### Low
- **L1**: Pre-existing `Success(null)` handling in `GetCurrentUserData` could throw
- **L2**: `ProfileCubit` bypasses cache (architectural choice, defensible)
- **L3**: Microtask invalidation window after `login()`

### Verified OK (12 items)
✅ All 4 cache-clear paths present, interface contract clean, naming consistent, comments clear, no race condition between `validateSession` and `GetCurrentUserData`, security model acceptable, `AsyncResult` return type correct, image height is 100px everywhere, `ClipRect` does not clip `InkWell` ripple (verified render tree).

## Follow-up Tasks (still pending)

1. **Memoize `validateSession()`** in `AuthRepository` so parallel callers share the in-flight Future. Eliminates the 2x `GET /Members/uuid/{uuid}` race between router redirect and `HomeCubit.loadHomeData()`.
2. **H1 from code review**: Backfill `_currentMember` from `_registerMember` result in `signUp`.
3. **H2 from code review**: Add a TODO comment (or invalidation hook) for future member-update flows.
4. **H3 from code review**: Add `set currentMember` to interface OR have `GetCurrentUserData` write back to cache.
5. **M1 from code review**: Fix misleading log message.
6. **Investigate other duplicate API calls** observed in logs: `GET /Members/4/blocks` (2x), `GET /CarnivalBlocks/1` (2x). Separate root cause, separate investigation.
7. **`OnBackInvokedCallback` manifest warning** — Android manifest config, separate ticket.

## Cleanup

When done with this session, remove with:
```bash
rm -rf "C:\Repos\bloco-na-rua\.tmp\sessions\2026-07-08-fix-block-card-overflow"
```

Or move to `.archive/2026-07-08/` if keeping a permanent record.
