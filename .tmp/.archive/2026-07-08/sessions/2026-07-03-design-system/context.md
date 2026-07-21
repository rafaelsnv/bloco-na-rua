# Task Context: Fresh Design System for Bloco na Rua

**Session ID:** 2026-07-03-design-system
**Created:** 2026-07-03
**Status:** in_progress
**Owner:** user (rafae)

---

## Current Request

> "Elaborate a plan to implement a fresh design system for this project, you can discard what's done @lib/ui/. Make sure to invoke 'ui-ux-pro-max' skill."

The user has approved the full design system plan and instructed: **"Proceed with all by delegating to subagents."**

This is a multi-phase implementation that replaces the existing `lib/ui/` with a fresh design system driven by the ui-ux-pro-max skill output (Vibrant & Block-based style, Fredoka + Nunito fonts, Indigo + Orange palette).

---

## Context Files (Standards to Follow)

### Code quality / universal standards
- `.opencode/context/standards/README.md` — standards overlay strategy (no `code-quality.md` at expected path; project-specific patterns live in `project-intelligence/`)
- `.opencode/context/standards/navigation.md` — standards directory index
- `.opencode/context/standards/flutter-state-management.md` — **DOES NOT EXIST YET** (referenced in README)
- `.opencode/context/standards/flutter-ui-patterns.md` — **DOES NOT EXIST YET** (referenced in README)

### Project intelligence (authoritative patterns)
- `.opencode/context/project-intelligence/concepts/architecture.md` — Clean Architecture, 3 layers, per-layer contracts
- `.opencode/context/project-intelligence/concepts/stack.md` — versions of all packages
- `.opencode/context/project-intelligence/technical-component-pattern.md` — per-layer contract (Screen → Cubit → UseCase → Repository → ApiClient)
- `.opencode/context/project-intelligence/concepts/bloc-state-pattern.md` — Cubit state shape
- `.opencode/context/project-intelligence/concepts/freezed-entity.md` — entity generation
- `.opencode/context/project-intelligence/concepts/result-handling.md` — `AsyncResult<T>` from `result_dart`
- `.opencode/context/project-intelligence/concepts/dio-pipeline.md` — Dio + interceptors
- `.opencode/context/project-intelligence/decisions-log.md` — past decisions (pt-BR default, freezed entities, plain UI states default, Provider DI, go_router v17)
- `.opencode/context/project-intelligence/examples/widget-pattern.md` — `lib/ui/{feature}/{cubit, widgets}/` layout
- `.opencode/context/project-intelligence/examples/router-slide-transition.md` — `CustomTransitionPage` slide transition + `BlocProvider` per-route pattern
- `.opencode/context/project-intelligence/examples/module-pattern.md` — single `MultiProvider` in `lib/config/dependencies.dart`
- `.opencode/context/project-intelligence/examples/state-pattern.md` — `enum Status { initial, loading, success, failure }` + Equatable
- `.opencode/context/project-intelligence/examples/home-feature-flow.md` — end-to-end flow
- `.opencode/context/project-intelligence/lookup/ui-organization.md` — current `lib/ui/` tree (to be replaced)
- `.opencode/context/project-intelligence/lookup/naming-conventions.md` — naming rules
- `.opencode/context/project-intelligence/lookup/routes.md` — Routes catalog (paths to preserve)
- `.opencode/context/project-intelligence/lookup/cubits.md` — cubit file locations
- `.opencode/context/project-intelligence/lookup/entities.md` — entity file locations
- `.opencode/context/project-intelligence/guides/adding-feature.md` — 9-step checklist for new features
- `.opencode/context/project-intelligence/guides/error-to-user-message.md` — error → user-friendly pt-BR
- `.opencode/context/project-intelligence/errors/dio-supabase-errors.md`
- `.opencode/context/project-intelligence/errors/common-errors.md`
- `.opencode/context/project-intelligence/living-notes.md`
- `.opencode/context/project-intelligence/business-tech-bridge.md`
- `.opencode/context/project-intelligence/business-domain.md`
- `.opencode/context/project-intelligence/technical-naming.md`
- `.opencode/context/project-intelligence/technical-domain.md`
- `.opencode/context/project-intelligence/technical-api-pattern.md`
- `.opencode/context/project-intelligence/navigation.md`

### Design system files (this task)
- `design-system/bloco-na-rua/MASTER.md` — ui-ux-pro-max design system output (style, colors, typography, anti-patterns)
- `design-system/bloco-na-rua/DESIGN_PLAN.md` — full implementation plan (1716 lines, updated to align with project conventions)

