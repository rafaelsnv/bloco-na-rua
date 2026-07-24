# Task Context: Design System Migration — Extension (Phases 5b-extended + 5c + Theme Wire + Validation)

**Session ID:** 2026-07-08-design-system-extended
**Created:** 2026-07-08
**Status:** in_progress
**Owner:** user (rafae)
**Source session:** `2026-07-03-design-system` (Phases 0–5b done, 5c partial)

---

## Current Request

> "read @.tmp/sessions/2026-07-03-design-system/HANDOFF.md and @.tmp/sessions/2026-07-03-design-system/context.md and continue with the tasks from the previous session"

User approved the proposed 3-batch scope:
- **Batch 1 (Phase 5b-extended):** Rewrite 8 unmigrated detail/modal screens
- **Batch 2 (Phase 5c + Theme Wire):** Delete 17 legacy files + wire `SharedPreferences` `THEME_MODE` into `main_app.dart`
- **Batch 3 (Final Validation):** `flutter analyze` (0 errors) + `flutter build apk --debug` (success) + grep for hardcoded values

---

## Prior Context (source of truth)

**All design system standards, conventions, widget APIs, completion status, and reference files are documented in:**

- `.tmp/sessions/2026-07-03-design-system/HANDOFF.md` (443 lines — PRIMARY)
- `.tmp/sessions/2026-07-03-design-system/context.md` (289 lines — original planning)

Every downstream task (TaskManager, CoderAgent, TestEngineer) MUST read HANDOFF.md first. Key sections:
- §6 — Core Widgets API table (all 18 primitives)
- §9 — Phase 5 patterns (5a/5b done) for screen rewrite conventions
- §11.A — Widget-by-widget mapping for the 8 unmigrated screens
- §12 — Conventions (naming, tokens, animations, hover, accessibility)
- §13 — File locations of completed tasks
- §15 — Quick reference (screen + router patterns)

---

## Context Files (Standards to Follow)

Same as source session — all under `.opencode/context/`. Specifically authoritative for this phase:

- `.opencode/context/standards/README.md`
- `.opencode/context/project-intelligence/concepts/architecture.md`
- `.opencode/context/project-intelligence/concepts/stack.md`
- `.opencode/context/project-intelligence/technical-component-pattern.md`
- `.opencode/context/project-intelligence/concepts/bloc-state-pattern.md`
- `.opencode/context/project-intelligence/examples/widget-pattern.md`
- `.opencode/context/project-intelligence/examples/router-slide-transition.md`
- `.opencode/context/project-intelligence/examples/module-pattern.md`
- `.opencode/context/project-intelligence/examples/state-pattern.md`
- `.opencode/context/project-intelligence/lookup/ui-organization.md`
- `.opencode/context/project-intelligence/lookup/naming-conventions.md`
- `.opencode/context/project-intelligence/lookup/routes.md`
- `.opencode/context/project-intelligence/lookup/cubits.md`
- `.opencode/context/project-intelligence/lookup/entities.md`
- `.opencode/context/project-intelligence/guides/adding-feature.md`
- `.opencode/context/project-intelligence/guides/error-to-user-message.md`
- `.opencode/context/project-intelligence/errors/dio-supabase-errors.md`
- `.opencode/context/project-intelligence/errors/common-errors.md`
- `.opencode/context/project-intelligence/decisions-log.md`
- `.opencode/context/project-intelligence/living-notes.md`
- `design-system/bloco-na-rua/MASTER.md`
- `design-system/bloco-na-rua/DESIGN_PLAN.md`

---

## Reference Files (Source Material to Look At)

### App bootstrap & DI (read-only context for understanding)
- `lib/main.dart` — Supabase init
- `lib/main_app.dart` — MaterialApp.router, locale, themeMode (NEEDS EDIT in Batch 2)
- `lib/config/dependencies.dart` — DI registration
- `lib/routing/routes.dart` — route constants
- `lib/routing/router.dart` — already wired for all 8 modal screens (no changes needed)

### Files to REWRITE (Batch 1)
- `lib/ui/carnivalBlock/blockDetails/widgets/block_details_screen.dart` (606 LOC)
- `lib/ui/meetings/meetingDetails/widgets/meeting_details_screen.dart` (530 LOC)
- `lib/ui/carnivalBlock/createBlock/widgets/create_block_screen.dart` (290 LOC)
- `lib/ui/meetings/createMeeting/widgets/create_meeting_screen.dart` (284 LOC)
- `lib/ui/carnivalBlock/joinBlock/widgets/join_block_modal.dart` (257 LOC)
- `lib/ui/carnivalBlock/editBlock/widgets/edit_block_screen.dart` (207 LOC)
- `lib/ui/meetings/editMeeting/widgets/edit_meeting_screen.dart` (186 LOC)
- `lib/ui/carnivalBlock/addMember/widgets/add_member_screen.dart` (127 LOC)

