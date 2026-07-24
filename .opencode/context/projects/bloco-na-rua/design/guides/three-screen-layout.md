# Guide: Three-Screen Layout Redesign

**What**: Improved layouts for 3 Flutter screens using existing design tokens/widgets.

**Status**: ⚠️ In progress — awaiting user approval of layout proposal.

---

## Screens in Scope

| Screen | File | Lines | Focus |
|--------|------|-------|-------|
| Block Details | `blockDetails/widgets/block_details_screen.dart` | 1017 | Reduce nesting |
| Profile | `profile/widgets/profile_screen.dart` | 237 | Density + touch targets |
| Meeting Details | `meetingDetails/widgets/meeting_details_screen.dart` | 495 | Scannability |

---

## Design Goals

- No AppCard inside AppCard
- Standardize section/card patterns
- Touch targets ≥44-48dp
- Improve density without sacrificing scannability
- Use only existing widgets: `AppCard`, `AppListTile`, `AppSectionHeader`, `AppAvatar`, `AppChip`, `AppButton`, `AppFAB`, `AppIconButton`, `AppBadge`, `PresenceChip`

**Reference**: `.tmp/design-plans/three-screen-layout-redesign.md`