---

## Reference Files (Source Material to Look At)

### App bootstrap & DI
- `lib/main.dart` — Supabase init, MultiProvider setup
- `lib/main_app.dart` — MaterialApp.router, locale, themeMode
- `lib/config/dependencies.dart` — single DI file (Provider-based)
- `lib/routing/routes.dart` — route path constants (PRESERVE)
- `lib/routing/router.dart` — current flat GoRoute list (TO REPLACE with StatefulShellRoute)

### Existing theme (to be REPLACED — discard)
- `lib/ui/core/theme/bloco_na_rua_theme.dart`
- `lib/ui/core/theme/light_theme.dart`
- `lib/ui/core/theme/dark_theme.dart`
- `lib/ui/core/colors/app_colors.dart`
- `lib/ui/core/colors/role_colors.dart`

### Existing widgets (to be REPLACED — discard)
- `lib/ui/core/widgets/avatar_member.dart`
- `lib/ui/core/widgets/badge_widget.dart`
- `lib/ui/core/widgets/card_button.dart`
- `lib/ui/core/widgets/chip_date.dart`
- `lib/ui/core/widgets/copy_code_card.dart`
- `lib/ui/core/widgets/empty_state_widget.dart`
- `lib/ui/core/widgets/error_snackbar.dart`
- `lib/ui/core/widgets/error_state_widget.dart`
- `lib/ui/core/widgets/offline_banner.dart`
- `lib/ui/core/widgets/profile_button.dart`
- `lib/ui/core/widgets/section_header.dart`
- `lib/ui/core/widgets/server_error_card.dart`

### Features (to be REBUILT with new design system — keep cubit/state files where possible)
- `lib/ui/auth/` (login, signUp, logout, AuthCubit)
- `lib/ui/home/` (cubit + screen)
- `lib/ui/carnivalBlock/` (addMember, blockDetails, createBlock, editBlock, joinBlock)
- `lib/ui/meetings/` (createMeeting, editMeeting, meetingDetails, userMeetings)
- `lib/ui/meetingPresences/`
- `lib/ui/members/`
- `lib/ui/profile/`
- `lib/ui/settings/`
- `lib/ui/error/widgets/error_screen.dart`
- `lib/ui/not_found/widgets/not_found_screen.dart`

### Dependency manifest
- `pubspec.yaml` — current versions:
  - `flutter_bloc: ^9.1.1` ✓
  - `go_router: ^17.2.3` ✓
  - `provider: ^6.1.5+1` ✓
  - `equatable: ^2.0.7` ✓
  - `result_dart: ^2.1.1` ✓
  - `dio: ^5.9.0` ✓
  - `supabase_flutter: ^2.10.0` ✓
  - `shared_preferences: ^2.5.3` ✓
  - **MISSING:** `google_fonts`, `cached_network_image` (need to add)

---

## External Docs Fetched

- `https://pub.dev/packages/go_router` — confirmed 17.3.0 is current (Flutter Favorite, 3.45M weekly downloads)
- `https://pub.dev/documentation/go_router/latest/go_router/StatefulShellRoute-class.html` — `StatefulShellRoute.indexedStack` is the official pattern for bottom nav with state preservation
- `https://docs.flutter.dev/ui/navigation` — Flutter team recommends go_router over named routes

---

## Design System Snapshot

From `design-system/bloco-na-rua/MASTER.md`:

- **Style:** Vibrant & Block-based
- **Primary:** `#4F46E5` (Indigo) | **CTA:** `#F97316` (Orange) | **Background:** `#EEF2FF` (light) / `#0F172A` (dark)
- **Fonts:** Fredoka (headings, playful rounded) + Nunito (body, clean warm) — both via `google_fonts`
- **Spacing:** 4px base (4/8/12/16/24/32/48/64)
- **Radius:** 8px buttons, 12px cards, 16px modals, full for avatars
- **Motion:** 150-300ms, easeOutCubic, respect `disableAnimations`
- **Icons:** Material Symbols Rounded
- **Anti-patterns to avoid:** emojis as icons, missing cursor feedback, layout-shifting hovers, low contrast text, instant state changes, invisible focus states

---

## Components

### Phase 0 — Dependencies
- Add `google_fonts: ^6.2.1` to pubspec.yaml
- Add `cached_network_image: ^3.4.1` to pubspec.yaml
- Run `flutter pub get`

