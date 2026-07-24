# Task Context: i18n Setup for pt_BR Error Messages

Session ID: 2026-07-19-i18n-ptbr
Created: 2026-07-19T00:00:00Z
Status: in_progress

## Current Request
Add proper i18n (internationalization) package usage for pt_BR error messages. Currently ErrorMessages class uses hardcoded static const strings instead of proper localization.

## Context Files (Standards to Follow)
- .opencode/context/core/standards/code-quality.md (general code standards)

## Reference Files (Source Material to Look At)
- lib/core/error_messages.dart - current hardcoded strings
- lib/core/api_error.dart - uses ErrorMessages
- lib/core/errors/user_message.dart - extractUserMessage helper
- pubspec.yaml - has flutter_localizations + intl already

## Components
1. **l10n.yaml** - Flutter localization config
2. **lib/l10n/app_pt.arb** - Portuguese (Brazil) translations
3. **lib/l10n/app_en.arb** - English fallback
4. **Update ErrorMessages** - refactor to use AppLocalizations

## Constraints
- Must use Flutter's built-in i18n (flutter_localizations + intl already in pubspec.yaml)
- Messages must be in pt_BR (Brazilian Portuguese)
- Keep English as fallback
- Must maintain backward compatibility with existing ApiError architecture

## Exit Criteria
- [ ] l10n.yaml configured
- [ ] app_pt.arb with all error messages
- [ ] app_en.arb with English translations
- [ ] ErrorMessages refactored to use AppLocalizations
- [ ] Build passes without errors
