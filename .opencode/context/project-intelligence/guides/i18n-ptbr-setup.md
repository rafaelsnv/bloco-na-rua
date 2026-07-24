<!-- Context: guides/i18n-ptbr | Priority: medium | Version: 1.0 | Created: 2026-07-19 -->

# i18n: pt_BR Error Messages Setup

**Core Idea**: Refactor ErrorMessages to use Flutter's built-in i18n (flutter_localizations + intl) instead of hardcoded static const strings, with pt_BR as primary locale.

**Key Points**:
- pubspec.yaml already has `flutter_localizations` + `intl` packages
- l10n.yaml configures ARB files for localized strings
- app_pt.arb contains all error messages in Brazilian Portuguese
- app_en.arb provides English fallback
- ErrorMessages refactored to use `AppLocalizations` instead of hardcoded strings

**Components**:
| File | Purpose |
|------|---------|
| `l10n.yaml` | Flutter localization config |
| `lib/l10n/app_pt.arb` | Portuguese (Brazil) translations |
| `lib/l10n/app_en.arb` | English fallback |

**Constraints**:
- Must maintain backward compatibility with existing ApiError architecture
- Keep English as fallback

**Reference**: `lib/core/error_messages.dart`, `lib/core/api_error.dart`

**Source**: `.tmp/sessions/2026-07-19-i18n-ptbr/context.md`
