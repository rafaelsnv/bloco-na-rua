# Design System Plan: Bloco na Rua

> **Status:** Draft for Review
> **Created:** 2026-07-03
> **Project:** Bloco na Rua — Brazilian Street Carnival Block Management App
> **Stack:** Flutter 3.8.1 | flutter_bloc | go_router | Clean Architecture

---

## Executive Summary

This document defines a complete design system for "Bloco na Rua" — discarding the existing Material 3/Figma tokens approach in favor of a **Vibrant & Block-based** style that reflects the energy and community spirit of Brazilian carnival blocks.

**Design System Output (from ui-ux-pro-max):**
- **Pattern:** Community/Forum Landing — conversion-focused with member showcases
- **Style:** Vibrant & Block-based — bold, energetic, playful, geometric shapes
- **Typography:** Fredoka (headings) + Nunito (body) — playful, friendly, warm
- **Primary Colors:** Indigo #4F46E5 + Orange CTA #F97316

**Persisted Files:**
- `design-system/bloco-na-rua/MASTER.md` — Global Source of Truth

---

## 1. Design System Foundation

### 1.1 Style Direction

**Chosen Style:** Vibrant & Block-based

**Justification (from ui-ux-pro-max):**
- Perfect for social/community apps with youth/consumer focus
- High color contrast creates energy and celebration
- Bold geometric shapes echo carnival aesthetics
- Block layout (48px+ gaps) creates breathing room and visual hierarchy
- "Playful" mood matches Brazilian carnival spirit

**Cultural Adaptation:**
Brazilian carnival blocks are:
- Community-driven celebrations
- Energetic but organized
- Colorful and expressive
- Welcoming to diverse participants

The design should feel **celebratory without being chaotic**, **energetic but trustworthy**.

**Anti-Patterns to Avoid:**
- ❌ Heavy skeuomorphism
- ❌ Accessibility ignored (WCAG must be met)
- ❌ Emojis as icons
- ❌ Layout-shifting animations

---

### 1.2 Color Palette

#### Primary Colors

| Role | Hex | OKLCH | Usage |
|------|-----|-------|-------|
| Primary | `#4F46E5` | oklch(0.45 0.20 270) | Main brand color, headers, primary actions |
| Primary Light | `#818CF8` | oklch(0.60 0.18 270) | Secondary elements, hover states |
| Primary Dark | `#3730A3` | oklch(0.35 0.22 270) | Pressed states, emphasis |

#### Accent/CTA Colors

| Role | Hex | OKLCH | Usage |
|------|-----|-------|-------|
| CTA/Accent | `#F97316` | oklch(0.65 0.20 50) | Call-to-action buttons, FAB, key actions |
| CTA Light | `#FB923C` | oklch(0.70 0.18 50) | Hover states for CTA |
| CTA Dark | `#EA580C` | oklch(0.55 0.22 50) | Pressed states for CTA |

#### Semantic Colors

| Role | Hex | Usage |
|------|-----|-------|
| Success | `#10B981` | Confirmations, positive feedback |
| Warning | `#F59E0B` | Warnings, attention needed |
| Error | `#EF4444` | Errors, destructive actions |
| Info | `#3B82F6` | Informational messages |

#### Surface Colors

| Role | Light Mode | Dark Mode | Usage |
|------|------------|-----------|-------|
| Background | `#EEF2FF` | `#0F172A` | Page backgrounds |
| Surface | `#FFFFFF` | `#1E293B` | Cards, sheets |
| Surface Variant | `#E0E7FF` | `#334155` | Subtle backgrounds |
| Border | `#E2E8F0` | `#334155` | Dividers, outlines |

#### Text Colors

| Role | Light Mode | Dark Mode | Usage |
|------|------------|-----------|-------|
| On Primary | `#FFFFFF` | `#FFFFFF` | Text on primary color |
| On Background | `#1E1B4B` | `#F1F5F9` | Primary text |
| On Surface | `#1E293B` | `#F1F5F9` | Text on cards |
| Muted | `#64748B` | `#94A3B8` | Secondary text |
| Disabled | `#94A3B8` | `#64748B` | Disabled state text |

**Color Contrast Requirements:**
- All text combinations must meet WCAG 4.5:1 (body) and 3:1 (large text)
- Primary on white: 5.2:1 ✅
- CTA on white: 3.6:1 ✅
- Muted text on background: 4.8:1 ✅

---

### 1.3 Typography Scale

**Font Families:**
- **Headings:** Fredoka (Google Fonts) — playful, rounded, friendly
- **Body:** Nunito (Google Fonts) — clean, readable, warm

**Type Scale (based on 16px base):**

| Style | Font | Weight | Size | Line Height | Letter Spacing | Usage |
|-------|------|--------|------|-------------|----------------|-------|
| Display Large | Fredoka | 700 | 57px | 64px | -0.25px | Hero text, splash |
| Display Medium | Fredoka | 600 | 45px | 52px | 0px | Major headings |
| Display Small | Fredoka | 600 | 36px | 44px | 0px | Section titles |
| Headline Large | Fredoka | 600 | 32px | 40px | 0px | Page titles |
| Headline Medium | Fredoka | 500 | 28px | 36px | 0px | Card titles |
| Headline Small | Fredoka | 500 | 24px | 32px | 0px | Subsection titles |
| Title Large | Nunito | 600 | 22px | 28px | 0px | List item titles |
| Title Medium | Nunito | 600 | 16px | 24px | 0.15px | Button text, labels |
| Title Small | Nunito | 500 | 14px | 20px | 0.1px | Small titles |
| Body Large | Nunito | 400 | 16px | 24px | 0.5px | Primary body text |
| Body Medium | Nunito | 400 | 14px | 20px | 0.25px | Secondary body |
| Body Small | Nunito | 400 | 12px | 16px | 0.4px | Captions, hints |
| Label Large | Nunito | 500 | 14px | 20px | 0.1px | Form labels |
| Label Medium | Nunito | 500 | 12px | 16px | 0.5px | Chips, badges |
| Label Small | Nunito | 500 | 11px | 16px | 0.5px | Small badges |

**Portuguese-Specific Considerations:**
- Nunito's rounded forms are excellent for Brazilian Portuguese diacritics (ç, ã, ô, etc.)
- Fredoka's playfulness suits Brazilian Portuguese's expressive nature
- Both fonts support extended Latin character set

---

### 1.4 Spacing Scale

**Base Unit:** 4px

| Token | Value | px | Usage |
|-------|-------|----|----|
| `space_4xs` | 0.5px | 2px | Hairline gaps |
| `space_3xs` | 1px | 4px | Tight icon gaps |
| `space_2xs` | 2px | 8px | Icon-to-text, inline spacing |
| `space_xs` | 3px | 12px | Chip padding, tight gaps |
| `space_sm` | 4px | 16px | Standard padding, form fields |
| `space_md` | 6px | 24px | Card padding, section gaps |
| `space_lg` | 8px | 32px | Large gaps, section margins |
| `space_xl` | 12px | 48px | Hero padding, major sections |
| `space_2xl` | 16px | 64px | Page margins |
| `space_3xl` | 20px | 80px | Splash/empty state padding |

