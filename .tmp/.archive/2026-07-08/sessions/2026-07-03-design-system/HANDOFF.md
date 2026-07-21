# Hand-off Document — Bloco na Rua Design System Migration

**Created:** 2026-07-08
**Original session:** `2026-07-03-design-system`
**Status:** ✅ **Migration complete** — all phases 0–5c done · §16 runtime bug fixed · final validation passed (analyze 0 issues, APK builds)
**Last updated:** 2026-07-08 (continuation session)

---

## 1. Project Snapshot

**Repo root:** `C:\Repos\bloco-na-rua`
**Stack:** Flutter 3.8.1, flutter_bloc 9.1.1, go_router 17.2.3, provider 6.1.5+1, equatable 2.0.7, result_dart 2.1.1, dio 5.9.0, supabase_flutter 2.10.0, shared_preferences 2.5.3, google_fonts 6.2.1 (added), cached_network_image 3.4.1 (added)
**Architecture:** Clean Architecture (UI → Domain → Data), feature-first `lib/ui/{feature}/{cubit,widgets}/`
**Locale:** pt-BR (default)
**Status of `flutter analyze`:** 0 issues (full project, 2026-07-08)
**Status of `flutter build apk --debug`:** ✅ Built `build/app/outputs/flutter-apk/app-debug.apk` (195 MB) in 70.8s on 2026-07-08
**New utility:** `lib/ui/core/widgets/display/image_url_validator.dart` — `isValidImageUrl(String?)` pure-Dart validator (see §17 for the convention)

---

## 2. Original Request

> "Elaborate a plan to implement a fresh design system for this project, you can discard what's done @lib/ui/. Make sure to invoke 'ui-ux-pro-max' skill."

User approved the full plan and instructed: **"Proceed with all by delegating to subagents."**

---

## 3. Design System Output (ui-ux-pro-max)

| Aspect | Decision |
|--------|----------|
| **Style** | Vibrant & Block-based |
| **Primary** | `#4F46E5` (Indigo) |
| **CTA** | `#F97316` (Orange) |
| **Background** | `#EEF2FF` (light) / `#0F172A` (dark) |
| **Fonts** | Fredoka (headings) + Nunito (body) via `google_fonts` |
| **Spacing** | 4px base — tokens: 4/8/12/16/24/32/48/64 |
| **Radius** | 8 buttons, 12 cards, 16 modals, full avatars |
| **Motion** | 150–300 ms, easeOutCubic, respect `disableAnimations` |
| **Icons** | Material Symbols Rounded |
| **Anti-patterns** | No emojis as icons, no scale-on-hover, no low-contrast text |

Design artifacts:
- `design-system/bloco-na-rua/MASTER.md`
- `design-system/bloco-na-rua/DESIGN_PLAN.md` (1722 lines)

---

## 4. Phases Status

| Phase | Title | Status | Output |
|-------|-------|--------|--------|
| **0** | Dependencies | ✅ DONE | Added `google_fonts` + `cached_network_image` to `pubspec.yaml`. `flutter pub get` succeeded. |
| **1** | Foundation (Tokens + Theme) | ✅ DONE | 8 files in `lib/ui/core/{tokens,theme}/` + `lib/main_app.dart` rewired |
| **2** | Core Widgets | ✅ DONE | 18 files in `lib/ui/core/widgets/{buttons,cards,inputs,feedback,display,state}/` |
| **3** | Navigation | ✅ DONE | 3 navigation widgets + `lib/routing/router.dart` rewritten to `StatefulShellRoute.indexedStack` |
| **4** | Compound Components | ✅ DONE | 4 files: `MemberCard`, `MeetingCard`, `BlockCard`, `PresenceChip` |
| **5a** | Auth Screens | ✅ DONE | `login_screen.dart` + `signup_screen.dart` rewritten |
| **5b** | Main Features + BlockList | ✅ DONE | 7 screen rewrites + 3 new files (`BlockListCubit/State/Screen`) wired into router |
| **5c** | Cleanup | ✅ DONE | `lib/ui/core/colors/` + 12 old top-level widget files deleted (see §10) |
| **5b-extended** | Detail/Modal Screens | ✅ DONE | 8 modal/detail screens migrated (see §9 for full list) |
| **Final** | Validation | ✅ DONE | `flutter analyze` = 0 issues, `flutter build apk --debug` succeeds |
| **§16** | Runtime image-URL bug | ✅ DONE | Validator + 3 callsite edits (see §16 / §17) |

---

## 5. Phase 1 — Tokens & Theme (DONE)

### Tokens — `lib/ui/core/tokens/`

