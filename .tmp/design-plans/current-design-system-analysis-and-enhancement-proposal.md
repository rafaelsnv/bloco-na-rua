---
project: bloco-na-rua
feature: current-design-system-analysis-and-enhancement-proposal
created: 2026-07-20T18:06:00-03:00
updated: 2026-07-20T18:35:00-03:00
status: review_requested
current_stage: analysis_and_proposal
---

# Design Plan: Current Design System Analysis and Enhancement Proposal

## User Requirements

Analyze the Flutter repository's `lib/` architecture and current design system, including theme configuration, colors, typography, spacing, component styles, and dark/light mode support. Propose an enhanced accessible design system with a modern palette, consistent type scale, unified spacing, component specifications, accessibility considerations, and implementation recommendations.

## Context Loaded

- Project architecture: `.opencode/context/project-intelligence/concepts/architecture.md`
- UI organization: `.opencode/context/project-intelligence/lookup/ui-organization.md`
- Token rules: `.opencode/context/project-intelligence/lookup/token-discipline.md`
- Widget APIs: `.opencode/context/project-intelligence/lookup/widgets-api.md`
- Design color and typography references: `.opencode/context/projects/bloco-na-rua/design/lookup/`
- Flutter Material 3 documentation queried through Context7.
- `ui-ux-pro-max` design-system search: vibrant/block-based, playful indigo/violet with warm orange CTA, Fredoka/Nunito recommendation, 150–300ms motion, WCAG contrast checks.

## Stage 1: Repository and Current-System Analysis

### Status

- [x] `lib/` architecture inspected
- [x] Theme and UI files inspected
- [x] Current tokens and component patterns documented
- [ ] User approved findings

### Findings Summary

- `lib/main.dart` bootstraps dotenv, Supabase, providers, and `MainApp`.
- `lib/config/dependencies.dart` is the Provider DI composition root.
- `lib/core/` contains cross-cutting error/entity utilities.
- `lib/data/` and `lib/domain/` implement the Clean Architecture layers.
- `lib/routing/` owns GoRouter and the four-branch shell.
- `lib/ui/` is feature-first; shared design primitives live under `lib/ui/core/`.
- Theme source of truth is `lib/ui/core/theme/`; token source of truth is `lib/ui/core/tokens/`.
- The app uses Material 3 and persisted `ThemeMode.system/light/dark` via `ThemeCubit` and SharedPreferences.
- Current palette is named Carnaval Sunset: violet primary, rose secondary, orange accent, teal tertiary, stone/violet surfaces.
- Current code uses Sora + DM Sans. Project context and ui-ux-pro-max recommend Fredoka + Nunito; this is a documentation/code mismatch to resolve.
- Current contrast risks include white text on secondary, accent, tertiary, warning, info, and success fills; dark accent and container pairs; and `AppColors.textSecondary` used directly inside dark-mode cards.
- Current component-level drift includes incomplete dark surface roles, 36dp icon-button visual/touch behavior, 36dp small buttons, duplicated hardcoded motion/radius values, and inconsistent app-bar title styles.

## Stage 2: Enhanced Design System Proposal

### Status

- [x] Color palette and contrast strategy defined
- [x] Typography scale defined
- [x] Spacing and component tokens defined
- [x] Accessibility and mode strategy defined
- [ ] User approved proposal

### Direction

Retain the carnival identity, but make violet, berry, deep orange, and teal all safe as semantic foreground/background pairs. Use explicit Material 3 light/dark roles rather than raw color + white assumptions. Prefer Fredoka for display/headline and Nunito for body/UI to align the project design references and the ui-ux-pro-max recommendation; keep Sora/DM Sans as a low-risk fallback during migration if visual continuity is preferred.

### Proposed Core Colors

