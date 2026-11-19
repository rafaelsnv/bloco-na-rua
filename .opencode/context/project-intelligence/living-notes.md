<!-- Context: project-intelligence/notes | Priority: high | Version: 1.1 | Updated: 2026-11-19 -->

# Living Notes

> Active issues, technical debt, open questions, and insights that don't fit elsewhere. Keep this alive.

## Quick Reference

- **Purpose**: Capture current state, problems, and open questions
- **Update**: Weekly or when status changes
- **Archive**: Move resolved items to bottom with status

## Technical Debt

| Item | Impact | Priority | Mitigation |
|------|--------|----------|------------|
| M11 skeleton loaders | Layout jump when spinners resolve to content | Medium | Add skeleton loading widgets for card/list screens |
| Tablet NavigationRail / two-pane layouts | Phone layout stretched on tablets (H9 shipped gutters + max width only) | Low | NavigationRail + two-pane when tablet use is real |
| Per-user onboarding keying | Onboarding flag is device-scoped (marked with `ponytail:` comment); new device for same user re-shows onboarding | Low | Key flag by user id when multi-device users appear |
| shrinkWrap card lists | Render cost grows linearly; fine below ~500 members | Low | Revisit with lazy slivers past ~500 members |

## Known Issues

| Issue | Severity | Workaround | Status |
|-------|----------|------------|--------|
| Widget tests without `localizationsDelegates` hang the suite | High | Use local `_app()` helper with delegates + `lookupAppLocalizations(const Locale('pt'))` assertions | Known |
| task-management `router.sh` broken in this environment | Low | Use `npx tsx "C:/Users/rafae/.config/opencode/skills/task-management/scripts/task-cli.ts" <cmd> <feature> <seq> "summary"` | Known |

### Issue Details

**Test harness localization hang**
*Severity*: High
*Impact*: Any widget test pumping a screen without delegates; a null-check crash in build leaves a pending exception and the suite hangs
*Root Cause*: Missing `AppLocalizations` delegates → `.of(context)` null
*Fix Plan*: Always pump via the local `_app()` helper (see `concepts/localization.md`)

## Patterns Worth Preserving

- `AppColors.inkFor` luminance rule (threshold 0.4) — single ink decision for any fill
- Marker pattern for cubit/state errors (`BlockError`, `MeetingError`, `AuthSuccessKind`) — localizes at render time via `extractUserMessage(error, context)`
- Compact `AppStateView` variants for `AppError`/`AppEmpty`
- `_app()` test harness helper with `lookupAppLocalizations` assertions

## Gotchas for Maintainers

- Never hand-edit generated l10n files — run `flutter gen-l10n`
- `Color(0x` literals only in `app_colors.dart`
- No relative imports (`import '..`) in `lib/ui`

## Archive (Resolved Items)

### Resolved: UI/UX audit remediation
- **Resolved**: 2026-11-19
- **Resolution**: 29/29 tasks completed — accessibility (semantics, 48dp targets, reduced motion), full ARB/i18n migration (267 keys, pt/en), session-cache redirect, new core widgets (AppDateTimeField, ContentWidthLimiter, AppStateView compact, AppSpinner), token contrast fixes. Analyzer clean, 117/117 tests pass.
- **Learnings**: Test harnesses must supply delegates; markers beat baked strings for cubit errors.

## Related Files

- `decisions-log.md` - Past decisions that inform current state
- `concepts/localization.md` - i18n pattern and test harness requirements
- `lookup/design-tokens.md` - Token invariants