### Files to KEEP (cubits are already correct — no changes)
- All 8 cubit/state pairs in `lib/ui/carnivalBlock/*/cubit/` and `lib/ui/meetings/*/cubit/`

### Files to EDIT (Batch 2)
- `lib/main_app.dart` — wire `themeMode` from `SharedPreferences`

### Files to DELETE (Batch 2)
`lib/ui/core/widgets/` (12 files at top-level, co-located with new subfolders):
- `avatar_member.dart`
- `badge_widget.dart`
- `card_button.dart`
- `chip_date.dart`
- `copy_code_card.dart`
- `empty_state_widget.dart`
- `error_snackbar.dart`
- `error_state_widget.dart`
- `offline_banner.dart`
- `profile_button.dart`
- `section_header.dart`
- `server_error_card.dart`

`lib/ui/core/theme/` (3 files):
- `bloco_na_rua_theme.dart` (legacy entry point)
- `dark_theme.dart`
- `light_theme.dart`

`lib/ui/core/colors/` (2 files — entire directory):
- `app_colors.dart`
- `role_colors.dart`

### Design system primitives (READ-only — already complete)
- `lib/ui/core/tokens/` (5 files)
- `lib/ui/core/theme/` (3 new files: `app_color_schemes.dart`, `app_text_themes.dart`, `app_theme.dart`)
- `lib/ui/core/widgets/buttons/` (3 files)
- `lib/ui/core/widgets/cards/` (5 files including compound)
- `lib/ui/core/widgets/display/` (5 files including `presence_chip.dart`)
- `lib/ui/core/widgets/feedback/` (3 files)
- `lib/ui/core/widgets/inputs/` (3 files)
- `lib/ui/core/widgets/navigation/` (3 files)
- `lib/ui/core/widgets/state/` (3 files)

---

## External Docs Fetched

None required — no new external libraries. All widgets are already implemented using existing dependencies (`google_fonts`, `cached_network_image`, `intl`, `flutter_bloc`, `result_dart`).

---

## Design System Snapshot

From `design-system/bloco-na-rua/MASTER.md`:

- **Style:** Vibrant & Block-based
- **Primary:** `#4F46E5` (Indigo) | **CTA:** `#F97316` (Orange) | **Background:** `#EEF2FF` (light) / `#0F172A` (dark)
- **Fonts:** Fredoka (headings) + Nunito (body) via `google_fonts`
- **Spacing:** 4px base — tokens: 4/8/12/16/24/32/48/64
- **Radius:** 8 buttons, 12 cards, 16 modals, full avatars
- **Motion:** 150–300 ms, easeOutCubic, respect `disableAnimations`
- **Icons:** Material Symbols Rounded
- **Anti-patterns:** No emojis as icons, no scale-on-hover, no low-contrast text

---

## Components

### Batch 1 — Phase 5b-extended: 8 screen rewrites

| #  | File                                       | Form pattern       | Key widgets                                                                                            | Cubit (already wired in router)                                |
| -- | ------------------------------------------ | ------------------ | ------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------- |
| 01 | `block_details_screen.dart`                | Detail (own/man.)  | `AppAppBar`, `MemberCard`, `AppFAB`, `AppLoading`/`AppError`/`AppEmpty`, `AppCard`, `AppListTile`, `AppSectionHeader` | `BlockDetailsCubit(carnivalBlocksRepository, getCurrentUserData, carnivalBlockId)` |
| 02 | `meeting_details_screen.dart`              | Detail (presences) | `AppAppBar`, `AppFAB`, `MemberCard`, `PresenceChip`, `AppListTile`, `AppButton`, `AppSectionHeader`              | `MeetingDetailsCubit(meetingsRepository, meetingPresencesRepository, authRepository, carnivalBlocksRepository, meetingId)` |
| 03 | `create_block_screen.dart`                 | Form               | `AppAppBar`, `AppTextField`, `AppButton`, `AppCard`, `AppSnackbar`                                                | uses `CreateBlockCubit`                                         |
| 04 | `edit_block_screen.dart`                   | Form (prefilled)   | Same as #03                                                                                            | `EditBlockCubit(carnivalBlocksRepository, carnivalBlockId)`    |
| 05 | `create_meeting_screen.dart`               | Form + dropdown    | `AppAppBar`, `AppTextField`, `AppDropdown`, `AppButton`, `AppCard`, `AppSnackbar`                                | `CreateMeetingCubit(meetingsRepository)`                        |
| 06 | `edit_meeting_screen.dart`                 | Form (prefilled)   | Same as #05                                                                                            | `EditMeetingCubit(meetingsRepository)`                          |
| 07 | `join_block_modal.dart`                    | Modal (code input) | `AppAppBar`, `AppTextField` (invite code), `AppButton`, `AppSnackbar`                                          | uses `JoinBlockCubit`                                            |
| 08 | `add_member_screen.dart`                   | List + search/add  | `AppAppBar`, `AppSearchField`, `MemberCard`, `AppButton`                                                       | `AddMemberCubit(membersRepository, carnivalBlockMembersRepository)` |

