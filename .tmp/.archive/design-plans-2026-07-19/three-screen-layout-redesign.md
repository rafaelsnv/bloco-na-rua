---
project: bloco-na-rua
feature: three-screen-layout-redesign
created: 2026-07-17
updated: 2026-07-17
status: in_progress
current_stage: layout
---

# Design Plan: Three-Screen Layout Redesign

## User Requirements

Propose improved layouts for three Flutter screens, reusing the existing design
system tokens and widgets. No new components.

Screens in scope:

1. `lib/ui/carnivalBlock/blockDetails/widgets/block_details_screen.dart` (1017 lines)
2. `lib/ui/profile/widgets/profile_screen.dart` (237 lines)
3. `lib/ui/meetings/meetingDetails/widgets/meeting_details_screen.dart` (495 lines)

## Design Goals

- Reduce visual nesting — no AppCard inside AppCard inside AppCard.
- Standardize section/card patterns across the app.
- Meet accessibility touch-target minimums (44-48dp).
- Improve information density without sacrificing scannability.
- Use only existing widgets: `AppCard`, `AppListTile`, `AppSectionHeader`,
  `AppAvatar`, `AppChip`, `AppButton`, `AppFAB`, `AppIconButton`, `AppBadge`,
  `PresenceChip`, plus standard Flutter `Row`/`Column`/`Divider`.

## Stage 1: Layout Design

### Status

- [x] Layout planned
- [x] Prose + widget tree sketches delivered
- [ ] User approved

### Output

Inline in chat response (format requested by user).