| File | Class | Notes |
|------|-------|-------|
| `app_colors.dart` | `class AppColors` | 24 `static const Color` |
| `app_spacing.dart` | `class Spacing` | 16 `static const double` (uses `// ignore_for_file: constant_identifier_names` for CSS-style `space_4xs`) |
| `app_radius.dart` | `class Radii` | 7 numeric + 6 generic `BorderRadius` + 8 component `BorderRadius` (note: **NOT** `AppRadius` — avoids conflict with Flutter's `Radius`) |
| `app_duration.dart` | `class AppDurations` + `class AppCurves` | 5 durations + 4 curves |
| `app_typography.dart` | `class AppTypography` | 15 `static TextStyle get` getters (6 Fredoka headings + 9 Nunito body) |

### Theme — `lib/ui/core/theme/`

| File | Notes |
|------|-------|
| `app_color_schemes.dart` | Top-level `const ColorScheme lightColorScheme` + `darkColorScheme`. All 27 Material 3 roles. Uses `AppColors.xxx` + `Color(0xFF...)` for derived shades. |
| `app_text_themes.dart` | Private `_buildTextTheme({required Color textColor})` helper. Top-level `final TextTheme lightTextTheme` + `darkTextTheme`. (Uses `.copyWith(color: textColor)` because `TextStyle.apply()` doesn't support `bodyColor`/`displayColor` — only `TextTheme.apply()` does. Functionally equivalent.) |
| `app_theme.dart` | `class AppTheme { AppTheme._(); static ThemeData light(); static ThemeData dark(); }`. 8 component themes per mode (appBarTheme, cardTheme, filledButtonTheme, outlinedButtonTheme, textButtonTheme, inputDecorationTheme, iconTheme, dividerTheme). |

### Integration

`lib/main_app.dart` — surgical 3-line edit:
- Import: `package:bloco_na_rua/ui/core/theme/bloco_na_rua_theme.dart` → `package:bloco_na_rua/ui/core/theme/app_theme.dart`
- `theme: BlocoNaRuaTheme.lightTheme` → `theme: AppTheme.light()`
- `darkTheme: BlocoNaRuaTheme.darkTheme` → `darkTheme: AppTheme.dark()`

---

## 6. Phase 2 — Core Widgets (DONE)

**18 widgets** in `lib/ui/core/widgets/`:

| Folder | File | Class | Public API summary |
|--------|------|-------|--------------------|
| `buttons/` | `app_button.dart` | `AppButton` + `AppButtonVariant { primary, secondary, tertiary, ghost }` + `AppButtonSize { sm, md, lg }` | `AppButton({required String label, AppButtonVariant variant = .primary, AppButtonSize size = .md, Widget? icon, Widget? trailingIcon, VoidCallback? onPressed, bool isLoading = false, bool isDisabled = false, bool isFullWidth = false})` |
| `buttons/` | `app_icon_button.dart` | `AppIconButton` + `AppIconButtonSize { sm=36, md=44, lg=52 }` | `AppIconButton({required IconData icon, AppIconButtonSize size = .md, Color? color, VoidCallback? onPressed, String? tooltip})` |
| `buttons/` | `app_fab.dart` | `AppFAB` + `AppFabSize { sm=40, md=56, lg=72 }` | `AppFAB({required IconData icon, required VoidCallback onPressed, String? label, AppFabSize size = .md})` |
| `cards/` | `app_card.dart` | `AppCard` + `AppCardElevation { none=0, xs=1, sm=2, md=4, lg=8 }` | `AppCard({required Widget child, VoidCallback? onTap, AppCardElevation elevation = .sm, EdgeInsetsGeometry? padding, BorderRadius? radius, Color? color})` |
| `cards/` | `app_list_tile.dart` | `AppListTile` | `AppListTile({required String title, String? subtitle, Widget? leading, Widget? trailing, VoidCallback? onTap, VoidCallback? onLongPress, bool isThreeLine = false, EdgeInsetsGeometry? padding})` |
| `inputs/` | `app_text_field.dart` | `AppTextField` | `AppTextField({String? label, String? hint, String? helperText, String? errorText, IconData? prefixIcon, Widget? suffixIcon, bool obscureText = false, TextInputType? keyboardType, TextInputAction? textInputAction, TextEditingController? controller, ValueChanged<String>? onChanged, ValueChanged<String>? onSubmitted, FormFieldValidator<String>? validator, bool isMultiline = false, bool isEnabled = true, int? maxLines, bool autofocus = false, List<TextInputFormatter>? inputFormatters})` |
| `inputs/` | `app_dropdown.dart` | `AppDropdown<T>` + `AppDropdownItem<T>` | `AppDropdown<T>({String? label, T? value, required List<AppDropdownItem<T>> items, ValueChanged<T?>? onChanged, String? hint, String? errorText, bool isEnabled = true})` and `AppDropdownItem<T>({required T value, required String label, Widget? icon})` |
| `inputs/` | `app_search_field.dart` | `AppSearchField extends StatefulWidget` | `AppSearchField({String? hint, ValueChanged<String>? onChanged, ValueChanged<String>? onSubmitted, TextEditingController? controller, bool autofocus = false})` |
| `feedback/` | `app_snackbar.dart` | `class AppSnackbar` (private constructor, static helpers only) | 4 statics: `success`, `error`, `warning`, `info` — `({BuildContext context, required String message, String? actionLabel, VoidCallback? onAction})` |
| `feedback/` | `app_dialog.dart` | `class AppDialog` (private constructor, static helpers only) | 2 statics: `confirm(...) → Future<bool?>` and `alert(...) → Future<void>` |
| `feedback/` | `app_loading_indicator.dart` | `AppLoadingIndicator` + `AppLoadingIndicatorVariant { circular, pulse }` | `AppLoadingIndicator({double size = 24, Color? color, AppLoadingIndicatorVariant variant = .circular, double strokeWidth = 3})` |
| `display/` | `app_avatar.dart` | `AppAvatar` + `AvatarSize { xs=24, sm=32, md=48, lg=64, xl=96 }` + `AvatarShape { circle, square, roundedSquare }` | Uses `CachedNetworkImage`. Initials fallback hashed to 6-color palette (primary/cta/success/info + 2 inline `Color(0xFF8B5CF6)` purple + `Color(0xFFEC4899)` pink — comment them as AVATAR_PALETTE). |
| `display/` | `app_chip.dart` | `AppChip` + `ChipVariant { filled, outlined, soft }` + 4 factories (presencePresent, presenceAbsent, memberRole, meetingStatus) | `AppChip({required String label, Widget? avatar, VoidCallback? onDeleted, VoidCallback? onPressed, ChipVariant variant = .filled, Color? color})` |
| `display/` | `app_badge.dart` | `AppBadge` + `BadgeSize { sm, md }` | `AppBadge({required String label, Color? color, BadgeSize size = .md, Widget? child})` |
| `display/` | `app_section_header.dart` | `AppSectionHeader` | `AppSectionHeader({required String title, String? subtitle, Widget? action, Widget? leading, EdgeInsetsGeometry? padding})` |
| `state/` | `app_loading.dart` | `AppLoading` (full-screen) | `AppLoading({String? message, double size = 40})` — static icon when `MediaQuery.disableAnimationsOf(context)` is true |
| `state/` | `app_error.dart` | `AppError` (full-screen) | `AppError({String? title, String? message, IconData? icon, VoidCallback? onRetry, String? retryLabel})` |
| `state/` | `app_empty.dart` | `AppEmpty` (full-screen) | `AppEmpty({String? title, String? message, IconData? icon, String? actionLabel, VoidCallback? onAction})` |

### Convention reminders for ALL widgets

- snake_case.dart files
- `class AppXxx extends StatelessWidget` (state only when needed: `AppSearchField`)
- All colors/spacings/radii/durations/curves via tokens — **zero** hardcoded values
- `MediaQuery.disableAnimationsOf(context)` check before any animation
- Hover/press feedback via opacity (0.9) or elevation (NOT scale transforms that shift parent layout)
- Double quotes on all string literals
- No emojis
- Top-of-file doc comment

### Bug fixes discovered during Phase 2

- `app_card.dart`: Used deprecated `Matrix4..translate()` — replaced with `..translateByDouble(0.0, _, 0.0, 1.0)`
- `app_dropdown.dart`: Used deprecated `DropdownButtonFormField.value:` — replaced with `initialValue:`
- `app_bottom_nav.dart`: Added `super.key` for `use_key_in_widget_constructors` lint

---

## 7. Phase 3 — Navigation (DONE)

### 3 widgets in `lib/ui/core/widgets/navigation/`

| File | Class | Notes |
|------|-------|-------|
| `app_app_bar.dart` | `AppAppBar extends StatelessWidget implements PreferredSizeWidget` | `({required String title, Widget? leading, List<Widget>? actions, bool centerTitle = false, Color? backgroundColor, Color? foregroundColor, double? elevation = 0, bool showBackButton = true, PreferredSizeWidget? bottom})` |
| `app_bottom_nav.dart` | `AppBottomNav extends StatelessWidget` + top-level `AppBottomNavItem` | Uses Material 3 `NavigationBar`. Max 5 items (assertion). Default colors theme-aware. `AppBottomNavItem({required IconData icon, IconData? activeIcon, required String label, String? tooltip})` |
| `app_shell.dart` | `AppShell extends StatelessWidget` | Takes `StatefulNavigationShell` + items list. Renders optional AppAppBar + body + bottom nav. |

### Router rewrite — `lib/routing/router.dart`

**Converted flat `GoRoute` list → `StatefulShellRoute.indexedStack` with 5 branches + slide-transition modals outside shell.**

Top-level const:
```dart
const _shellNavItems = <AppBottomNavItem>[
  AppBottomNavItem(icon: Icons.home_rounded, label: "Início"),
  AppBottomNavItem(icon: Icons.celebration_rounded, label: "Blocos"),
  AppBottomNavItem(icon: Icons.event_rounded, label: "Reuniões"),
  AppBottomNavItem(icon: Icons.people_rounded, label: "Membros"),
  AppBottomNavItem(icon: Icons.person_rounded, label: "Perfil"),
];
```

**5 shell branches:**

| Branch | Path | Screen |
|--------|------|--------|
| 0 Home | `Routes.home` (`/`) | `HomeScreen` |
| 1 Blocks | `Routes.carnivalBlocks` (`/carnival-blocks`) — NEW constant | `BlockListScreen` (Phase 5b) |
| 2 Meetings | `Routes.userMeetings` (`/user-meetings`) | `UserMeetingsScreen` |
| 3 Members | `Routes.members` (`/members`) | `MembersScreen` |
| 4 Profile | `Routes.profile` (`/profile`) | `ProfileScreen` |

**Preserved:** `_redirect`, `refreshListenable: authRepository`, `errorBuilder` (NotFoundScreen/ErrorScreen), `_buildPageWithSlideTransition` helper, login/register as plain routes, all modal routes (block details, meeting details, create/edit, join-block, add-member, settings, presences) outside the shell with slide transition.

### New route constant added

`lib/routing/routes.dart` — added `carnivalBlocks = '/carnival-blocks'` next to existing `carnivalBlock = '/carnival-block'`.

---

## 8. Phase 4 — Compound Components (DONE)

| File | Class | Notes |
|------|-------|-------|
| `lib/ui/core/widgets/cards/member_card.dart` | `MemberCard` | Wraps `MembersEntity`. `({required MembersEntity member, VoidCallback? onTap, String? roleLabel, Color? roleColor, bool showEmail = true, bool isOnline = false})` |
| `lib/ui/core/widgets/cards/meeting_card.dart` | `MeetingCard` | Wraps `MeetingsEntity`. Formats `meetingDateTime` (ISO 8601) via `DateFormat("dd MMM yyyy • HH:mm", "pt_BR")` from `package:intl`. `({required MeetingsEntity meeting, VoidCallback? onTap, int? totalPresences, int? confirmedPresences, bool showDescription = false})` |
| `lib/ui/core/widgets/cards/block_card.dart` | `BlockCard` | Wraps `CarnivalBlocksEntity`. Uses `CachedNetworkImage` for cover. `({required CarnivalBlocksEntity block, VoidCallback? onTap, int? memberCount, List<String>? tags})` |
| `lib/ui/core/widgets/display/presence_chip.dart` | `PresenceChip` + `PresenceVariant { present, absent, pending }` | 3 factories: `PresenceChip.present()`, `.absent()`, `.pending()`. Delegates to `AppChip` with semantic colors. `({PresenceVariant variant, required String label, bool showIcon = true})` |

---

## 9. Phase 5 — Features (5a done · 5b done · 5b-extended done · 5c done)

### 5a — Auth (DONE)

| File | What changed |
|------|--------------|
| `lib/ui/auth/login/widgets/login_screen.dart` | Uses `AppTextField`, `AppButton`, `AppCard`, `AppSnackbar`. Forgot password uses custom `_ForgotPasswordDialog` (since `AppDialog` doesn't support form fields). |
| `lib/ui/auth/signUp/widgets/signup_screen.dart` | Same as login. Phone field uses `AppTextField.inputFormatters` (added this param to AppTextField in Phase 5a). Preserves `brasil_fields.TelefoneInputFormatter`. |
| `lib/ui/auth/logout/widgets/logout_button.dart` (Phase 5b Batch 1) | `LogoutButton` uses `AppButton` + `AppDialog.confirm(isDestructive: true)` + `AppSnackbar`. `BlocConsumer<AuthCubit>` for state. |
| **AppTextField extended** | Added `inputFormatters: List<TextInputFormatter>?` param + `import "package:flutter/services.dart";` |

### 5b — Main Features (DONE)

**8 screens rewrote / 3 new files created:**

| File | Status |
|------|--------|
| `lib/ui/home/widgets/home_screen.dart` | REWRITE — `AppAppBar`, `AppSectionHeader`, `BlockCard`, `MeetingCard`, `AppLoading/AppError`, `AppFAB`. `HomeState` does NOT have `userName` or `members` fields — used static "Olá!" greeting. |
| `lib/ui/members/widgets/members_screen.dart` | REWRITE — `AppAppBar`, `MemberCard`, `AppLoading/AppError/AppEmpty`, `RefreshIndicator`, error snackbar via `BlocListener`. |
| `lib/ui/profile/widgets/profile_screen.dart` | REWRITE — `AppAppBar`, `AppAvatar`, `AppCard`, `AppListTile` for navigation entries. Logout calls `AuthCubit.logout()`. NOTE: `AppListTile` does NOT support `titleStyle` param — used red icon for logout hint. |
| `lib/ui/settings/widgets/settings_screen.dart` | REWRITE — `AppAppBar`, `AppSectionHeader`, `AppCard`, `AppListTile`, `AppDialog.confirm` for logout. **Theme persistence via `SharedPreferences` key `THEME_MODE`** with index (0=system, 1=light, 2=dark). Wired to `ThemeCubit` + `BlocBuilder<ThemeCubit, ThemeMode>` in `main_app.dart` (see §11). |
| `lib/ui/meetings/userMeetings/widgets/user_meetings_screen.dart` | REWRITE — `AppAppBar(title: "Reuniões")`, `AppSearchField` (local search), `MeetingCard`, `AppLoading/AppError/AppEmpty`, `RefreshIndicator`. |
| `lib/ui/meeting_presences/widgets/meeting_presences_screen.dart` | REWRITE — `AppAppBar` + `AppEmpty` placeholder (since `MeetingPresencesCubit` was a TODO in original). CTA navigates to `Routes.userMeetings`. |
| `lib/ui/auth/logout/widgets/logout_button.dart` | REWRITE — see 5a above |
| `lib/ui/carnivalBlock/blockList/cubit/block_list_state.dart` | **NEW** — `BlockListState` + `BlockListStatus { initial, loading, success, failure }`. Uses `Equatable` + 4 factory constructors + `copyWith`. |
| `lib/ui/carnivalBlock/blockList/cubit/block_list_cubit.dart` | **NEW** — `BlockListCubit extends Cubit<BlockListState>` constructor takes `getHomeDataUseCase: GetHomeDataUseCase` (from `lib/domain/use_cases/home/get_home_data_use_case.dart`). NOTE: There is NO `IListCarnivalBlocksUseCase` — `GetHomeDataUseCase.getCarnivalBlocks()` returns `AsyncResult<List<CarnivalBlocksEntity>>`. |
| `lib/ui/carnivalBlock/blockList/widgets/block_list_screen.dart` | **NEW** — `BlockListScreen` uses `BlocProvider<BlockListCubit>`, `BlocConsumer`, `AppAppBar`, `AppLoading/AppError/AppEmpty`, `AppFAB` for "Criar bloco", `BlockCard` in `ListView.builder`. |

### Router update (Phase 5b)

`lib/routing/router.dart` Shell Branch 1 changed from placeholder `Scaffold + AppEmpty` to real `BlockListScreen` wrapped in `BlocProvider<BlockListCubit>` with `getHomeDataUseCase: context.read()..loadBlocks()`. **Removed unused `app_empty.dart` import.**

---

## 10. Phase 5c — Cleanup (DONE)

All old design-system artifacts have been deleted. The new `lib/ui/core/{tokens,theme,widgets}/` tree is the single source of truth.

### Deleted files

- `lib/ui/core/colors/` (entire directory: `app_colors.dart`, `role_colors.dart`)
- `lib/ui/core/widgets/{avatar_member,badge_widget,card_button,chip_date,copy_code_card,empty_state_widget,error_snackbar,error_state_widget,offline_banner,profile_button,section_header,server_error_card}.dart` (12 files)
- `lib/ui/core/theme/{bloco_na_rua_theme,light_theme,dark_theme}.dart` (3 files)

The 8 modal/detail screens that previously held the only references to the old artifacts were rewritten to the new design system first (see §9 — 5b-extended). The pre-existing `_getRoleColor` warning in `block_details_screen.dart:586` was eliminated when that file was rewritten.

---

## 11. Post-Migration Status

All items from the original Future Work list are complete. The migration is **closed**.

| Item | Description | Status |
|------|-------------|--------|
| A. Phase 5b-extended | Migrate 8 unmigrated modal/detail screens | ✅ DONE |
| B. Phase 5c | Delete old theme/colors/widgets after A completes | ✅ DONE |
| C. Theme persistence | Wire `SharedPreferences` to `main_app.dart` via `ThemeCubit` | ✅ DONE |
| D. Final validation | `flutter analyze` + `flutter build apk --debug` | ✅ DONE |
| **§16 Runtime bug** | `CachedNetworkImageProvider("img")` crash fix | ✅ DONE |

### Theme persistence details

- `lib/ui/core/theme/theme_cubit.dart` — `Cubit<ThemeMode>` that persists the index (0=system, 1=light, 2=dark) under `SharedPreferences` key `"THEME_MODE"`. `load()` on init, `setMode(...)` on change.
- `lib/main_app.dart` — `MultiBlocProvider` includes `ThemeCubit()..load()`; `BlocBuilder<ThemeCubit, ThemeMode>` drives `MaterialApp.themeMode`. Survives reboots and updates live on toggle.
- `lib/ui/settings/widgets/settings_screen.dart` — toggles via `context.read<ThemeCubit>().setMode(...)` and shows a confirmation `AppSnackbar`.

### Runtime bug resolution

See §16 for the full resolution (validator utility + 3 callsite edits) and §17 for the adopted convention.

### Backend follow-up (separate ticket)

The API still returns `"img"` (rather than `null` or a real URL) for blocks without an uploaded cover photo. The frontend is now defensive against this (see §16/§17), but the contract should be cleaned up at the source. Options:

- **(a) Backend returns `null`** — preferred. Falls through `isValidImageUrl` cleanly and removes the placeholder string from the API.
- **(b) Backend returns a fully-qualified default placeholder URL** (e.g. `https://cdn.example.com/blocks/default.png`).
- **(c) Frontend joins a known `MEDIA_BASE_URL` constant** when the API contract is path-only (e.g. `img/123.png`).

Document the chosen approach in `.opencode/context/project-intelligence/decisions-log.md` with date and rationale.

---

## 12. Conventions (Must Follow)

### File & folder naming

| Type | Convention | Example |
|------|-------------|---------|
| Files | `snake_case.dart` | `home_cubit.dart` |
| Folders | `camelCase` | `carnivalBlock`, `meetingPresences`, `blockList` |
| Classes | `PascalCase` | `HomeCubit`, `AppButton` |
| Entities | `PascalCase` + `Entity` | `CarnivalBlocksEntity` |
| Interfaces | `PascalCase` + `I` prefix | `IMembersRepository` |
| State classes | `PascalCase` + `State` | `HomeState` |
| State enums | `PascalCase` + `Status` | `HomeStatus` (values: `camelCase`) |
| Cubit classes | `PascalCase` + `Cubit` | `HomeCubit` |
| Screen widgets | `PascalCase` + `Screen` | `HomeScreen` |
| Variables | `camelCase` | `userCount` |
| Constants | `camelCase` (no `k` prefix) | `pagePaddingMobile` |
| Routes | kebab-case or `/` | `/carnival-blocks` |
| String literals | **double quotes** | `"text"` not `'text'` |

### Token discipline (zero tolerance for hardcoded values)

- ❌ `Color(0xFF...)`, `Colors.X.Y`, `Colors.white` outside the avatar palette
- ❌ `EdgeInsets.all(16)`, `padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)`
- ❌ `BorderRadius.circular(12)`, `Radius.circular(16)`
- ❌ `Duration(milliseconds: 300)`, `Curves.easeOutCubic`
- ❌ `fontSize: 14`, `FontWeight.bold`
- ✅ `AppColors.primary`, `Spacing.space_sm`, `Radii.card`, `AppDurations.normal`, `AppCurves.standard`, `AppTypography.titleMedium`

**Acceptable exceptions:**
- `Colors.white` only in: `AppSnackbar` (semantic alert foreground), `AppChip` avatar icons (semantic), `AppAvatar` fallback (initials on colored bg), `AppLoadingIndicator` (loading on color)
- Inline `Color(0xFF8B5CF6)` (purple) + `Color(0xFFEC4899)` (pink) ONLY in `AppAvatar` (avatar palette, with `// AVATAR_PALETTE` comment)
- `Colors.transparent` (for hiding tint)

### Animations

```dart
final reduceMotion = MediaQuery.disableAnimationsOf(context);
if (reduceMotion) {
  // Use instant transitions
} else {
  // AnimatedContainer / AnimatedScale with AppDurations.fast + AppCurves.standard
}
```

### Hover / press feedback

- Hover: opacity 0.85–0.9 (NEVER scale transform on parent-shifting elements)
- Press: `AnimatedScale(0.95–0.98)` is OK for internal widgets but must not shift parent layout
- Disabled: opacity 0.5 + `onPressed = null`

### Accessibility

- Touch targets ≥ 48 dp (use `SizedBox` wrappers)
- `Tooltip` on icon buttons
- WCAG 4.5:1 contrast for body, 3:1 for large text
- Semantic labels via `Semantics` widget when needed

---

## 13. Session / Task File Locations

| Purpose | Path |
|---------|------|
| Original session context | `.tmp/sessions/2026-07-03-design-system/context.md` |
| **This handoff doc** | `.tmp/sessions/2026-07-03-design-system/HANDOFF.md` |
| Phase 1 tasks (5 token + 3 theme + 1 main_app) | `.tmp/tasks/design-system/` (task.json + subtask_01..09.json, all marked `status: "completed"`) |
| Phase 2 tasks (18 widget files) | `.tmp/tasks/widgets/` (task.json + subtask_01..26.json — note: 19–22 added in Phase 3, 23–26 in Phase 4 — all marked `completed`) |
| Phase 5a tasks (login + signup screens) | `.tmp/tasks/auth/subtask_01.json`, `subtask_02.json` (both `completed`) |
| Phase 5b tasks (8 screens + BlockList feature) | `.tmp/tasks/features/subtask_01..08.json` (all `completed`) |

**Note on `router.sh`:** The task-management `router.sh` CLI silently fails to update JSON status (npx/ts-node issue). The JSON files were updated MANUALLY throughout. Subsequent sessions shouldn't expect CLI auto-update.

---

## 14. Post-Migration Notes

The design system migration is **closed**. This handoff is now a historical record, not an active working document.

**For future work on this codebase:**

1. **Read** `.opencode/context/project-intelligence/` for established patterns (architecture, state management, naming, freezed entities, Dio pipeline, result handling).
2. **Read** `.opencode/context/project-intelligence/lookup/ui-organization.md` for the current `lib/ui/` tree.
3. **Read** §6 (widget API table), §12 (conventions), and §17 (image URL validator pattern) before adding new code.
4. **New screens** follow the `lib/ui/{feature}/{cubit, widgets}/` layout. Use `TaskManager` for batches > 4 files; direct delegation for smaller work.
5. **New image URLs** — always guard with `isValidImageUrl(...)` (see §17).

**Open follow-up tickets:**

- **Backend:** API returns `"img"` placeholder for blocks without cover photos. See §11 Backend follow-up for decision options.
- **Optional:** Add widget tests for the image URL validator and the core display widgets (deferred during initial migration per user).

---

## 15. Quick Reference Cheat-Sheet

### Adding a new screen in `lib/ui/{feature}/{cubit,widgets}/`

```dart
// widgets/my_screen.dart
import "package:bloco_na_rua/ui/core/widgets/buttons/app_button.dart";
import "package:bloco_na_rua/ui/core/widgets/cards/app_card.dart";
import "package:bloco_na_rua/ui/core/widgets/feedback/app_snackbar.dart";
import "package:bloco_na_rua/ui/core/widgets/navigation/app_app_bar.dart";
import "package:bloco_na_rua/ui/core/widgets/state/app_loading.dart";
// ... etc

class MyScreen extends StatelessWidget {
  const MyScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: "Título"),
      body: BlocBuilder<MyCubit, MyState>(
        builder: (context, state) => switch (state.status) {
          MyStatus.loading => const AppLoading(),
          MyStatus.failure => AppError(message: state.errorMessage, onRetry: () => context.read<MyCubit>().load()),
          MyStatus.success => AppCard(child: /* content */),
        },
      ),
    );
  }
}
```

### Wiring in router

```dart
GoRoute(
  path: Routes.myPath,
  pageBuilder: (context, state) => _buildPageWithSlideTransition(
    context: context,
    state: state,
    child: BlocProvider(create: (ctx) => MyCubit(myRepo: ctx.read())..load(), child: const MyScreen()),
  ),
),
```

## 16. Runtime Image-URL Bug — Resolution (DONE)

**Originally captured:** 2026-07-08 (live app runtime error).
**Fixed:** 2026-07-08 (continuation session).
**Adopted as project convention:** see §17.

### Symptom (captured from `dart_mcp_get_runtime_errors` against a live running app at `ws://127.0.0.1:62052`)

3 runtime errors captured, **all the same root cause** (escalation counters `errorsSinceReload: 27, 28, 29`):

```
Exception caught by image resource service
  Invalid argument(s): No host specified in URI img
  Image provider: CachedNetworkImageProvider("img", scale: 1.0)
  Image key:      CachedNetworkImageProvider("img", scale: 1.0)

Stack:
  #0 _HttpClient._openUrl (dart:_http/http_impl.dart:2986:9)
  #1 _HttpClient.openUrl (dart:_http/http_impl.dart:2863:7)
  #2 IOClient.send       (package:http/src/io_client.dart:114:38)
  #3 HttpFileService.get (package:flutter_cache_manager/src/web/file_service.dart:37:44)
  #4 WebHelper._download (package:flutter_cache_manager/src/web/web_helper.dart:115:24)
  #5 WebHelper._updateFile (package:flutter_cache_manager/src/web/web_helper.dart:96:28)
  #6 WebHelper._downloadOrAddToQueue (package:flutter_cache_manager/src/web/web_helper.dart:64:7)
```

### Diagnosis

The freezed entity `CarnivalBlocksEntity` (`lib/domain/entities/carnivalBlock/carnival_blocks_entity.dart:19,26,35`) declares:

```dart
final String carnivalBlockImage;        // required, non-nullable
```

The backend API is returning the bare placeholder string `"img"` (not a full URL) for blocks without an uploaded cover photo. This value flows directly into `CachedNetworkImageProvider("img", …)`, which tries to open `HttpClient.openUrl("img")`, fails with `ArgumentError: No host specified in URI "img"`, and the error escapes to the global `ImageResourceService` because it is wrapped in a `DecorationImage` with **no error widget**.

### Affected code (3 callsites)

| # | File:Line | Code | Has error widget? |
|---|-----------|------|-------------------|
| 1 | `lib/ui/core/widgets/cards/block_card.dart:67` | `DecorationImage(image: CachedNetworkImageProvider(block.carnivalBlockImage), …)` inside `Container`/`BoxDecoration` | ❌ **No** — `DecorationImage` has no error widget. This is the escaping point. |
| 2 | `lib/ui/core/widgets/cards/block_card.dart:71-84` | `CachedNetworkImage(imageUrl: block.carnivalBlockImage, …, errorWidget: …)` | ✅ Yes, but the `DecorationImage` at line 67 throws first and short-circuits the errorWidget. |
| 3 | `lib/ui/carnivalBlock/blockDetails/widgets/block_details_screen.dart:420-439` | `CachedNetworkImage(imageUrl: carnivalBlock.carnivalBlockImage, …, errorWidget: …)` guarded by `if (hasImage) …` | ✅ Yes for `CachedNetworkImage`, ⚠️ but the `hasImage` flag does not validate the URL is actually fetchable (just checks the string is non-empty). |

**Existing partial defensive check (NOT enough):** `lib/ui/core/widgets/display/app_avatar.dart:190` already does:

```dart
if (imageUrl == null || imageUrl!.trim().isEmpty) {
  return /* initials or icon */;
}
```

This catches `null` and `""` but **not** the literal string `"img"` (which is neither null nor empty).

### Resolution applied

1. **Created** `lib/ui/core/widgets/display/image_url_validator.dart` — pure-Dart `isValidImageUrl(String?, {Set<String> allowedSchemes})` that rejects null/empty/whitespace/relative paths/protocol-relative URLs/non-http(s) schemes/URLs missing a host. Returns `true` only for absolute http(s) URLs with a parseable host.
2. **Edited** `lib/ui/core/widgets/cards/block_card.dart` — removed the unsafe `BoxDecoration.image` + `DecorationImage` block; replaced with an `if (isValidImageUrl(...))` guard around a plain `CachedNetworkImage`, with a colored `Container` fallback showing `Icons.celebration_rounded` for invalid URLs.
3. **Edited** `lib/ui/carnivalBlock/blockDetails/widgets/block_details_screen.dart` — removed the `hasImage` flag; inlined `if (isValidImageUrl(carnivalBlock.carnivalBlockImage))` at the cover image use site.
4. **Edited** `lib/ui/core/widgets/display/app_avatar.dart` — replaced `imageUrl == null || imageUrl!.trim().isEmpty` with `!isValidImageUrl(imageUrl)` so backend placeholders fall back to initials/icon instead of crashing.

### Validation

- `flutter analyze` (full project): 0 issues
- `flutter build apk --debug`: succeeds (195 MB APK at `build/app/outputs/flutter-apk/app-debug.apk`)
- `grep -rn "CachedNetworkImageProvider" lib/`: 0 live callsites (only doc-comment references)
- All 3 image callsites are now guard-gated by the validator

### Why this approach (vs alternatives)

| Alternative | Verdict |
|------------|---------|
| Catch in `FlutterError.onError` global handler | ❌ Masks the issue. Users would still see the broken `Container` background with no error widget. Silent data quality loss. |
| `try/catch` around `CachedNetworkImageProvider(...)` | ❌ The error fires asynchronously inside the image cache, *not* in the construction call. Can't catch here. |
| `errorBuilder` on `DecorationImage` | ❌ `DecorationImage` has **no errorBuilder API**. This isn't a fix option — the only way to avoid the throw is to not pass a bad URL. Hence the validator + structural refactor. |
| Catch in `image_provider.dart` upstream | ❌ Upstream Flutter — out of our control. |
| **Validator + structural refactor (APPLIED)** | ✅ Chosen approach. Defense in depth: bad data never reaches `CachedNetworkImageProvider`. Existing `errorWidget: …` callbacks remain as the second line of defense. |

### Backend follow-up (separate ticket)

The fact that the API returns `"img"` (rather than `null` or `""`) for blocks without an image is a contract issue. The frontend is now defensive against this (see §16/§17), but the contract should be cleaned up at the source. Options:

- **(a) Backend returns `null`** — preferred. Falls through `isValidImageUrl` cleanly and removes the placeholder string from the API.
- **(b) Backend returns a fully-qualified default placeholder URL** (e.g. `https://cdn.example.com/blocks/default.png`).
- **(c) Frontend joins a known `MEDIA_BASE_URL` constant** when the API contract is path-only (e.g. `img/123.png`).

Document the chosen approach in `.opencode/context/project-intelligence/decisions-log.md` with date and rationale.

---

## 17. Image URL Validator — Convention

**File:** `lib/ui/core/widgets/display/image_url_validator.dart`
**Signature:** `bool isValidImageUrl(String? url, {Set<String> allowedSchemes = const {"http", "https"}})`

### When to use

Call `isValidImageUrl(...)` before passing any user/entity-supplied URL to:

- `CachedNetworkImageProvider(...)` — the unsafe one; errors fire asynchronously, escaping any `errorBuilder`.
- `CachedNetworkImage(imageUrl: ...)` — safer (has `errorWidget`), but still wastes a network request on a known-bad URL.
- `NetworkImage(...)` — same as `CachedNetworkImageProvider`.

### When NOT to use

- Don't validate hardcoded asset URLs (e.g. `AssetImage("assets/icons/foo.png")`).
- Don't validate data URIs unless you've explicitly allowed the `data` scheme via `allowedSchemes`.
- Don't validate strings that aren't URLs at all (file paths, file names, etc.).

### Why this exists

The `DecorationImage` API has **no errorBuilder**. The only way to prevent a crash from a malformed URL is to never pass the malformed URL in. The validator is the single source of truth for "is this URL safe to hand to an image provider?" — call it at every callsite that takes user-controlled URLs.

### Example

```dart
// AVOID: passing a potentially bad URL to DecorationImage
Container(
  decoration: BoxDecoration(
    image: DecorationImage(image: CachedNetworkImageProvider(block.coverUrl)),
  ),
)

// PREFER: guard with the validator, fall back to a static placeholder
if (isValidImageUrl(block.coverUrl))
  CachedNetworkImage(imageUrl: block.coverUrl, /* ... */)
else
  Container(
    color: shimmerColor,
    child: Icon(Icons.image_rounded),
  )
```

### Future extension

If a custom scheme (e.g. `data:`, `blob:`) becomes valid for the project, pass it via `allowedSchemes`:

```dart
if (isValidImageUrl(url, allowedSchemes: {"http", "https", "data"})) { /* ... */ }
```

For unit tests (deferred per project owner), the validator is pure-Dart — no Flutter bindings needed. Test cases should cover: `null`, `""`, `"   "`, `"img"`, `"img/foo.png"`, `"//cdn.example.com/x.png"`, `"data:image/png;base64,..."`, `"http://"` (no host), `"http://example.com/x.png"`, and case-insensitive scheme matching (`"HTTP://..."`).

---

**End of handoff — design system migration complete (updated 2026-07-08)**
