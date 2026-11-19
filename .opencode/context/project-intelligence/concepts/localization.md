<!-- Context: project-intelligence/concepts/localization | Priority: high | Version: 1.0 | Updated: 2026-11-19 -->

# Localization (i18n)

**Core Concept**: pt-BR-first Flutter app with a full ARB catalog — every user-facing string in `lib/ui` comes from `AppLocalizations`, with pt/en parity (267 keys each). No baked strings in widgets, cubits, or states.

## Key Points

- **ARB source of truth**: `lib/l10n/app_pt.arb` + `app_en.arb` (267 keys, parity enforced); generated files are NEVER hand-edited — run `flutter gen-l10n`
- **Date/number helpers**: `lib/core/date_format.dart` exposes `kAppLocale`, `kSupportedLocales` (['pt','en']), `formatDateTime`, `formatShortDate`, `formatShortDateTime`, `formatDatePattern` — all derive locale from context
- **Marker pattern for errors**: cubits/states have no `BuildContext`, so they carry typed markers (`AuthSuccessKind`, `BlockError`, `MeetingError`) instead of strings; screens localize via `extractUserMessage(error, context)`
- **Locale scope**: only `pt` and `en` supported; `pt` is the default/fallback
- **Test harnesses**: widget tests must pump with `localizationsDelegates` + `supportedLocales` or the suite hangs (see `../living-notes.md`)

## Example

```dart
// In a widget: look up strings via context
Text(AppLocalizations.of(context)!.blockName),
final l10n = lookupAppLocalizations(const Locale('pt')); // tests only

// In a cubit/state: marker, not string
sealed class BlockError { const BlockError(); }
class BlockNotFound extends BlockError { const BlockNotFound(); }

// At render time: convert marker → localized message
Text(extractUserMessage(error, context)),
```

## Reference

- ARB catalog: `lib/l10n/` (source: `app_pt.arb`, `app_en.arb`)
- Date helpers: `lib/core/date_format.dart`
- Error → message mapping: `lib/core/errors/user_message.dart`
- Marker types: `lib/ui/auth/cubit/auth_state.dart`, `lib/ui/carnivalBlock/block_error.dart`, `lib/ui/meetings/meeting_error.dart`

## Related

- `../lookup/design-tokens.md` — token invariants (theme pairs with i18n)
- `../lookup/ui-organization.md` — where widgets live
- `../living-notes.md` — test-harness gotcha details