**Layout Spacing Patterns:**
- Page horizontal padding: 16px (mobile), 24px (tablet), 32px (desktop)
- Card internal padding: 16px
- Section vertical spacing: 24px (list), 32px (between sections)
- List item vertical padding: 12px

---

### 1.5 Radius Scale

**Border Radius System:**

| Token | Value | Usage |
|-------|-------|-------|
| `radius_none` | 0px | Full-bleed elements |
| `radius_xs` | 4px | Small badges, tags |
| `radius_sm` | 8px | Buttons, inputs, small cards |
| `radius_md` | 12px | Cards, sheets, modals |
| `radius_lg` | 16px | Large cards, featured elements |
| `radius_xl` | 24px | Bottom sheets, major containers |
| `radius_full` | 9999px | Pills, avatars, FABs |

**Component Radius Assignments:**
- Buttons: 8px (`radius_sm`)
- Cards: 12px (`radius_md`)
- Inputs: 8px (`radius_sm`)
- FAB: 16px (`radius_lg`) or 28px (extended)
- Chips: 16px (`radius_lg`) — pill shape
- Avatars: 9999px (`radius_full`)
- Modals: 16px (`radius_lg`)
- Bottom Sheet: 24px top only (`radius_xl`)

---

### 1.6 Elevation / Shadow System

**Shadow Depths (Light Mode):**

| Token | Value | Usage |
|-------|-------|-------|
| `elevation_none` | none | Flat elements |
| `elevation_xs` | `0 1px 2px rgba(0,0,0,0.05)` | Subtle lift, hover cards |
| `elevation_sm` | `0 2px 4px rgba(0,0,0,0.08)` | Cards at rest |
| `elevation_md` | `0 4px 8px rgba(0,0,0,0.10)` | Elevated cards, dropdowns |
| `elevation_lg` | `0 8px 16px rgba(0,0,0,0.12)` | Modals, FABs |
| `elevation_xl` | `0 16px 32px rgba(0,0,0,0.16)` | Overlay elements |

**Dark Mode Shadows:**
- Use transparent variants with `opacity` rather than black
- Example: `0 4px 8px rgba(0,0,0,0.3)`

**Usage Rules:**
- Cards: `elevation_sm` at rest, `elevation_md` on hover
- FAB: `elevation_lg`
- Modals: `elevation_xl`
- Bottom nav: `elevation_md` (with top border, no shadow)

---

### 1.7 Motion & Animation Principles

**Core Principles:**
1. **Purposeful:** Every animation communicates state change
2. **Quick:** 150-300ms for micro-interactions, 300-400ms for page transitions
3. **Eased:** Use `Curves.easeOutCubic` for entering, `Curves.easeInCubic` for exiting
4. **Reduced Motion:** Always respect `MediaQuery.disableAnimations`

**Animation Tokens:**

| Token | Duration | Curve | Usage |
|-------|----------|-------|-------|
| `duration_instant` | 0ms | — | State toggles |
| `duration_fast` | 150ms | easeOutCubic | Hover states, micro-interactions |
| `duration_normal` | 200ms | easeOutCubic | Standard transitions |
| `duration_slow` | 300ms | easeOutCubic | Page transitions, modals |
| `duration_slower` | 400ms | easeOutCubic | Complex animations |

**Animation Patterns:**

| Animation | Trigger | Duration | Effect |
|-----------|---------|----------|--------|
| Button press | onTapDown | 100ms | Scale to 0.97 |
| Button release | onTapUp/onTapCancel | 200ms | Scale to 1.0 |
| Card hover | onHover | 200ms | Elevation +2, translateY(-2px) |
| Page transition | Navigation | 300ms | Slide + fade |
| Modal appear | onAppear | 300ms | Slide up + fade |
| Modal dismiss | onDismiss | 200ms | Slide down + fade |
| List item appear | onAppear | 200ms staggered | Fade in + slide up |
| FAB press | onTap | 150ms | Scale to 0.95 |
| Snackbar | onAppear | 250ms | Slide up + fade |

**Anti-Patterns:**
- ❌ Animating width/height (use transform: scale)
- ❌ Infinite looping animations (except loading spinners)
- ❌ Linear easing (feels robotic)
- ❌ Multiple simultaneous animations (max 2 per view)

---

## 2. Flutter Implementation Architecture

### 2.1 Directory Structure

```
lib/
├── ui/
│   ├── core/                       # Shared UI primitives (design system)
│   │   ├── tokens/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_spacing.dart
│   │   │   ├── app_radius.dart
│   │   │   ├── app_duration.dart
│   │   │   └── app_typography.dart
│   │   │
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   ├── app_color_schemes.dart
│   │   │   └── app_text_themes.dart
│   │   │
│   │   └── widgets/                # App-prefixed reusable widgets
│   │       ├── buttons/
│   │       │   ├── app_button.dart
│   │       │   ├── app_icon_button.dart
│   │       │   └── app_fab.dart
│   │       ├── cards/
│   │       │   ├── app_card.dart
│   │       │   └── app_list_tile.dart
│   │       ├── inputs/
│   │       │   ├── app_text_field.dart
│   │       │   ├── app_dropdown.dart
│   │       │   └── app_search_field.dart
│   │       ├── navigation/
│   │       │   ├── app_bottom_nav.dart
│   │       │   ├── app_app_bar.dart
│   │       │   └── app_shell.dart   # StatefulShellRoute wrapper
│   │       ├── feedback/
│   │       │   ├── app_snackbar.dart
│   │       │   ├── app_dialog.dart
│   │       │   └── app_loading_indicator.dart
│   │       ├── display/
│   │       │   ├── app_avatar.dart
│   │       │   ├── app_chip.dart
│   │       │   ├── app_badge.dart
│   │       │   └── app_section_header.dart
│   │       └── state/
│   │           ├── app_loading.dart
│   │           ├── app_error.dart
│   │           └── app_empty.dart
│   │
│   ├── auth/                      # Feature: login, sign-up (custom forms)
│   │   ├── cubit/
│   │   │   ├── auth_cubit.dart
│   │   │   └── auth_state.dart
│   │   └── widgets/
│   │       ├── login_screen.dart
│   │       └── register_screen.dart
│   │
│   ├── home/
│   │   ├── cubit/
│   │   │   ├── home_cubit.dart
│   │   │   └── home_state.dart
│   │   └── widgets/
│   │       └── home_screen.dart
│   │
│   ├── carnivalBlock/              # camelCase per project convention
│   │   ├── blockList/{cubit, widgets}/
│   │   ├── blockDetails/{cubit, widgets}/
│   │   ├── createBlock/widgets/
│   │   ├── editBlock/{cubit, widgets}/
│   │   └── joinBlock/widgets/
│   │
│   ├── meetings/
│   │   ├── userMeetings/{cubit, widgets}/
│   │   ├── meetingDetails/{cubit, widgets}/
│   │   ├── createMeeting/{cubit, widgets}/
│   │   └── editMeeting/{cubit, widgets}/
│   │
│   ├── meetingPresences/           # camelCase
│   │   ├── cubit/
│   │   │   ├── meeting_presences_cubit.dart
│   │   │   └── meeting_presences_state.dart
│   │   └── widgets/
│   │       └── meeting_presences_screen.dart
│   │
│   ├── members/
│   │   ├── cubit/
│   │   │   ├── members_cubit.dart
│   │   │   └── members_state.dart
│   │   └── widgets/
│   │       └── members_screen.dart
│   │
│   ├── profile/
│   │   ├── cubit/
│   │   │   ├── profile_cubit.dart
│   │   │   └── profile_state.dart
│   │   └── widgets/
│   │       └── profile_screen.dart
│   │
│   ├── settings/
│   │   └── widgets/
│   │       └── settings_screen.dart
│   │
│   ├── error/widgets/error_screen.dart
│   └── not_found/widgets/not_found_screen.dart
│
├── routing/                        # Existing directory, only router.dart changes
│   ├── routes.dart
│   └── router.dart                 # Migrated to StatefulShellRoute
│
├── domain/                         # Existing - NO CHANGES
├── data/                           # Existing - NO CHANGES
├── config/dependencies.dart        # Existing - NO CHANGES
├── main.dart                       # Minimal changes
└── main_app.dart                   # Migrated to new theme
```

