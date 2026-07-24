<!-- Context: project-intelligence/lookup/ui-organization | Priority: medium | Version: 3.1 | Updated: 2026-07-02 -->

# UI Organization — BlocoNaRua

**Quick reference**: Actual folder structure for `lib/ui/`.

## Top-Level Layout

```
lib/ui/
├── core/                          # Shared UI primitives
│   ├── colors/                    # App color tokens
│   │   ├── app_colors.dart
│   │   └── role_colors.dart
│   ├── theme/                     # Theme split (light + dark + base)
│   │   ├── bloco_na_rua_theme.dart
│   │   ├── dark_theme.dart
│   │   └── light_theme.dart
│   └── widgets/                   # Shared widgets (12 files)
│       ├── avatar_member.dart
│       ├── badge_widget.dart
│       ├── card_button.dart
│       ├── chip_date.dart
│       ├── copy_code_card.dart
│       ├── empty_state_widget.dart
│       ├── error_snackbar.dart
│       ├── error_state_widget.dart
│       ├── offline_banner.dart
│       ├── profile_button.dart
│       ├── section_header.dart
│       └── server_error_card.dart
├── auth/                          # Login, sign-up, logout, AuthCubit
│   ├── cubit/
│   ├── login/widgets/
│   ├── signUp/widgets/
│   └── logout/
├── carnivalBlock/                 # All block-related screens
│   ├── addMember/{cubit, widgets}/
│   ├── blockDetails/{cubit, widgets}/
│   ├── createBlock/{cubit, widgets}/
│   ├── editBlock/{cubit, widgets}/
│   └── joinBlock/{cubit, widgets}/
├── home/
│   ├── cubit/{home_cubit, home_state}
│   └── widgets/home_screen.dart
├── meeting_presences/{cubit, widgets}/
├── meetings/
│   ├── createMeeting/{cubit, widgets}/
│   ├── editMeeting/{cubit, widgets}/
│   ├── meetingDetails/{cubit, widgets}/
│   └── userMeetings/{cubit, widgets}/
├── members/{cubit, widgets}/
├── profile/{cubit, widgets}/
├── settings/{cubit, widgets}/
├── error/widgets/error_screen.dart
└── not_found/widgets/not_found_screen.dart
```

## Per-Feature Convention

```
lib/ui/{feature}/
├── cubit/
│   ├── {feature}_cubit.dart       # Cubit class
│   └── {feature}_state.dart       # State (Equatable + enum)
└── widgets/
    └── {feature}_screen.dart      # Screen with BlocBuilder
```

> **See:** `lookup/cubits.md` for the authoritative list of cubit files, state file locations, and which feature owns which cubit.

If the feature has sub-actions (e.g., `carnivalBlock` → `addMember`), nest them:

```
lib/ui/{parent_feature}/{sub_action}/
├── cubit/{sub_action}_cubit.dart
├── cubit/{sub_action}_state.dart
└── widgets/{sub_action}_screen.dart
```

## Naming

- **Folders**: camelCase (e.g., `carnivalBlock`, `meetingPresences`)
- **Files**: snake_case (e.g., `home_cubit.dart`, `block_details_screen.dart`)
- See `technical-naming.md` for the full set

## Where to Add a New Widget

| Reusable across features? | Location |
|---------------------------|----------|
| Yes (shared)              | `lib/ui/core/widgets/` |
| No (feature-specific)     | `lib/ui/{feature}/widgets/` |
| Sub-action of feature     | `lib/ui/{parent}/{sub}/widgets/` |

## Related

- `concepts/architecture.md` — directory tree
- `examples/widget-pattern.md` — screen template
- `lookup/cubits.md` — per-cubit state file locations