### Batch 2 — Phase 5c: Delete legacy code
- 12 legacy top-level widget files in `lib/ui/core/widgets/`
- 3 legacy theme files in `lib/ui/core/theme/`
- 2 files in `lib/ui/core/colors/` (delete entire `colors/` directory)
- Edit `lib/main_app.dart` to wire `THEME_MODE` from `SharedPreferences`

### Batch 3 — Final Validation
- `flutter analyze` → 0 errors
- `flutter build apk --debug` → success
- `grep -r "Colors\\.\|EdgeInsets\\.all([^)]*[^.0-9]\|fontSize: [0-9]" lib/ui/core/widgets/ lib/ui/` → no hardcoded values outside tokens

---

## Constraints (inherited from source session)

1. **MUST follow project naming conventions:** files `snake_case.dart`, folders `camelCase`, classes `PascalCase`, constants `camelCase` (no `k` prefix), double quotes on string literals.
2. **MUST follow per-feature convention:** `lib/ui/{feature}/{cubit, widgets}/` — keep cubit folder, only rewrite `widgets/*.dart`.
3. **MUST preserve:**
   - All `Routes.x` constants in `lib/routing/routes.dart`
   - Slide transition pattern (already wired in router)
   - Auth redirect logic (`_redirect`)
   - `BlocProvider(create: ...)` pattern in router pageBuilders (already wired for all 8 modal screens)
   - All entities in `lib/domain/`
   - All repositories in `lib/data/`
   - All use cases in `lib/domain/`
   - All existing cubits and their state classes (sealed-class cubit patterns)
   - DI registration in `lib/config/dependencies.dart`
4. **MUST use:**
   - Design system primitives from `lib/ui/core/widgets/` only
   - `google_fonts` for Fredoka + Nunito
   - `cached_network_image` for avatars/images
   - `Material Symbols Rounded` icons
   - `result_dart` `AsyncResult<T>` for any new async work (forbidden to change existing cubits though)
5. **MUST NOT:**
   - Add widget tests (deferred per user)
   - Change package versions in pubspec.yaml
   - Touch `lib/domain/`, `lib/data/`, `lib/config/dependencies.dart`
   - Introduce emojis as icons
   - Use hardcoded colors / spacing / radii / durations (tokens only)
   - Use scale transforms for hover (opacity/elevation only)
   - Change existing cubits or state classes — only the `widgets/*.dart` files
   - Change `lib/routing/router.dart` — already fully wired for all 8 screens with the correct `BlocProvider` setup
6. **Theme persistence:** Persist `ThemeMode` via `SharedPreferences` key `THEME_MODE` (index 0/1/2). Settings screen already writes; main_app.dart needs to READ on boot.
7. **No emojis** used as icons (match avatars / initials only).
8. **All strings double-quoted.**
9. **All animation transitions check `MediaQuery.disableAnimationsOf(context)`.**

---

## Exit Criteria