**Key Principles (aligned with project conventions):**
- **`lib/ui/core/`** is the SINGLE home for shared UI primitives (tokens, theme, widgets) — replaces existing `lib/ui/core/`
- **`lib/ui/{feature}/{cubit, widgets}/`** is the per-feature convention (NOT `features/presentation/pages/`)
- **Folders are camelCase** (`carnivalBlock`, `meetingPresences`) — NOT snake_case
- **Files are snake_case** (`login_screen.dart`, `home_cubit.dart`) — NOT kebab-case
- **Widgets prefixed with `App`** for design system primitives (`AppButton`, `AppTextField`)
- **Feature widgets have NO prefix** (e.g., `LoginScreen`, `MemberCard`)
- **No new `lib/ui/shared/`** — design system lives in `core/`

---

### 2.2 Theme Layer Design

#### ColorScheme (Light Mode)

```dart
ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF4F46E5),        // Primary indigo
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFE0E7FF),
  onPrimaryContainer: Color(0xFF1E1B4B),
  secondary: Color(0xFF818CF8),        // Primary light
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFE0E7FF),
  onSecondaryContainer: Color(0xFF1E1B4B),
  tertiary: Color(0xFFF97316),        // CTA orange
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFFFEDD5),
  onTertiaryContainer: Color(0xFF7C2D12),
  error: Color(0xFFEF4444),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFEE2E2),
  onErrorContainer: Color(0xFF991B1B),
  surface: Color(0xFFFFFFFF),
  onSurface: Color(0xFF1E293B),
  surfaceContainerHighest: Color(0xFFE2E8F0),
  onSurfaceVariant: Color(0xFF64748B),
  outline: Color(0xFFE2E8F0),
  outlineVariant: Color(0xFFCBD5E1),
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFF1E293B),
  onInverseSurface: Color(0xFFF1F5F9),
  inversePrimary: Color(0xFFA5B4FC),
);
```

#### ColorScheme (Dark Mode)

```dart
ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF818CF8),          // Primary light in dark mode
  onPrimary: Color(0xFF1E1B4B),
  primaryContainer: Color(0xFF3730A3),
  onPrimaryContainer: Color(0xFFE0E7FF),
  secondary: Color(0xFFA5B4FC),
  onSecondary: Color(0xFF1E1B4B),
  secondaryContainer: Color(0xFF4338CA),
  onSecondaryContainer: Color(0xFFE0E7FF),
  tertiary: Color(0xFFFB923C),         // CTA light in dark mode
  onTertiary: Color(0xFF7C2D12),
  tertiaryContainer: Color(0xFFC2410C),
  onTertiaryContainer: Color(0xFFFFEDD5),
  error: Color(0xFFF87171),
  onError: Color(0xFF7F1D1D),
  errorContainer: Color(0xFF991B1B),
  onErrorContainer: Color(0xFFFEE2E2),
  surface: Color(0xFF1E293B),
  onSurface: Color(0xFFF1F5F9),
  surfaceContainerHighest: Color(0xFF334155),
  onSurfaceVariant: Color(0xFF94A3B8),
  outline: Color(0xFF475569),
  outlineVariant: Color(0xFF334155),
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFFF1F5F9),
  onInverseSurface: Color(0xFF1E293B),
  inversePrimary: Color(0xFF4F46E5),
);
```

#### TextTheme

```dart
TextTheme textTheme = TextTheme(
  displayLarge: GoogleFonts.fredoka(
    fontSize: 57, fontWeight: FontWeight.w700,
    letterSpacing: -0.25, height: 64/57,
  ),
  displayMedium: GoogleFonts.fredoka(
    fontSize: 45, fontWeight: FontWeight.w600,
    letterSpacing: 0, height: 52/45,
  ),
  displaySmall: GoogleFonts.fredoka(
    fontSize: 36, fontWeight: FontWeight.w600,
    letterSpacing: 0, height: 44/36,
  ),
  headlineLarge: GoogleFonts.fredoka(
    fontSize: 32, fontWeight: FontWeight.w600,
    letterSpacing: 0, height: 40/32,
  ),
  headlineMedium: GoogleFonts.fredoka(
    fontSize: 28, fontWeight: FontWeight.w500,
    letterSpacing: 0, height: 36/28,
  ),
  headlineSmall: GoogleFonts.fredoka(
    fontSize: 24, fontWeight: FontWeight.w500,
    letterSpacing: 0, height: 32/24,
  ),
  titleLarge: GoogleFonts.nunito(
    fontSize: 22, fontWeight: FontWeight.w600,
    letterSpacing: 0, height: 28/22,
  ),
  titleMedium: GoogleFonts.nunito(
    fontSize: 16, fontWeight: FontWeight.w600,
    letterSpacing: 0.15, height: 24/16,
  ),
  titleSmall: GoogleFonts.nunito(
    fontSize: 14, fontWeight: FontWeight.w500,
    letterSpacing: 0.1, height: 20/14,
  ),
  bodyLarge: GoogleFonts.nunito(
    fontSize: 16, fontWeight: FontWeight.w400,
    letterSpacing: 0.5, height: 24/16,
  ),
  bodyMedium: GoogleFonts.nunito(
    fontSize: 14, fontWeight: FontWeight.w400,
    letterSpacing: 0.25, height: 20/14,
  ),
  bodySmall: GoogleFonts.nunito(
    fontSize: 12, fontWeight: FontWeight.w400,
    letterSpacing: 0.4, height: 16/12,
  ),
  labelLarge: GoogleFonts.nunito(
    fontSize: 14, fontWeight: FontWeight.w500,
    letterSpacing: 0.1, height: 20/14,
  ),
  labelMedium: GoogleFonts.nunito(
    fontSize: 12, fontWeight: FontWeight.w500,
    letterSpacing: 0.5, height: 16/12,
  ),
  labelSmall: GoogleFonts.nunito(
    fontSize: 11, fontWeight: FontWeight.w500,
    letterSpacing: 0.5, height: 16/11,
  ),
);
```

