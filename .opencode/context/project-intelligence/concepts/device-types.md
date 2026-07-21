<!-- Context: project-intelligence/concepts/device-types | Priority: medium | Version: 3.0 | Updated: 2026-07-02 -->

# Target Devices & Users — BlocoNaRua

**Core Concept**: Mobile-first Flutter app for Brazilian users managing carnival block logistics. Primary language: pt-BR. Secondary: en.

---

## Devices

### Primary: Mobile (Android + iOS)

| Aspect          | Value                                             |
| --------------- | ------------------------------------------------- |
| Form factor     | Phone (Android 8+, iOS 13+)                       |
| Orientation     | Portrait (locked by convention)                  |
| Density         | Standard + high-DPI (Material 3 + Cupertino icons) |
| Theme           | Light + Dark (system-driven via `ThemeMode.system`) |

### Out of Scope (for v1)

- ❌ Desktop layouts (no `SidebarWrapView`, no responsive breakpoints)
- ❌ Tablet/iPad dedicated layouts
- ❌ Web (`flutter run -d chrome` not part of CI)
- ❌ Watch / TV / embedded

If a request comes in for those, see `living-notes.md` for status before proposing.

---

## Localization

| Locale             | Status    | Coverage                                  |
| ------------------ | --------- | ----------------------------------------- |
| `pt-BR` (default)    | ✅ Active  | All UI strings, error messages, currency   |
| `en` (US)            | ✅ Active  | Framework-level (no full translation yet) |
| Other Portuguese    | ⏳ Future | Not configured                            |

**Where**:
- `main_app.dart` → `supportedLocales: [Locale('pt','BR'), Locale('en','')]`
- `GlobalMaterialLocalizations.delegate` + `GlobalWidgetsLocalizations.delegate` + `GlobalCupertinoLocalizations.delegate`

**Error messages**: Hardcoded pt-BR in `lib/core/error_messages.dart` (see `ErrorMessages` class).

**Formatters**: `brasil_fields` for CPF, CNPJ, phone (BR format).

---

## Users (Personas)

| Persona             | Goal                                                          |
| ------------------- | ------------------------------------------------------------- |
| **Block Leader**    | Create block, manage members, schedule meetings, send invites |
| **Member**          | Join blocks via invite code, RSVP to meetings                |
| **Visitor**         | View public blocks (if enabled)                               |

All authenticated via Supabase email/password.

---

## Constraints

- **Network**: App MUST work over flaky mobile data (timeout + retry)
- **Battery**: No background sync (foreground-only)
- **Storage**: Minimal local cache (SharedPreferences for token only)
- **Privacy**: No analytics SDK; Supabase auth tokens are sole persistence

---

## Reference

- `concepts/stack.md` — i18n packages
- `core/error_messages.dart` — pt-BR strings
- `main_app.dart` — supportedLocales
- `living-notes.md` — out-of-scope device plans