### Phase 1 — Foundation
- `lib/ui/core/tokens/app_colors.dart` — all color constants
- `lib/ui/core/tokens/app_spacing.dart` — Spacing class with all spacing tokens
- `lib/ui/core/tokens/app_radius.dart` — Radius class with all radius tokens
- `lib/ui/core/tokens/app_duration.dart` — animation duration tokens
- `lib/ui/core/tokens/app_typography.dart` — typography styles (using GoogleFonts)
- `lib/ui/core/theme/app_color_schemes.dart` — light + dark ColorScheme
- `lib/ui/core/theme/app_text_themes.dart` — TextTheme with Fredoka + Nunito
- `lib/ui/core/theme/app_theme.dart` — ThemeData builder for light + dark
- Update `lib/main_app.dart` to use new `AppTheme.light()` / `AppTheme.dark()`

### Phase 2 — Core Widgets
- `lib/ui/core/widgets/buttons/app_button.dart` — primary/secondary/tertiary/ghost variants, sm/md/lg sizes, loading state
- `lib/ui/core/widgets/buttons/app_icon_button.dart` — sm/md/lg with tooltip
- `lib/ui/core/widgets/buttons/app_fab.dart` — basic + extended FAB
- `lib/ui/core/widgets/cards/app_card.dart` — with onTap, elevation variants
- `lib/ui/core/widgets/cards/app_list_tile.dart` — title/subtitle/leading/trailing
- `lib/ui/core/widgets/inputs/app_text_field.dart` — label, hint, helper, error, prefix/suffix icons
- `lib/ui/core/widgets/inputs/app_dropdown.dart` — typed dropdown
- `lib/ui/core/widgets/inputs/app_search_field.dart` — search variant with clear button
- `lib/ui/core/widgets/feedback/app_snackbar.dart` — success/error/warning/info helpers
- `lib/ui/core/widgets/feedback/app_dialog.dart` — confirm/alert presets
- `lib/ui/core/widgets/feedback/app_loading_indicator.dart` — circular + pulse variants
- `lib/ui/core/widgets/display/app_avatar.dart` — with CachedNetworkImage + initials fallback
- `lib/ui/core/widgets/display/app_chip.dart` — filled/outlined/soft variants, color presets
- `lib/ui/core/widgets/display/app_badge.dart` — small badge component
- `lib/ui/core/widgets/display/app_section_header.dart` — title + action
- `lib/ui/core/widgets/state/app_loading.dart` — full-screen loading
- `lib/ui/core/widgets/state/app_error.dart` — full-screen error with retry
- `lib/ui/core/widgets/state/app_empty.dart` — full-screen empty with optional CTA

### Phase 3 — Navigation & App Shell
- `lib/ui/core/widgets/navigation/app_app_bar.dart` — themed AppBar
- `lib/ui/core/widgets/navigation/app_bottom_nav.dart` — 5-item bottom nav
- `lib/ui/core/widgets/navigation/app_shell.dart` — `StatefulShellRoute.indexedStack` wrapper
- `lib/routing/router.dart` — REWRITE to use `StatefulShellRoute.indexedStack` with 5 branches (Home, Blocks, Meetings, Members, Profile)
- Preserve auth redirect, slide transitions for non-shell routes, errorBuilder

### Phase 4 — Compound Components
- `lib/ui/core/widgets/cards/member_card.dart` — avatar + name + handle + role chip
- `lib/ui/core/widgets/cards/meeting_card.dart` — title + date/time/location + presence stats
- `lib/ui/core/widgets/cards/block_card.dart` — image + name + member count + tags
- `lib/ui/core/widgets/cards/presence_chip.dart` — present/absent/pending variants

### Phase 5 — Features (rebuild with new design system)
- **5a. Auth:** custom login_screen.dart + register_screen.dart using new AppTextField, AppButton, AppCard
- **5b. Other features:** home, carnivalBlock (list/detail/create/edit/join), meetings (list/detail/create/edit/presences), members, profile, settings
- **5c. Discard:** delete `lib/ui/core/{colors, theme, widgets}/` (replaced), all `lib/ui/{feature}/widgets/*.dart` (replaced), `lib/routing/router.dart` (replaced)

---

## Constraints

1. **MUST follow project naming conventions:**
   - Files: `snake_case.dart`
   - Folders: `camelCase`
   - Classes: `PascalCase` with NO `I` prefix on concrete (only on interfaces)
   - Constants: `camelCase` (no `k` prefix)
   - String literals: double quotes