#### ThemeData Builder

```dart
ThemeData buildLightTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    textTheme: textTheme.apply(
      bodyColor: Color(0xFF1E293B),
      displayColor: Color(0xFF1E1B4B),
    ),
    scaffoldBackgroundColor: Color(0xFFEEF2FF),
    // Component themes...
  );
}
```

---

### 2.3 Design Tokens (Dart Constants)

#### colors.dart

```dart
import 'package:flutter/material.dart';

/// Primary Colors
static const Color primary = Color(0xFF4F46E5);
static const Color primaryLight = Color(0xFF818CF8);
static const Color primaryDark = Color(0xFF3730A3);

/// CTA / Accent Colors
static const Color cta = Color(0xFFF97316);
static const Color ctaLight = Color(0xFFFB923C);
static const Color ctaDark = Color(0xFFEA580C);

/// Semantic Colors
static const Color success = Color(0xFF10B981);
static const Color warning = Color(0xFFF59E0B);
static const Color error = Color(0xFFEF4444);
static const Color info = Color(0xFF3B82F6);

/// Surface Colors - Light
static const Color backgroundLight = Color(0xFFEEF2FF);
static const Color surfaceLight = Color(0xFFFFFFFF);
static const Color surfaceVariantLight = Color(0xFFE0E7FF);
static const Color borderLight = Color(0xFFE2E8F0);

/// Surface Colors - Dark
static const Color backgroundDark = Color(0xFF0F172A);
static const Color surfaceDark = Color(0xFF1E293B);
static const Color surfaceVariantDark = Color(0xFF334155);
static const Color borderDark = Color(0xFF334155);

/// Text Colors - Light
static const Color textPrimaryLight = Color(0xFF1E1B4B);
static const Color textSecondaryLight = Color(0xFF64748B);
static const Color textDisabledLight = Color(0xFF94A3B8);

/// Text Colors - Dark
static const Color textPrimaryDark = Color(0xFFF1F5F9);
static const Color textSecondaryDark = Color(0xFF94A3B8);
static const Color textDisabledDark = Color(0xFF64748B);
```

#### spacing.dart

```dart
/// Spacing tokens (4px base unit)
class Spacing {
  static const double space_4xs = 2.0;
  static const double space_3xs = 4.0;
  static const double space_2xs = 8.0;
  static const double space_xs = 12.0;
  static const double space_sm = 16.0;
  static const double space_md = 24.0;
  static const double space_lg = 32.0;
  static const double space_xl = 48.0;
  static const double space_2xl = 64.0;
  static const double space_3xl = 80.0;

  // Common combinations
  static const double pagePaddingMobile = 16.0;
  static const double pagePaddingTablet = 24.0;
  static const double pagePaddingDesktop = 32.0;
  static const double cardPadding = 16.0;
  static const double sectionGap = 24.0;
  static const double listItemVerticalPadding = 12.0;
}
```

#### radius.dart

```dart
class Radius {
  static const double none = 0.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double full = 9999.0;

  // BorderRadius presets
  static final BorderRadius radius_xs = BorderRadius.circular(xs);
  static final BorderRadius radius_sm = BorderRadius.circular(sm);
  static final BorderRadius radius_md = BorderRadius.circular(md);
  static final BorderRadius radius_lg = BorderRadius.circular(lg);
  static final BorderRadius radius_xl = BorderRadius.circular(xl);
  static final BorderRadius radius_full = BorderRadius.circular(full);

  // Specific component radii
  static final BorderRadius button = radius_sm;
  static final BorderRadius card = radius_md;
  static final BorderRadius input = radius_sm;
  static final BorderRadius fab = radius_lg;
  static final BorderRadius chip = radius_lg;
  static final BorderRadius avatar = radius_full;
  static final BorderRadius modal = radius_lg;
  static final BorderRadius bottomSheet = BorderRadius.only(
    topLeft: Radius.circular(xl),
    topRight: Radius.circular(xl),
  );
}
```

#### duration.dart

```dart
class DurationTokens {
  static const Duration instant = Duration.zero;
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 200);
  static const Duration slow = Duration(milliseconds: 300);
  static const Duration slower = Duration(milliseconds: 400);
}

class CurvesTokens {
  static const Curve standard = Curves.easeOutCubic;
  static const Curve entering = Curves.easeOutCubic;
  static const Curve exiting = Curves.easeInCubic;
  static const Curve bounce = Curves.elasticOut;
}
```

#### typography.dart

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TypographyTokens {
  static TextStyle get displayLarge => GoogleFonts.fredoka(
    fontSize: 57, fontWeight: FontWeight.w700,
    letterSpacing: -0.25, height: 64/57,
  );
  // ... other styles matching text theme
}
```

---

### 2.4 Light/Dark Mode Strategy

**Approach:** Automatic system detection with manual override option

1. **System Detection:** Use `MediaQuery.platformBrightnessOf(context)`
2. **Persistence:** Store user preference in SharedPreferences (Settings feature)
3. **Toggle Location:** Settings page with options: System / Light / Dark
4. **Implementation:** `ThemeMode.system`, `ThemeMode.light`, `ThemeMode.dark`

**Transition Animation:**
- On theme change: Cross-fade with 200ms duration
- Use `AnimatedTheme` widget wrapping MaterialApp

**What Changes in Dark Mode:**
| Element | Light Mode | Dark Mode |
|---------|------------|-----------|
| Background | `#EEF2FF` | `#0F172A` |
| Surface | `#FFFFFF` | `#1E293B` |
| Text Primary | `#1E1B4B` | `#F1F5F9` |
| Text Secondary | `#64748B` | `#94A3B8` |
| Border | `#E2E8F0` | `#334155` |
| Elevation | Black shadows | Black shadows (more opaque) |

---

### 2.5 Responsive/Adaptive Considerations

**Breakpoints:**

| Name | Width | Usage |
|------|-------|-------|
| Mobile | < 600px | Phone portrait |
| Tablet | 600-1024px | Tablet portrait, phone landscape |
| Desktop | > 1024px | Tablet landscape, desktop |

**Responsive Patterns:**

1. **Adaptive Padding:** `Spacing.pagePaddingMobile` / `pagePaddingTablet` / `pagePaddingDesktop`
2. **Adaptive Grid:** 1 column (mobile), 2 columns (tablet), 3-4 columns (desktop)
3. **Adaptive Navigation:** Bottom nav (mobile), Drawer or Rail (tablet), Drawer (desktop)
4. **Adaptive Typography:** Use `TextTheme` automatically scales, but may add `TextScaler` for extreme sizes

**Safe Area Handling:**
- Use `SafeArea` widget for all page content
- `MediaQuery.of(context).padding` for custom layouts
- Bottom nav: Add bottom padding to last list item

---

### 2.6 Accessibility

**WCAG 2.1 AA Compliance:**

1. **Color Contrast:**
   - Body text: 4.5:1 minimum
   - Large text (18pt+): 3:1 minimum
   - UI components: 3:1 minimum

2. **Touch Targets:**
   - Minimum 48x48dp for all interactive elements
   - 8dp minimum gap between adjacent targets

