# Pending Backend Fixes — Phase 1 (Critical)

These 4 issues require **backend API changes** and cannot be completed by the Flutter frontend alone. They were skipped during this session and tracked here for coordination with the backend team.

---

## C1 — Remove Admin Supabase API from Client

**Severity:** 🔴 Critical — Security

**File:** `lib/data/services/auth/auth_api_client.dart:80-90`

**Problem:** The `AuthApiClient` calls `_supabaseClient.auth.admin.deleteUser(id)` which requires the `service_role` key. This key must NEVER be present in client-side code. The `service_role` key can only be safely used in a backend environment.

The signup cleanup path in `auth_repository.dart` (lines 178, 278) calls `deleteUser` which will always fail because the anon key cannot call admin endpoints — the newly created auth user is never cleaned up on failed signup.

**Backend Fix Required:**
- Remove `DELETE /auth/admin/users/{id}` capability from client-side calls entirely
- Create a backend-only endpoint (e.g., `DELETE /admin/signup-cleanup/{uuid}`) that uses the `service_role` key server-side to delete orphaned auth users
- The frontend `AuthRepository.signUp` failure cleanup should call this new backend endpoint instead of `deleteUser`

**Frontend PR Readiness:** The frontend code that calls `deleteUser` is already isolated in `AuthApiClient.deleteUser` — that method can be deleted once the backend endpoint exists.

---

## C2 — Replace Plaintext Token Storage

**Severity:** 🔴 Critical — Security

**File:** `lib/data/services/shared_preferencies_service.dart:10-96`

**Problem:** Auth tokens (UUID + JWT access tokens) are persisted via `SharedPreferences`, which stores data in plaintext:
- **Android:** Unencrypted XML file in app sandbox (`/data/data/<app>/shared_prefs/`)
- **iOS:** Unencrypted `NSUserDefaults`

Any process with root/jailbreak access or a device backup can extract session tokens, enabling account takeover. Mitigated somewhat by Supabase's short-lived JWTs but refresh tokens extend the exposure window.

**Backend Fix Required:** None — this is a frontend-only fix.

**Frontend Fix (pending):**
- Replace `shared_preferences` with `flutter_secure_storage` (uses iOS Keychain / Android EncryptedSharedPreferences)
- Replace `SharedPreferencesService` → `SecureStorageService`
- `flutter pub add flutter_secure_storage` and update token read/write calls

**Note:** `flutter_secure_storage` is already in the project — the infrastructure to add it is minimal.

---

## C3 — Kill Spoofable `X-Logged-Member` Header

**Severity:** 🔴 Critical — Security / Authentication Bypass

**Files:**
- `lib/data/services/api/carnivalBlockMembers/carnival_block_members_api_client.dart:59, 86, 102`
- `lib/ui/meetings/meetingDetails/cubit/meeting_details_cubit.dart:120-125`

**Problem:** The API client sends `X-Logged-Member: {memberId}` as a custom header. The `MeetingDetailsCubit` hardcodes `memberId: 0` in the request body because it expects the API to read the member identity from the header.

Any authenticated client can spoof this header to mark attendance on behalf of another member — a privilege escalation vulnerability.

**Backend Fix Required:**
- Stop accepting `X-Logged-Member` header for presence marking
- Extract `memberId` directly from the verified JWT token on the server side
- Return the authenticated member's identity in the JWT claims, not from request headers
- Update the API route to read `memberId` from the JWT, not from `X-Logged-Member`

**Frontend PR Readiness:** Once backend confirms JWT-based member extraction, the `X-Logged-Member` header can be removed from all API client calls in `carnival_block_members_api_client.dart`.

---

## C4 — Fix Dio Error Pipeline (validateStatus + Interceptor)

**Severity:** 🔴 Critical — Correctness

**File:** `lib/config/dependencies.dart:46`

**Problem:** `validateStatus` is set to accept all non-500 responses:

```dart
validateStatus: (status) => status != null && status >= 200 && status < 500,
```

Combined with manual status checks in each API client, this creates an inconsistent error-handling pipeline:
- `validateStatus` allows 4xx through → Dio does NOT throw → `DioErrorInterceptor.onError` never fires
- `ApiError.fromResponse` chain (the centralized user-message mapping) is bypassed for all REST failures
- 401 responses won't trigger the centralized auth-error handling
- Each API client manually checks `response.statusCode != 200` inconsistently (some use `switch/case`, some use `!= 200`)

**Backend Fix Required:** None — this is a frontend-only fix, but it needs a coordinated decision.

**Two Options (frontend must pick one):**

**Option A — Let Dio throw, interceptor maps everything:**
```dart
// dependencies.dart
validateStatus: (status) => status == null || status >= 400; // throw on 4xx/5xx
```
Then `DioErrorInterceptor` maps all errors to `ApiError` and cubits get clean user messages. Manual status checks in API clients can be removed.

**Option B — Remove interceptor, keep manual checks:**
Delete `DioErrorInterceptor` entirely. Keep `validateStatus` default (throws on 4xx/5xx). Each API client handles its own error mapping. This is simpler but less centralized.

**Recommended:** Option A — the interceptor pipeline exists and is the right pattern; fix `validateStatus` to activate it.

---

## Summary Table

| ID   | Issue                              | Severity | Backend Required | Frontend Readiness |
| ---- | ---------------------------------- | -------- | --------------- | ----------------- |
| C1   | Admin Supabase API in client       | 🔴 Critical | Yes — new cleanup endpoint | Ready to delete `deleteUser` |
| C2   | Plaintext token storage            | 🔴 Critical | No | Needs `flutter_secure_storage` dependency only |
| C3   | Spoofable `X-Logged-Member` header | 🔴 Critical | Yes — JWT extraction | Ready to remove header once backend confirms |
| C4   | Dio `validateStatus` swallows 4xx  | 🔴 Critical | No | Needs `validateStatus` config change + interceptor cleanup |

---

*Created: 2026-07-13*
*Session: 2026-07-11-code-review-fix*
