# Session Summary: 2026-07-08-fix-block-card-overflow

**Date:** 2026-07-08
**Duration:** ~3 hours (15:30 → 18:35)
**Status:** Completed
**Final verdict:** 0 runtime errors after hot reload; all originally-requested fixes applied; code review identified 3 high-priority follow-ups.

---

## Chronological Log

### Phase 1 — Discovery (15:30–15:50)
- Launched Flutter app on Android emulator (`emulator-5554`), connected to DTD, wrote `dart.flutterVmServiceUri` to `.vscode/settings.json`
- Retrieved runtime errors: 1 `RenderFlex overflowed by 4 pixels` at `block_card.dart:57:14`
- Retrieved app logs: spotted duplicate `GET /Members/uuid/{uuid}` calls
- Mapped the overflow math: 120px image + 84px content = 204px > 200px parent constraint

### Phase 2 — Plan (15:50–16:10)
- Identified 3 fix options + 1 follow-up, requested approval
- User: "proceed with all"

### Phase 3 — Implementation batch 1: original 4 fixes (16:10–16:45)
| #   | Fix                                                            | File                                                | Status |
| --- | -------------------------------------------------------------- | --------------------------------------------------- | ------ |
| 1   | Shrink image header 120→100                                     | `block_card.dart` (5 occurrences + 2 comments)        | ✅     |
| 2   | Add defensive `ClipRect` wrap                                   | `block_card.dart:60`                                 | ✅     |
| 3a  | Remove 200px parent constraint via `IntrinsicHeight`            | `home_screen.dart`                                   | ❌ → reverted |
| 3b  | Revert to `SizedBox(height: 200)` + explanatory comment         | `home_screen.dart`                                   | ✅     |
| 4a  | Add `_currentMember` field + `currentMember` getter              | `auth_repository.dart`                                | ✅     |
| 4b  | Populate cache in `validateSession`, clear on failure/logout/login/signUp | `auth_repository.dart`                                | ✅     |
| 4c  | Add `currentMember` to `IAuthRepository`                        | `iauth_repository.dart`                               | ✅     |
| 4d  | `GetCurrentUserData` returns cached member when present         | `get_current_user_data.dart`                          | ✅     |

### Phase 4 — Validation batch 1 (16:45–17:15)
- `dart_mcp_analyze_files` → No errors
- `dart_mcp_hot_reload` → Succeeded
- `dart_mcp_get_runtime_errors` → No errors (vertical overflow gone)
- `dart_mcp_hot_restart` → Succeeded (full boot sequence)
- **Discovered:** API dedup incomplete (still 2x), horizontal Row overflows appeared in 2 new locations

### Phase 5 — Investigation of `IntrinsicHeight` failure (17:15–17:30)
- `IntrinsicHeight` in vertical `ListView` → "Null check operator used on a null value" in `RenderViewportBase._paintContents`
- Reverted to `SizedBox(height: 200)` with explanatory comment about why it's safe now (100px image fits)
- Logout edit had wrong indentation in oldString — corrected on retry

### Phase 6 — Implementation batch 2: horizontal overflow fixes (17:30–18:15)
| #   | Fix                                                | File                                                                                    | Status |
| --- | -------------------------------------------------- | --------------------------------------------------------------------------------------- | ------ |
| 5   | BlockCard info Row: `Flexible` + ellipsis on member count + invite code | `block_card.dart:123-167`                                                                 | ✅     |
| 6   | `_InviteCodeRow`: `Flexible` + ellipsis on code text | `block_details_screen.dart:484-518`                                                      | ✅     |

### Phase 7 — Validation batch 2 (18:15–18:25)
- `dart_mcp_analyze_files` → No errors
- `dart_mcp_hot_reload` → Succeeded (after reconnecting DTD — connection was lost between reloads)
- `dart_mcp_get_runtime_errors` → **No runtime errors found** (block_details_screen verified on-device)

### Phase 8 — Code review (18:25–18:35)
- Delegated to `CodeReviewer` subagent
- Report: 0 critical, 3 high (H1, H2, H3), 4 medium, 3 low
- All 12 "Verified OK" items passed
- Updated `context.md` with final state and follow-up tasks

---

## Files Modified (5)

1. `lib/ui/core/widgets/cards/block_card.dart` — image 100px, ClipRect, 2× Flexible+ellipsis, comments
2. `lib/ui/home/widgets/home_screen.dart` — SizedBox(height: 200) with comment
3. `lib/data/repositories/auth/auth_repository.dart` — member cache lifecycle
4. `lib/data/repositories/auth/iauth_repository.dart` — currentMember getter in interface
5. `lib/domain/use_cases/auth/get_current_user_data.dart` — cache-first read
6. `lib/ui/carnivalBlock/blockDetails/widgets/block_details_screen.dart` — Flexible+ellipsis on invite code text

---

## Key Decisions

1. **Reverted IntrinsicHeight** after it broke `RenderViewportBase._paintContents`. Kept `SizedBox(height: 200)` since the card's natural height (~184px with 100px image) fits with 16px breathing room.
2. **Did not add `Flexible` to all texts** — only the two that demonstrated overflow. Kept changes minimal.
3. **Cache at Data layer, not Domain** — followed Clean Architecture; `IAuthRepository` exposes a sync getter so Domain can read.
4. **Clear cache aggressively on `login`/`signUp`** — invalidates potentially-stale data, lets `validateSession()` (always called next by router) repopulate. (Code review H1 flags this as wasteful for `signUp`; could optimize.)
5. **Did not auto-fix the 2x GET race** — flagged as follow-up H3 + memoize task, requires user approval for a more invasive change.

---

## Open Follow-ups (priority order)

1. **Memoize `validateSession()`** — eliminates the 2x `GET /Members/uuid/{uuid}` race (HIGH)
2. **H1 from code review** — backfill cache from `_registerMember` in `signUp` (5-line change)
3. **H3 from code review** — add cache backfill to `GetCurrentUserData`
4. **H2 from code review** — TODO comment for future member-update invalidation
5. **M1 from code review** — fix misleading log message
6. **Investigate** duplicate `GET /Members/4/blocks` and `GET /CarnivalBlocks/1` calls (separate root cause)
7. **`OnBackInvokedCallback` manifest config** (Android warning, not blocking)
8. **Visual confirmation** of Fix 5 (BlockCard row) — requires navigating back to home screen