3. **Focus Indicators:**
   - Visible focus ring on all interactive elements
   - Use `FocusTraversalGroup` for keyboard navigation

4. **Reduced Motion:**
   ```dart
   final reduceMotion = MediaQuery.of(context).disableAnimations;
   if (reduceMotion) {
     // Use instant transitions
   }
   ```

5. **Semantic Markup:**
   - Use `Semantics` widget for custom widgets
   - Include `label`, `hint`, `value` where appropriate
   - Announce dynamic content with `AnnounceSemanticsEvent`

6. **Text Scaling:**
   - Support up to 200% text scaling
   - Use `TextTheme` (scales with system settings)
   - Avoid fixed heights for text containers

---

## 3. Reusable Component Inventory

### 3.1 Primitive Components

#### AppButton

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `variant` | `AppButtonVariant` (primary, secondary, tertiary, ghost) | primary | Visual style |
| `size` | `AppButtonSize` (sm, md, lg) | md | Size preset |
| `label` | `String` | required | Button text |
| `icon` | `Widget?` | null | Leading icon |
| `trailingIcon` | `Widget?` | null | Trailing icon |
| `onPressed` | `VoidCallback?` | null | Press handler |
| `isLoading` | `bool` | false | Loading state |
| `isDisabled` | `bool` | false | Disabled state |
| `isFullWidth` | `bool` | false | Expand to parent width |

**States:**
- Default: Normal appearance
- Hover: Slight opacity reduction (0.9), no layout shift
- Pressed: Scale to 0.97
- Disabled: 50% opacity, no interaction
- Loading: Replace label with `AppLoadingIndicator(size: 20)`

**Variants:**
- `primary`: CTA color background, white text
- `secondary`: Primary color outline, primary text
- `tertiary`: Surface color, primary text (for less emphasis)
- `ghost`: Transparent, primary text

**Usage Example:**
```dart
AppButton(
  label: 'Entrar',
  icon: Icon(Icons.login),
  onPressed: () => login(),
  isFullWidth: true,
)
```

---

#### AppIconButton

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `icon` | `IconData` | required | Material icon |
| `size` | `IconButtonSize` (sm: 36px, md: 44px, lg: 52px) | md | Button size |
| `color` | `Color?` | null | Icon color (inherits theme) |
| `onPressed` | `VoidCallback?` | null | Press handler |
| `tooltip` | `String?` | null | A11y tooltip |

**States:**
- Default, Hover (background highlight), Pressed (scale 0.95), Disabled (0.5 opacity)

---

#### AppFAB

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `icon` | `IconData` | required | FAB icon |
| `label` | `String?` | null | Extended FAB label (makes it "extended") |
| `onPressed` | `VoidCallback` | required | Press handler |
| `size` | `FABSize` (sm, md, lg) | md | Size preset |

**States:**
- Default: CTA color, elevation_lg
- Pressed: Scale 0.95, elevation_xl
- Extended: Show label with smooth width transition

---

#### AppCard

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `child` | `Widget` | required | Card content |
| `onTap` | `VoidCallback?` | null | Tap handler |
| `elevation` | `AppElevation` (none, xs, sm, md, lg) | sm | Shadow level |
| `padding` | `EdgeInsetsGeometry?` | `Spacing.cardPadding` | Content padding |
| `radius` | `RadiusTokens` | `Radius.radius_md` | Border radius |

**States:**
- Default: elevation_sm
- Hover: elevation_md, translateY(-2px) (if onTap provided)
- Pressed: scale 0.98

---

#### AppTextField

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `label` | `String` | required | Field label |
| `hint` | `String?` | null | Placeholder text |
| `helperText` | `String?` | null | Help text below field |
| `errorText` | `String?` | null | Error message |
| `prefixIcon` | `IconData?` | null | Leading icon |
| `suffixIcon` | `Widget?` | null | Trailing widget |
| `obscureText` | `bool` | false | Password toggle |
| `keyboardType` | `TextInputType?` | null | Keyboard type |
| `textInputAction` | `TextInputAction?` | null | Action button |
| `controller` | `TextEditingController?` | null | External controller |
| `onChanged` | `ValueChanged<String>?` | null | Change handler |
| `onSubmitted` | `ValueChanged<String>?` | null | Submit handler |
| `validator` | `FormFieldValidator<String>?` | null | Validation |
| `isMultiline` | `bool` | false | Multi-line input |
| `isEnabled` | `bool` | true | Disabled state |

**States:**
- Default: Border color outline
- Focused: Primary color border, subtle primary tint shadow
- Error: Error color border, error tint shadow
- Disabled: 50% opacity, no interaction

---

#### AppSearchField

A specialized `AppTextField` variant:
- `prefixIcon: Icons.search`
- `hint: "Pesquisar..."`
- Clear button appears when text is entered
- Debounced onChanged (300ms)

---

#### AppDropdown<T>

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `label` | `String` | required | Field label |
| `value` | `T?` | null | Selected value |
| `items` | `List<AppDropdownItem<T>>` | required | Options |
| `onChanged` | `ValueChanged<T?>?` | null | Selection handler |
| `hint` | `String?` | null | Placeholder |
| `errorText` | `String?` | null | Error message |

---

#### AppAppBar

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `title` | `String` | required | App bar title |
| `leading` | `Widget?` | null | Leading widget |
| `actions` | `List<Widget>?` | null | Trailing actions |
| `centerTitle` | `bool` | false | Center title |
| `elevation` | `double?` | null | Custom elevation |
| `backgroundColor` | `Color?` | null | Override background |

**Features:**
- Respects system UI overlay (safe area)
- Transparent option for hero images
- Collapsing option for scrollable content

---

#### AppBottomNav

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `items` | `List<AppBottomNavItem>` | required | Nav items |
| `currentIndex` | `int` | 0 | Selected index |
| `onTap` | `ValueChanged<int>` | required | Selection handler |

**AppBottomNavItem:**
- `icon: IconData`
- `activeIcon: IconData?` (optional different active icon)
- `label: String` (max 12 chars for truncation)

**Features:**
- 3-5 items max
- Unselected labels hidden on phones
- Safe area padding

---

#### AppAvatar

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `imageUrl` | `String?` | null | Image URL |
| `name` | `String?` | null | Initials fallback |
| `size` | `AvatarSize` (xs: 24, sm: 32, md: 48, lg: 64, xl: 96) | md | Avatar size |
| `shape` | `AvatarShape` (circle, square, roundedSquare) | circle | Shape |

**Initials Generation:**
- Take first letter of first and last name
- Uppercase
- If single name, take first 2 letters

**States:**
- Loading: Shimmer placeholder
- Error: Show initials fallback
- No image/no name: Show default icon

---

#### AppChip

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `label` | `String` | required | Chip text |
| `avatar` | `Widget?` | null | Leading avatar/icon |
| `onDeleted` | `VoidCallback?` | null | Deletable chip |
| `onPressed` | `VoidCallback?` | null | Selectable chip |
| `variant` | `ChipVariant` (filled, outlined, soft) | filled | Visual style |
| `color` | `Color?` | null | Custom color |

**Presets:**
- `presencePresent`: Success color
- `presenceAbsent`: Error color
- `memberRole`: Primary color
- `meetingStatus`: Tertiary color

