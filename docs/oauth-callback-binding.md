# Google OAuth: `/Auth/google/complete` callback binding

**Status:** Closed — Scenario A confirmed by backend (2026-11-19)

## Resolution (2026-11-19)

`/challenge` stores OAuth correlation in a protected `bnr_google_state` cookie (`HttpOnly`, `SameSite=Lax`, 10-minute expiry, single-use, and Data Protection-encrypted; `Program.cs:129-135`). `/complete` calls `HttpContext.AuthenticateAsync("GoogleState")` (`AuthController.cs:135-138`), so a missing or invalid pending cookie returns `401`. The cookie is signed out before tokens are issued (`AuthController.cs:160-161`), preventing replay.

No app change is needed. The cookie binds the browser/device, not the app instance: within the validity window, anything sharing the browser cookie jar on the same device could receive tokens. Cross-device hijacking is impossible. Scenario B's nonce is only needed if per-instance binding is ever required.

**Raised:** 2026-11-19 (auth-api-migration, CodeReview finding M4)
**Specs:** swagger `bloco_na_rua.json`, RFC 8252 (OAuth 2.0 for Native Apps)

## Current app flow

1. App opens the external browser (RFC 8252: no webviews) at `GET /api/v1/Auth/google/challenge`.
2. User consents in the browser; Google redirects back to the backend at `GET /api/v1/Auth/google/complete`.
3. In parallel, the app listens for the deep link `blocnatarua://auth/callback` (Android intent-filter; iOS/Windows not yet registered — they fall back to polling). When the link fires, the app calls `/complete` itself and parses the response as `LoginResponse`.

## Related notes

- `/Auth/refresh` and `/Auth/google/complete` 200 response bodies are undocumented in swagger; the app parses them as `LoginResponse` (flagged via `ponytail:` comments in `auth_api_client.dart`).
- Deep link is registered Android-only (no `ios/Runner/Info.plist` or Windows config in repo). Other platforms use the 60s polling fallback of `/complete`.