### Batch 1 (Phase 5b-extended)
- [ ] All 8 `widgets/*.dart` files rewritten using new design system primitives (no references to old widgets or old colors)
- [ ] Each rewritten screen uses `AppAppBar` for navigation
- [ ] Each rewritten screen uses `AppLoading`/`AppError`/`AppEmpty` for state branches (where the cubit has loading/error states)
- [ ] Forms (`create_block`, `edit_block`, `create_meeting`, `edit_meeting`, `join_block`, `add_member`) use `AppTextField` + `AppButton` + `AppCard`
- [ ] Detail screens (`block_details`, `meeting_details`) use compound widgets (`MemberCard`, `PresenceChip`, `BlockCard`, `MeetingCard`)
- [ ] `flutter analyze` returns 0 errors, no new warnings introduced
- [ ] No imports of `lib/ui/core/colors/app_colors.dart` or `lib/ui/core/colors/role_colors.dart` from migrated screens
- [ ] No imports of legacy top-level widgets (`avatar_member.dart`, `badge_widget.dart`, etc.) from migrated screens

### Batch 2 (Phase 5c + Theme Wire)
- [ ] All 17 legacy files deleted (`lib/ui/core/colors/` + 12 old widgets + 3 old theme files)
- [ ] `lib/main_app.dart` reads `THEME_MODE` from `SharedPreferences` on boot and wires `themeMode` to `MaterialApp.router`
- [ ] `flutter analyze` still 0 errors after deletion
- [ ] `flutter analyze` still 0 errors after theme wire

### Batch 3 (Final Validation)
- [ ] `flutter analyze` shows 0 errors (the pre-existing `_getRoleColor` warning should be GONE since that file was rewritten/deleted)
- [ ] `flutter build apk --debug` succeeds
- [ ] grep for hardcoded values in `lib/ui/` returns nothing

---

## Implementation Notes

1. **Bottom nav 5 items:** Home (`Icons.home_rounded`) `/`, Blocks (`Icons.celebration_rounded`) `/carnival-blocks`, Meetings (`Icons.event_rounded`) `/user-meetings`, Members (`Icons.people_rounded`) `/members`, Profile (`Icons.person_rounded`) `/profile`.

2. **Modal routes already wired in router** (no router changes needed):
   - `${Routes.carnivalBlock}/:id` → `BlockDetailsScreen`
   - `${Routes.meeting}/:id` → `MeetingDetailsScreen`
   - `${Routes.editMeeting}/:id` → `EditMeetingScreen`
   - `${Routes.editBlock}/:id` → `EditBlockScreen`
   - `Routes.joinBlock` → `JoinBlockModal`
   - `Routes.createBlock` → `CreateBlockScreen`
   - `/create-meeting/:blockId` → `CreateMeetingScreen`
   - `/add-member/:blockId` → `AddMemberScreen`

3. **Cubit construction is identical to what's already in `lib/routing/router.dart` lines 192–317** — CoderAgents must NOT touch the constructor signature.

4. **State classes are sealed-class patterns** (e.g. `BlockDetailsInitial` / `BlockDetailsLoading` / `BlockDetailsLoaded` / `BlockDetailsError`) — pattern matching with `switch`/`if (state is X)` in screens.

5. **Navigation after action:**
   - Create → pop + `AppSnackbar.success` + refresh list/detail
   - Edit → pop + `AppSnackbar.success` + call cubit `loadX()`
   - Delete → `AppDialog.confirm(isDestructive: true)` first → pop + `AppSnackbar.info`
   - Join → pop + `AppSnackbar.success`/`error`

6. **`_getRoleColor` warning (current `block_details_screen.dart:586`)** — the user-noted warning will be GONE automatically when that file is rewritten in Batch 1 (the unused private function won't be carried over).

7. **Avatar palette** (initials fallback only, on `AppAvatar`):
   - `#4F46E5` primary, `#F97316` cta, `#10B981` success, `#3B82F6` info, `#8B5CF6` purple, `#EC4899` pink (last two are inline `Color(0xFF...)` — ONLY in `app_avatar.dart`).

8. **Theme wire pattern:**
   - On app boot: `final prefs = await SharedPreferences.getInstance(); final themeIndex = prefs.getInt("THEME_MODE") ?? 0;`
   - Convert index → `ThemeMode` (0=system, 1=light, 2=dark)
   - Lift `themeMode` into a `StatefulWidget` / state so settings can update at runtime via `setState` and re-write to prefs
   - Keep `ThemeMode.system` as default

9. **`pubspec.yaml` dependencies** (DO NOT TOUCH):
   - `flutter_bloc: ^9.1.1`, `go_router: ^17.2.3`, `provider: ^6.1.5+1`, `equatable: ^2.0.7`, `result_dart: ^2.1.1`, `dio: ^5.9.0`, `supabase_flutter: ^2.10.0`, `shared_preferences: ^2.5.3`, `google_fonts: ^6.2.1` (added), `cached_network_image: ^3.4.1` (added)