---

#### AppBadge

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `label` | `String` | required | Badge text |
| `color` | `Color?` | null | Custom color |
| `size` | `BadgeSize` (sm, md) | md | Badge size |

---

#### AppSectionHeader

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `title` | `String` | required | Section title |
| `action` | `String?` | null | Action button text |
| `onAction` | `VoidCallback?` | null | Action handler |

---

#### AppSnackbar

**Usage:** `ScaffoldMessenger.of(context).showSnackBar()`

| Type | Description |
|------|-------------|
| `AppSnackBar.success(message)` | Green left border |
| `AppSnackBar.error(message)` | Red left border |
| `AppSnackBar.warning(message)` | Yellow left border |
| `AppSnackBar.info(message)` | Blue left border |

**Duration:** 4 seconds (success/info), 6 seconds (warning/error)
**Dismiss:** Swipe or tap

---

#### AppDialog

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `title` | `String` | required | Dialog title |
| `content` | `Widget?` | null | Dialog body |
| `actions` | `List<Widget>` | required | Action buttons |

**Presets:**
- `AppDialog.confirm(title, message, onConfirm)` — Cancel + Confirm
- `AppDialog.alert(title, message)` — Single OK button

---

#### AppBottomSheet

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `title` | `String?` | null | Sheet title |
| `child` | `Widget` | required | Sheet content |
| `showHandle` | `bool` | true | Drag handle indicator |

**Features:**
- Draggable with `DraggableScrollableSheet`
- Dismissible by swipe down
- Keyboard-aware (adjusts for keyboard)

---

#### AppLoadingIndicator

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `size` | `double` | 24 | Indicator size |
| `strokeWidth` | `double` | 2 | Line thickness |
| `color` | `Color?` | null | Override color |

**Variants:**
- `CircularProgressIndicator` (default)
- `AppLoadingIndicator.spinner()` (custom)
- `AppLoadingIndicator.pulse()` (scale animation)

---

### 3.2 Compound Components

#### MemberCard

```
┌─────────────────────────────────┐
│ [Avatar]  Maria Silva           │
│           @maria.santos        │
│           [Chip: Organizadora] │
│                     [→ Arrow]  │
└─────────────────────────────────┘
```

**Props:** member data, onTap navigation

---

#### MeetingCard

```
┌─────────────────────────────────┐
│ Reunião Ordinária               │
│ 📅 15 Jan 2025 • 🕒 19:00      │
│ 📍 Sede do Bloco                │
│ ┌────────┐ ┌────────┐           │
│ │ 12/15  │ │ Pres.  │           │
│ │ faltam │ │confirm │           │
│ └────────┘ └────────┘           │
│                     [→ Arrow]  │
└─────────────────────────────────┘
```

**Props:** meeting data, presence stats, onTap navigation

---

#### BlockCard

```
┌─────────────────────────────────┐
│ [Image]                         │
│                                 │
│ Bloco da Alegria                │
│ 🎭 45 membros • 📅 Desde 2020   │
│                                 │
│ [Tag: Ativo] [Tag: Carnaval]   │
└─────────────────────────────────┘
```

**Props:** block data, onTap navigation

---

#### PresenceChip

**Variants:**
- `presencePresent`: Success green, checkmark icon
- `presenceAbsent`: Error red, X icon
- `presencePending`: Warning yellow, clock icon

---

### 3.3 State Components

#### AppLoading

Full-screen centered loading state with optional message.

#### AppError

Full-screen error state with:
- Error icon
- Error message
- Retry button

#### AppEmpty

Full-screen empty state with:
- Illustration
- Empty state message
- Optional CTA button

---

### 3.4 Component Feature Mapping

| Feature | Components Used |
|---------|-----------------|
| **Auth** | AppTextField, AppButton, AppCard, AppDialog, AppLoading |
| **Home** | AppCard, AppSectionHeader, MemberCard, MeetingCard, BlockCard |
| **Carnival Block** | BlockCard, AppAppBar, AppBottomSheet, AppDialog |
| **Meetings** | MeetingCard, PresenceChip, AppFAB, AppBottomSheet, AppDialog |
| **Members** | MemberCard, AppAvatar, AppChip, AppSearchField |
| **Profile** | AppAvatar, AppTextField, AppButton, AppCard |
| **Settings** | AppListTile, AppSwitch, AppDropdown, AppDialog |
| **Navigation** | AppBottomNav, AppAppBar, AppDrawer |

---

## 4. Layout & Navigation Patterns

### 4.1 App Shell Pattern

**Structure:**
```
┌──────────────────────────────────────┐
│           AppBar (optional)          │
├──────────────────────────────────────┤
│                                      │
│                                      │
│          Content Area                │
│          (scrollable)                │
│                                      │
│                                      │
├──────────────────────────────────────┤
│         Bottom Navigation            │
│  (only on main authenticated pages)  │
└──────────────────────────────────────┘
```

**Rules:**
- Use `Scaffold` with `AppBar` and `BottomNavigationBar`
- Content should be in `SafeArea`
- `Body` should handle `SingleChildScrollView` or `ListView` automatically
- No persistent side navigation on mobile

### 4.2 Screen Patterns

#### List Screen Pattern

```
┌──────────────────────────────────────┐
│ AppBar: "Título"          [Search]   │
├──────────────────────────────────────┤
│ [AppSegmentedControl: Todos|Ativos]   │
├──────────────────────────────────────┤
│ ┌──────────────────────────────────┐ │
│ │ ListTile                          │ │
│ │ (MemberCard / MeetingCard)        │ │
│ └──────────────────────────────────┘ │
│ ┌──────────────────────────────────┐ │
│ │ ListTile                          │ │
│ └──────────────────────────────────┘ │
│ ...                                  │
├──────────────────────────────────────┤
│ [FAB: + Adicionar]                  │
└──────────────────────────────────────┘
```

**Features:**
- Pull-to-refresh (`RefreshIndicator`)
- Floating Action Button for add actions
- Optional search bar in AppBar
- Optional filter chips below AppBar

#### Detail Screen Pattern

```
┌──────────────────────────────────────┐
│ AppBar: [← Back]  "Título"  [⋮ Menu] │
├──────────────────────────────────────┤
│                                      │
│          Hero Section                │
│          (Image/Avatar/Header)       │
│                                      │
├──────────────────────────────────────┤
│                                      │
│          Content Sections            │
│          (Biography, Info, etc)      │
│                                      │
├──────────────────────────────────────┤
│          Action Buttons              │
│  [Primary Action]  [Secondary Act]  │
└──────────────────────────────────────┘
```

#### Form Screen Pattern

```
┌──────────────────────────────────────┐
│ AppBar: [← Cancel]  "Título"  [Save] │
├──────────────────────────────────────┤
│                                      │
│  ┌────────────────────────────────┐  │
│  │ AppTextField                    │  │
│  └────────────────────────────────┘  │
│                                      │
│  ┌────────────────────────────────┐  │
│  │ AppTextField                    │  │
│  └────────────────────────────────┘  │
│                                      │
│  [Section Header: "详细信息"]        │
│                                      │
│  ...                                 │
│                                      │
└──────────────────────────────────────┘
```