2. **MUST follow per-feature convention:** `lib/ui/{feature}/{cubit, widgets}/`

3. **MUST preserve:**
   - All `Routes.x` path constants in `lib/routing/routes.dart`
   - The slide transition pattern (for non-shell routes)
   - The auth redirect logic
   - The `BlocProvider(create: ...)` pattern in route pageBuilders
   - All entities in `lib/domain/`
   - All repositories in `lib/data/`
   - All use cases in `lib/domain/`
   - All existing cubits and their state classes
   - DI registration in `lib/config/dependencies.dart`

4. **MUST use:**
   - `google_fonts` for Fredoka + Nunito
   - `cached_network_image` for member avatars and block photos
   - `StatefulShellRoute.indexedStack` for main app navigation
   - `flutter_bloc` 9.1.1 (design system widgets stay stateless)
   - `result_dart` `AsyncResult<T>` for any new async work

5. **MUST NOT:**
   - Add widget tests in this task (deferred per user)
   - Change package versions of existing dependencies
   - Touch `lib/domain/`, `lib/data/`, `lib/config/dependencies.dart`
   - Introduce emojis as icons
   - Use hardcoded colors / spacing (always use tokens)
   - Use scale transforms for hover (use opacity/elevation)

6. **Theme persistence:** Wire `shared_preferences` to persist `ThemeMode` (system/light/dark) in Settings page.

7. **Delete vs replace:** Old `lib/ui/core/{colors, theme, widgets}/*` must be DELETED, not left alongside the new files. The new `lib/ui/core/` is the single source of truth.

---

## Exit Criteria

- [ ] `pubspec.yaml` has `google_fonts` and `cached_network_image`; `flutter pub get` succeeds
- [ ] `lib/ui/core/tokens/` contains all 5 token files
- [ ] `lib/ui/core/theme/` contains 3 theme files; light + dark themes build correctly
- [ ] `lib/ui/core/widgets/` contains all primitive widgets from Phase 2
- [ ] `lib/ui/core/widgets/navigation/app_shell.dart` + `app_bottom_nav.dart` + `app_app_bar.dart` implemented
- [ ] `lib/routing/router.dart` uses `StatefulShellRoute.indexedStack` with 5 branches
- [ ] `lib/main_app.dart` uses new `AppTheme.light()` / `AppTheme.dark()` with `GoogleFonts.fredoka()` and `GoogleFonts.nunito()`
- [ ] All Phase 4 compound components implemented
- [ ] Auth feature rebuilt with custom forms using new design system
- [ ] All other features (home, carnivalBlock, meetings, members, profile, settings) rebuilt
- [ ] Old `lib/ui/core/{colors, theme, widgets}/*` and old `lib/ui/{feature}/widgets/*.dart` DELETED
- [ ] `flutter analyze` passes with 0 errors
- [ ] `flutter build apk --debug` succeeds
- [ ] No emojis used as icons
- [ ] No hardcoded colors / spacing (verified by grep)
- [ ] All text strings use double quotes

---

## Implementation Notes

1. **Bottom nav items (5):**
   - Home (`Icons.home_rounded`) → `/home`
   - Blocks (`Icons.celebration_rounded`) → `/carnival-blocks`
   - Meetings (`Icons.event_rounded`) → `/meetings`
   - Members (`Icons.people_rounded`) → `/members`
   - Profile (`Icons.person_rounded`) → `/profile`

2. **Modal routes (full-screen, outside shell):**
   - `/create-block` → CreateBlockScreen
   - `/edit-block/:id` → EditBlockScreen
   - `/create-meeting/:blockId` → CreateMeetingScreen
   - `/edit-meeting/:id` → EditMeetingScreen
   - `/add-member/:blockId` → AddMemberScreen
   - `/join-block` → JoinBlockModal
   - `/user-meetings` → UserMeetingsScreen

3. **Auth gate:** Unchanged — `IAuthRepository.validateSession()` redirects to `/login` if invalid, `/home` if valid and on auth routes.

4. **Avatar palette** (for initials fallback, rotates by name hash):
   - `#4F46E5` (primary), `#F97316` (cta), `#10B981` (success), `#3B82F6` (info), `#8B5CF6` (purple), `#EC4899` (pink)

5. **Light + dark themes:** Both must be implemented and toggle via `ThemeMode.system` (default) with manual override available.
