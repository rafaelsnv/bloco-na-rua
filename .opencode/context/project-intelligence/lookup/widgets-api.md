<!-- Context: project-intelligence/lookup/widgets-api | Priority: high | Version: 1.0 | Updated: 2026-07-08 -->

# Core Widgets API — Design System Primitives

**Core Concept**: 18 reusable widget primitives live in `lib/ui/core/widgets/`, organized by category. All widgets are **stateless** (except `AppSearchField` / `ThemeCubit` integration), token-driven, and follow `MediaQuery.disableAnimationsOf(context)` + opacity/elevation feedback (no scale transforms).

> Source of truth: `.tmp/.archive/2026-07-08/sessions/2026-07-03-design-system/HANDOFF.md §6` (561L) and `2026-07-08-design-system-extended/HANDOFF.md §6` (239L).

---

## Buttons (`lib/ui/core/widgets/buttons/`)

| Widget | Variants / Sizes | Constructor signature (key params only) |
|---|---|---|
| `AppButton` | `AppButtonVariant { primary, secondary, tertiary, ghost }` · `AppButtonSize { sm, md, lg }` | `({required String label, AppButtonVariant variant = .primary, AppButtonSize size = .md, Widget? icon, Widget? trailingIcon, VoidCallback? onPressed, bool isLoading = false, bool isDisabled = false, bool isFullWidth = false})` |
| `AppIconButton` | `AppIconButtonSize { sm=36, md=44, lg=52 }` | `({required IconData icon, AppIconButtonSize size = .md, Color? color, VoidCallback? onPressed, String? tooltip})` |
| `AppFAB` | `AppFabSize { sm=40, md=56, lg=72 }` | `({required IconData icon, required VoidCallback onPressed, String? label, AppFabSize size = .md})` |

## Cards (`lib/ui/core/widgets/cards/`)

| Widget | Notes | Constructor |
|---|---|---|
| `AppCard` | `AppCardElevation { none=0, xs=1, sm=2, md=4, lg=8 }` | `({required Widget child, VoidCallback? onTap, AppCardElevation elevation = .sm, EdgeInsetsGeometry? padding, BorderRadius? radius, Color? color})` |
| `AppListTile` | title / subtitle / leading / trailing | `({required String title, String? subtitle, Widget? leading, Widget? trailing, VoidCallback? onTap, VoidCallback? onLongPress, bool isThreeLine = false, EdgeInsetsGeometry? padding})` |
| `MemberCard` (compound) | wraps `MembersEntity` | `({required MembersEntity member, VoidCallback? onTap, String? roleLabel, Color? roleColor, bool showEmail = true, bool isOnline = false})` |
| `MeetingCard` (compound) | wraps `MeetingsEntity`; formats ISO 8601 via `DateFormat("dd MMM yyyy • HH:mm", "pt_BR")` | `({required MeetingsEntity meeting, VoidCallback? onTap, int? totalPresences, int? confirmedPresences, bool showDescription = false})` |
| `BlockCard` (compound) | wraps `CarnivalBlocksEntity`; uses `CachedNetworkImage` (guard with `isValidImageUrl`) | `({required CarnivalBlocksEntity block, VoidCallback? onTap, int? memberCount, List<String>? tags})` |

## Inputs (`lib/ui/core/widgets/inputs/`)

| Widget | Notes | Constructor |
|---|---|---|
| `AppTextField` | NO `readOnly` + `onTap` params yet — see living-notes follow-up | `({String? label, String? hint, String? helperText, String? errorText, IconData? prefixIcon, Widget? suffixIcon, bool obscureText = false, TextInputType? keyboardType, TextInputAction? textInputAction, TextEditingController? controller, ValueChanged<String>? onChanged, ValueChanged<String>? onSubmitted, FormFieldValidator<String>? validator, bool isMultiline = false, bool isEnabled = true, int? maxLines, bool autofocus = false, List<TextInputFormatter>? inputFormatters})` |
| `AppDropdown<T>` | `AppDropdownItem<T>({required T value, required String label, Widget? icon})` | `AppDropdown<T>({String? label, T? value, required List<AppDropdownItem<T>> items, ValueChanged<T?>? onChanged, String? hint, String? errorText, bool isEnabled = true})` |
| `AppSearchField` | `StatefulWidget` (only stateful primitive) | `({String? hint, ValueChanged<String>? onChanged, ValueChanged<String>? onSubmitted, TextEditingController? controller, bool autofocus = false})` |