- Primary light/dark: `#5B21B6` / `#C4B5FD`; on-colors `#FFFFFF` / `#2E1065`.
- Secondary light/dark: `#B4235A` / `#FFB1C8`; on-colors `#FFFFFF` / `#5A0B2E`.
- CTA accent light/dark: `#9A3412` / `#FFB59D`; on-colors `#FFFFFF` / `#5A1A00`.
- Tertiary light/dark: `#006B5E` / `#6DDBC8`; on-colors `#FFFFFF` / `#00372F`.
- Success light/dark: `#146C43` / `#79DFA9`; on-colors `#FFFFFF` / `#00391F`.
- Warning light/dark: `#8A4B08` / `#FFB95C`; on-colors `#FFFFFF` / `#4A2800`.
- Error light/dark: `#B3261E` / `#FFB4AB`; on-colors `#FFFFFF` / `#690005`.
- Info light/dark: `#0B5CAD` / `#A7C8FF`; on-colors `#FFFFFF` / `#00315D`.
- Light surfaces: background `#FFFBFE`, surface `#FFFFFF`, surface variant `#F5EFF7`, outline `#766E78`, outline variant `#C9C0CA`, on-surface `#1D1B20`, on-surface-variant `#5F5663`.
- Dark surfaces: background `#151018`, surface `#1D1920`, surface variant `#4A444D`, surface containers `#211C24` through `#3B333D`, outline `#AAA2AB`, outline variant `#756E78`, on-surface `#F5EFF6`, on-surface-variant `#D0C8D2`.

Key proposed contrast ratios: light primary/white `8.98:1`, secondary/white `6.31:1`, accent/white `7.31:1`, tertiary/white `6.43:1`, warning/white `6.79:1`, text/on-background `16.65:1`, secondary text/on-background `6.83:1`, outline/on-surface `4.92:1`. Dark brand and semantic pairs are between `7.7:1` and `8.3:1` in the proposed set.

### Proposed Type Scale

- Fredoka display: 48/56 w700, 36/44 w600, 30/38 w600.
- Fredoka headlines: 26/34 w600, 22/30 w600, 20/28 w600.
- Nunito titles: 20/28 w700, 16/24 w700, 14/20 w700.
- Nunito body: 16/24 w400, 14/20 w400, 12/16 w400.
- Nunito labels/buttons: 14/20 and 12/16, w600–700; button large 16/24 w700.
- Use text-theme roles instead of ad-hoc `copyWith(fontWeight: ...)` wherever possible.

### Proposed Geometry, Motion, and Components

- Spacing: 4dp base with `0, 2, 4, 8, 12, 16, 20, 24, 32, 40, 48, 64`.
- Page gutters: 16dp compact, 24dp medium, 32dp expanded; use `LayoutBuilder` and a max content width for larger windows.
- Radii: 0, 4, 8, 12, 16, 24, full. Buttons 12, cards 16, inputs 12, sheets 24.
- Elevation: 0, 1, 2, 4; reserve 6–8 for FABs/dialogs.
- Motion: fast 150ms, standard 200ms, emphasized 300ms; respect `MediaQuery.disableAnimationsOf(context)` for speed dial and route transitions.
- Buttons: primary, secondary, tonal, ghost, destructive; all visual variants provide a 48dp minimum touch target.
- Cards: 0–2dp elevation, 1dp outline, 16dp radius, no nested elevated cards.
- Inputs: 48–56dp minimum height, 12dp radius, explicit label/helper/error styles, 2dp focus ring.
- Chips: 32dp minimum height; status colors use precomputed container/on-container pairs and icons, never arbitrary alpha over a text color.
- Navigation: Material 3 NavigationBar with visible selected indicator, always-visible labels, and mode-aware colors.
- Feedback: semantic snackbar/dialog colors use their `on*` tokens; state widgets expose announcements and retry actions.

## Stage 3: Implementation Recommendations

### Status

- [x] Migration approach documented
- [x] Risk and validation checklist documented
- [ ] User approved implementation scope

1. Update only `app_colors.dart`, `app_color_schemes.dart`, `app_text_themes.dart`, `app_typography.dart`, `app_spacing.dart`, and `app_radius.dart` first.
2. Populate every light and dark Material 3 surface-container role explicitly.
3. Fix component contrast and mode-awareness: `AppButton.accent`, `AppSnackbar`, `PresenceChip`, `AppChip`, `AppAvatar` initials, `MeetingCard` secondary text, and onboarding dots.
4. Normalize app-bar title sizing and remove one-off font-weight overrides.
5. Raise small button/icon controls to 48dp touch targets while keeping compact visual content.
6. Replace hardcoded screen/widget durations and curves with `AppDurations` and `AppCurves`; add reduced-motion handling to route and speed-dial animations.
7. Add accessibility tests for contrast-sensitive widgets, semantics, focus, text scaling, and 48dp targets. Add light/dark widget goldens after token migration.
8. Use `LayoutBuilder`/constraints for 375, 768, 1024, and future 1440dp validation; the project remains mobile-first.
9. Localize remaining screen/component strings through the existing pt-BR/en l10n system.

## Stage 4: Implementation

Not requested. No application code was modified; this file is the only artifact created for the report workflow.
