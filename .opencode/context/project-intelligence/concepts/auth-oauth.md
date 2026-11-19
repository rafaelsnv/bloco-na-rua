<!-- Context: project-intelligence/concepts/auth-oauth | Priority: high | Version: 1.0 | Updated: 2026-11-19 -->

# Google OAuth via External Browser

**Core Concept**: Google OAuth uses the external browser (RFC 8252 pattern), launched at `GET /api/v1/Auth/google/challenge`; completion returns via the deep link `blocnatarua://auth/callback` or a 60s polling fallback of `/complete`.

---

## Key Points

- **External browser only** — launched via `url_launcher`; no webviews.
- **Deep-link listener** via `app_links` (Android intent-filter registered; iOS/Windows fall back to polling).
- **`/complete` is session-bound** — requires the single-use HttpOnly `bnr_google_state` cookie created by `/challenge` (10-min expiry, one-time replay); forged callbacks get 401 (confirmed Scenario A, backend `AuthController.cs`).
- **Caveat**: the cookie binds the device's *browser*, not the app instance — anything sharing the cookie jar on the device within the window could complete the flow.
- **Undocumented 200 bodies**: `/refresh` and `/complete` responses are absent from swagger; parsed as `LoginResponse`.

---

## Reference

- Binding analysis: `docs/oauth-callback-binding.md`

## Related

- `lib/data/services/auth/auth_api_client.dart`
- `lib/data/services/auth/google_sign_in_service.dart`