## Feedback (`lib/ui/core/widgets/feedback/`)

| Widget | API style |
|---|---|
| `AppSnackbar` | Static helpers only: `success` / `error` / `warning` / `info` — `({BuildContext context, required String message, String? actionLabel, VoidCallback? onAction})` |
| `AppDialog` | Static helpers only: `confirm(...) → Future<bool?>` (supports `isDestructive: true`) and `alert(...) → Future<void>` |
| `AppLoadingIndicator` | `AppLoadingIndicatorVariant { circular, pulse }` · `({double size = 24, Color? color, AppLoadingIndicatorVariant variant = .circular, double strokeWidth = 3})` |

## Display (`lib/ui/core/widgets/display/`)

| Widget | Variants / notes | Constructor |
|---|---|---|
| `AppAvatar` | `AvatarSize { xs=24, sm=32, md=48, lg=64, xl=96 }` · `AvatarShape { circle, square, roundedSquare }` · `CachedNetworkImage` + initials fallback (6-color palette) — **guard URL with `isValidImageUrl`** | `({String? imageUrl, String? initials, double? size, AvatarSize? avatarSize, AvatarShape shape = .circle, VoidCallback? onTap})` |
| `AppChip` | `ChipVariant { filled, outlined, soft }` + factories: `presencePresent`, `presenceAbsent`, `memberRole`, `meetingStatus` | `({required String label, Widget? avatar, VoidCallback? onDeleted, VoidCallback? onPressed, ChipVariant variant = .filled, Color? color})` |
| `AppBadge` | `BadgeSize { sm, md }` | `({required String label, Color? color, BadgeSize size = .md, Widget? child})` |
| `AppSectionHeader` | title + optional action | `({required String title, String? subtitle, Widget? action, Widget? leading, EdgeInsetsGeometry? padding})` |
| `PresenceChip` (compound) | `PresenceVariant { present, absent, pending }` + factories `.present() / .absent() / .pending()` | `({PresenceVariant variant, required String label, bool showIcon = true})` |

## State (`lib/ui/core/widgets/state/`)

| Widget | Use | Constructor |
|---|---|---|
| `AppLoading` | Full-screen loading; falls back to static icon when `MediaQuery.disableAnimationsOf(context)` is true | `({String? message, double size = 40})` |
| `AppError` | Full-screen error + retry | `({String? title, String? message, IconData? icon, VoidCallback? onRetry, String? retryLabel})` |
| `AppEmpty` | Full-screen empty + optional CTA | `({String? title, String? message, IconData? icon, String? actionLabel, VoidCallback? onAction})` |

## Navigation (`lib/ui/core/widgets/navigation/`)

| Widget | Notes | Constructor |
|---|---|---|
| `AppAppBar` | `implements PreferredSizeWidget` | `({required String title, Widget? leading, List<Widget>? actions, bool centerTitle = false, Color? backgroundColor, Color? foregroundColor, double? elevation = 0, bool showBackButton = true, PreferredSizeWidget? bottom})` |
| `AppBottomNav` | Material 3 `NavigationBar`; max 5 items (assertion). Top-level `AppBottomNavItem` helper | `AppBottomNavItem({required IconData icon, IconData? activeIcon, required String label, String? tooltip})` |
| `AppShell` | Wraps `StatefulNavigationShell` for `StatefulShellRoute.indexedStack` | `AppShell({required StatefulNavigationShell shell, required List<AppBottomNavItem> items, String? title})` |

---

## Universal Convention (apply to all primitives)

1. `MediaQuery.disableAnimationsOf(context)` check before any animation
2. Hover/press: opacity 0.85–0.9 (NEVER scale on parent-shifting elements)
3. All colors/spacings/radii via tokens — zero hardcoded values (see `token-discipline.md`)
4. Double quotes on string literals; snake_case file names; PascalCase class names
5. `super.key` on constructors (`use_key_in_widget_constructors` lint)
6. No emojis as icons — `Material Symbols Rounded` only

---

## Reference

- `lookup/token-discipline.md` — color/spacing/font rules
- `concepts/image-url-validation.md` — required for `AppAvatar` + `BlockCard`
- `examples/theme-cubit-pattern.md` — `main_app.dart` theme wire
- `examples/widget-pattern.md` — screen-level usage
- `.tmp/.archive/2026-07-08/sessions/2026-07-03-design-system/HANDOFF.md` §6 — original API table (561 lines)
- `design-system/bloco-na-rua/MASTER.md` — style + color palette source