**Features:**
- AppBar "Save" button triggers validation
- Disabled save button until form is valid
- Inline validation on blur
- Section grouping for long forms

#### Empty/Loading/Error States

Every screen must handle:
- **Loading:** `AppLoading()` centered
- **Empty:** `AppEmpty(message: "...", action: ...)`
- **Error:** `AppError(message: "...", onRetry: ...)`

### 4.3 Navigation with go_router

**Route Structure:**
```
/                           → redirect to /home or /login
/login                      → LoginPage
/register                   → RegisterPage

/home                      → HomePage (ShellRoute with BottomNav)
  /home/carnival-blocks    → CarnivalBlockListPage
  /home/carnival-blocks/:id → CarnivalBlockDetailPage
  /home/meetings           → MeetingListPage
  /home/meetings/:id       → MeetingDetailPage
  /home/members            → MemberListPage
  /home/members/:id        → MemberDetailPage
  /home/profile            → ProfilePage
  /home/settings           → SettingsPage
```

**ShellRoute Configuration:**
```dart
ShellRoute(
  builder: (context, state, child) => AppShell(child: child),
  routes: [
    GoRoute(path: '/home', ...),
  ],
)
```

**AppShell with BottomNav:**
```dart
class AppShell extends StatelessWidget {
  final Widget child;
  // Uses GoRouter's current location to set BottomNav index
  // Wraps child in Scaffold with BottomNavigationBar
}
```

---

## 5. Iconography & Imagery

### 5.1 Icon System

**Recommendation:** Use Flutter's built-in `Icons` (Material Symbols) with `Icons.rounded` variant for softer appearance.

**Alternative (if needed):** `flutter_vector_icons` package with Phosphor or Heroicons set.

**Primary Icon Set:** Material Symbols Rounded
**Icon Sizes:**
- `IconSize.sm`: 16px (inline with text)
- `IconSize.md`: 20px (standard)
- `IconSize.lg`: 24px (prominent)
- `IconSize.xl`: 32px (feature icons)

**Common Icons Mapping:**

| Concept | Icon |
|---------|------|
| Home | `Icons.home_rounded` |
| Blocks/Carnival | `Icons.celebration_rounded` |
| Meetings | `Icons.event_rounded` |
| Members | `Icons.people_rounded` |
| Profile | `Icons.person_rounded` |
| Settings | `Icons.settings_rounded` |
| Search | `Icons.search_rounded` |
| Add/Create | `Icons.add_rounded` |
| Edit | `Icons.edit_rounded` |
| Delete | `Icons.delete_rounded` |
| Back | `Icons.arrow_back_rounded` |
| Forward | `Icons.arrow_forward_rounded` |
| Menu | `Icons.more_vert_rounded` |
| Check | `Icons.check_rounded` |
| Close | `Icons.close_rounded` |
| Warning | `Icons.warning_rounded` |
| Error | `Icons.error_rounded` |
| Success | `Icons.check_circle_rounded` |
| Info | `Icons.info_rounded` |
| Calendar | `Icons.calendar_today_rounded` |
| Time | `Icons.access_time_rounded` |
| Location | `Icons.location_on_rounded` |
| Phone | `Icons.phone_rounded` |
| Email | `Icons.email_rounded` |
| Password | `Icons.lock_rounded` |
| Visibility | `Icons.visibility_rounded` |
| Loading | `Icons.sync_rounded` (animated) |

### 5.2 Avatar Patterns

**Image Loading:**
- Use `CachedNetworkImage` for member photos
- Shimmer placeholder during load
- Fallback to initials on error

**Initials Avatar Colors:**
Rotate through a palette based on name hash:
```dart
const _avatarColors = [
  Color(0xFF4F46E5), // Primary
  Color(0xFFF97316), // CTA
  Color(0xFF10B981), // Success
  Color(0xFF3B82F6), // Info
  Color(0xFF8B5CF6), // Purple
  Color(0xFFEC4899), // Pink
];
```

**Size Standards:**
| Size | Usage |
|------|-------|
| 24px | Inline with text (comment author) |
| 32px | List tile leading |
| 48px | Default member avatar |
| 64px | Profile header |
| 96px | Full profile view |

### 5.3 Illustration & Empty States

**Approach:** Use simple geometric/abstract illustrations with the brand color palette.

**Sources:**
- Custom SVG illustrations (stored in `assets/images/`)
- Or use `flutter_svg` with icons from Heroicons/Lucide
- Abstract geometric shapes for decorative purposes

**Empty State Pattern:**
```
┌──────────────────────────────────────┐
│                                      │
│         [Decorative Icon/Shape]      │
│                                      │
│       "Nenhuma reunião encontrada"   │
│                                      │
│    Parece que você ainda não tem     │
│    reuniões agendadas.               │
│                                      │
│       [+ Criar primeira reunião]    │
│                                      │
└──────────────────────────────────────┘
```

---

## 6. Migration / Implementation Roadmap

### 3.5 Navigation Decision (Final)

**Decision (web-verified, July 2026):** Use **`StatefulShellRoute.indexedStack`** instead of plain `ShellRoute`.

**Research sources:**
- Flutter official docs (`docs.flutter.dev/ui/navigation`, May 2026): "We don't recommend using named routes for most applications. Instead, use **go_router** (or another routing package)..."
- go_router 17.3.0 API docs: `StatefulShellRoute` is purpose-built for "implementing a UI with a BottomNavigationBar, with a **persistent navigation state for each tab**"
- Current pubspec: `go_router: ^17.2.3` (already installed) — compatible with `StatefulShellRoute` (available since 7.1.0)

**Why `StatefulShellRoute.indexedStack` over plain `ShellRoute`:**

| Aspect | ShellRoute | StatefulShellRoute.indexedStack |
|--------|------------|---------------------------------|
| Navigators per tab | 1 shared | 1 per branch (5 for our app) |
| Tab state preservation | ❌ Lost when switching | ✅ Preserved (scroll, forms, bloc state) |
| Switching speed | Rebuilds branch | Instant (IndexedStack) |
| Memory cost | Low | Slightly higher (5 branches alive) |
| Recommendation for bottom nav | Not ideal | **Officially recommended** |

**For "Bloco na Rua"** (5 main tabs: Início, Blocos, Reuniões, Membros, Perfil) this means:
- Tap "Reuniões" → switch to that tab → return to "Início" → tap "Reuniões" again → **you're back where you were** (preserved scroll, form data, etc.)
- 5 IndexedStack branches is negligible memory cost for a mobile app

**Implementation pattern:**

```dart
final router = GoRouter(
  initialLocation: '/home',
  redirect: authRedirect,
  routes: [
    // Public routes (no shell)
    GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
    GoRoute(path: '/register', builder: (_, __) => const RegisterPage()),

    // Main app with bottom nav
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/home', builder: (_, __) => const HomePage()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/carnival-blocks', builder: (_, __) => const BlockListPage()),
          GoRoute(path: '/carnival-blocks/:id', builder: (_, __) => const BlockDetailPage()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/meetings', builder: (_, __) => const MeetingListPage()),
          GoRoute(path: '/meetings/:id', builder: (_, __) => const MeetingDetailPage()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/members', builder: (_, __) => const MemberListPage()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
          GoRoute(path: '/settings', builder: (_, __) => const SettingsPage()),
        ]),
      ],
    ),

    // Modal routes (full-screen, outside shell)
    GoRoute(path: '/create-block', pageBuilder: ...),
    GoRoute(path: '/create-meeting/:blockId', pageBuilder: ...),
  ],
);
```

**`AppShell` widget:**

```dart
class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const AppShell({required this.navigationShell, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (i) => navigationShell.goBranch(
          i,
          initialLocation: i == navigationShell.currentIndex,
        ),
        items: const [...],
      ),
    );
  }
}
```

**Migration impact:** The current `lib/routing/router.dart` (320 lines, flat GoRoute list with no shell) will be replaced. The `BlocProvider` creation pattern, auth redirect, and custom slide transitions will be preserved. No new dependencies needed (go_router 17.2.3 already installed).

---

### Phase 1: Foundation (Week 1)

**Goal:** Establish design system infrastructure

1. **Create directory structure** under `lib/ui/design_system/`
2. **Implement design tokens:**
   - `colors.dart` - All color constants
   - `spacing.dart` - Spacing constants
   - `radius.dart` - Border radius constants
   - `duration.dart` - Animation durations
   - `typography.dart` - Text styles

3. **Implement theme layer:**
   - `color_schemes.dart` - Light/dark ColorScheme
   - `text_themes.dart` - TextTheme with Fredoka/Nunito
   - `app_theme.dart` - ThemeData builder

4. **Update `app.dart`:**
   - Add `GoogleFonts` initialization
   - Configure `ThemeMode` persistence
   - Wrap with `Theme` widget

**Deliverable:** `lib/ui/design_system/` foundation complete

---

### Phase 2: Core Widgets (Week 2)

**Goal:** Build primitive component library

1. **Buttons:**
   - `AppButton` (primary, secondary, tertiary, ghost)
   - `AppIconButton`
   - `AppFAB`

2. **Cards:**
   - `AppCard` base

3. **Inputs:**
   - `AppTextField`
   - `AppSearchField`

4. **Feedback:**
   - `AppSnackBar` (snackbar helper)
   - `AppDialog` (dialog helper)
   - `AppLoadingIndicator`

5. **Display:**
   - `AppAvatar`
   - `AppChip`
   - `AppBadge`

**Deliverable:** All primitive components implemented and documented

---

### Phase 3: Navigation & Layout (Week 3)

**Goal:** App shell and routing infrastructure

1. **Navigation components:**
   - `AppAppBar`
   - `AppBottomNav`
   - `AppShell` (Scaffold wrapper)

2. **Router configuration:**
   - `app_router.dart` with go_router
   - ShellRoute setup
   - Deep link handling

3. **State components:**
   - `AppLoading`
   - `AppError`
   - `AppEmpty`

**Deliverable:** Navigation infrastructure ready for feature implementation

---

### Phase 4: Compound Components (Week 4)

**Goal:** Build feature-specific compound components

1. **Auth components:**
   - `AuthForm` (login/register form wrapper)
   - `SocialLoginButtons`

2. **Home components:**
   - `SectionHeader`

3. **Feature cards:**
   - `MemberCard`
   - `MeetingCard`
   - `BlockCard`

4. **Specialized chips:**
   - `PresenceChip`

5. **List tiles:**
   - `MemberListTile`
   - `MeetingListTile`
   - `BlockListTile`

**Deliverable:** Compound component library complete

---

### Phase 5: Feature Implementation (Week 5-6)

**Goal:** Rebuild existing features with new design system

1. **Auth feature** - Login, Register pages
2. **Home feature** - Dashboard/home page
3. **Carnival Block feature** - List, Detail, Create
4. **Meetings feature** - List, Detail, Create, Presence
5. **Members feature** - List, Detail
6. **Profile feature** - View, Edit
7. **Settings feature** - Preferences, Theme toggle

**Deliverable:** All features migrated to new design system

---

### Confirmed Decisions (2026-07-03)

1. **Authentication flow:** ✅ Build custom forms with the new design system (not Supabase Auth UI)
2. **Image handling:** ✅ Use `CachedNetworkImage` (will be added to pubspec)
3. **Navigation:** ✅ `StatefulShellRoute.indexedStack` with go_router 17.2.3 (preserves tab state)
4. **State management:** ✅ Continue with `flutter_bloc` 9.1.1 (design system components stay stateless/presentational)
5. **Testing:** ⏸️ Deferred — widget tests for AppButton/AppCard/AppTextField will be added later

**New dependencies to add to `pubspec.yaml`:**
- `google_fonts: ^6.2.1` (for Fredoka + Nunito)
- `cached_network_image: ^3.4.1` (for avatar/photo caching)

---

## 7. Pre-Delivery Checklist

### Visual Quality
- [ ] No emojis used as icons (use `Icons` instead)
- [ ] All icons from consistent icon set (Material Rounded)
- [ ] Brand colors used consistently (no ad-hoc colors)
- [ ] Hover states don't cause layout shift (use opacity/elevation, not scale)
- [ ] Border radius applied consistently from Radius tokens

### Interaction
- [ ] All clickable elements have `cursor: pointer` equivalent (InkWell/GestureDetector)
- [ ] Hover/focus states provide clear visual feedback
- [ ] Transitions are smooth (150-300ms)
- [ ] Loading states shown during async operations
- [ ] Disabled states are visually distinct and non-interactive

### Light/Dark Mode
- [ ] Light mode text has sufficient contrast (4.5:1 minimum)
- [ ] Dark mode surfaces have proper elevation (no flat dark surfaces)
- [ ] Borders visible in both modes
- [ ] Both modes tested before delivery

### Layout
- [ ] Safe area respected on all screens
- [ ] Content padding consistent with Spacing tokens
- [ ] No content hidden behind keyboard
- [ ] Bottom sheet respects keyboard
- [ ] Responsive at mobile (375px) tested

### Accessibility
- [ ] All images have alt text / `Semantics` label
- [ ] Form inputs have proper labels
- [ ] Touch targets minimum 48x48dp
- [ ] Focus indicators visible
- [ ] `MediaQuery.disableAnimations` respected
- [ ] Color is not the only indicator (icons + color for states)

### Code Quality
- [ ] No hardcoded colors (use design tokens)
- [ ] No hardcoded spacing (use Spacing tokens)
- [ ] No magic numbers
- [ ] Theme accessed via `Theme.of(context)`
- [ ] Components properly documented

---

## Appendix: File Locations

**Design System Files:**
- `design-system/bloco-na-rua/MASTER.md` — Persisted design system

**To be Created:**
- `lib/ui/design_system/tokens/` — Design token constants
- `lib/ui/design_system/theme/` — Theme configuration
- `lib/ui/design_system/components/` — Reusable widgets
- `lib/ui/app.dart` — App widget with theme
- `lib/ui/router/app_router.dart` — Navigation

---

*Plan created: 2026-07-03*
*Design system generated by: ui-ux-pro-max*
