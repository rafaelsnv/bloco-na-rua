<!-- Context: project-intelligence/errors/dio-supabase-errors | Priority: medium | Version: 1.0 | Updated: 2026-07-02 -->

# Errors — Dio & Supabase Gotchas

**Core Concept**: Two error sources, each with its own quirks. This file lists common failures + how to debug them.

---

## Dio Errors

### 1. `DioExceptionType.connectionError` on emulator

**Symptom**: Request fails with "connection error" right after starting emulator.
**Cause**: Emulator's network can't reach `127.0.0.1` or `localhost`.
**Fix**: Use `10.0.2.2` (Android emulator's host alias) in `.env`:
```
API_URL=http://10.0.2.2:8080
```
For iOS simulator, `localhost` works.

---

### 2. `validateStatus` swallowing 4xx as success

**Symptom**: Your repo receives a 404 but treats it as success; entity deserialization fails.
**Cause**: `BaseOptions.validateStatus: (s) => s >= 200 && s < 500` lets 4xx through.
**Fix**: Either tighten `validateStatus`, or check `response.statusCode` explicitly in the repo:

```dart
final res = await _base.get<dynamic>('/foo');
if (res.statusCode == 404) {
  return Failure(ApiError(
    type: ApiErrorType.notFound,
    userMessage: ErrorMessages.notFound,
  ));
}
```

---

### 3. Pretty log showing JSON twice

**Symptom**: Same payload printed in both request body and response body.
**Cause**: `PrettyDioLogger(requestBody: true, responseBody: true)`.
**Fix**: Set to `false` in production builds; OK for dev.

---

### 4. Interceptor chain order

**Symptom**: `ApiError.fromDioException` returns a generic error.
**Cause**: Interceptors added in wrong order; `DioErrorInterceptor` not first.
**Fix**:
```dart
client.interceptors.add(DioErrorInterceptor());   // FIRST
client.interceptors.add(PrettyDioLogger(...));    // SECOND
```

---

### 5. 401 not triggering logout

**Symptom**: Backend returns 401, but app stays in `/home`.
**Cause**: Cubit emits failure but `IAuthRepository` is never notified.
**Fix**: Either handle 401 globally in `DioErrorInterceptor`:
```dart
if (err.response?.statusCode == 401) {
  locator<IAuthRepository>().notifyListeners();
}
```
Or call `signOut()` from each cubit on auth failure.

See `living-notes.md` for current approach.

---

### 6. `null` response for `badResponse`

**Symptom**: `response` is null inside `DioExceptionType.badResponse`.
**Cause**: Rare edge case (e.g., response parse failed earlier).
**Fix**: Already handled in `ApiError.fromResponse` (returns `unknown`).

---

## Supabase Errors

### 1. `AuthException: Invalid login credentials`

**Symptom**: Sign-in fails with `AuthException`.
**Cause**: Wrong email/password, OR account not yet confirmed (if email confirmation enabled).
**Fix**:
- Show generic pt-BR message: "E-mail ou senha incorretos"
- Check `e is AuthException && e.statusCode == 400`

---

### 2. `SessionNotFoundException` after backgrounding

**Symptom**: `currentSession` returns null after app is backgrounded for >1 hour.
**Cause**: Supabase token expired; auto-refresh triggered but failed silently.
**Fix**: Call `supabase.auth.refreshSession()` in app resume handler, OR redirect to `/login`.

---

### 3. Realtime not connecting

**Symptom**: `realtimeClientOptions(logLevel: RealtimeLogLevel.warn)` but no warnings.
**Cause**: Default `RealtimeLogLevel.info` may suppress; OR the channel wasn't subscribed.
**Fix**:
- Verify `Supabase.initialize(...)` was awaited in `main()`
- Verify channel `.subscribe()` was called

---

### 4. `Supabase.instance.client` not initialized

**Symptom**: `Bad state: Future not completed` on first auth call.
**Cause**: Missing `await Supabase.initialize(...)` before `runApp`.
**Fix**: Already enforced — `await` is in `main()`.

---

### 5. Gotrue vs supabase_flutter mismatch

**Symptom**: `AuthResponse` types differ across versions.
**Cause**: `gotrue` pinned at ^2.14.0 but `supabase_flutter` may want newer.
**Fix**: Check `pubspec.lock` — run `flutter pub outdated` and align.

---

## General Debugging

```dart
// In a Cubit
final _log = Logger('MyCubit');

// Log response attempts:
_log.info('Calling getBlocksByMemberId($userId)');
final result = await _repo.getBlocksByMemberId(userId);
_log.info('getBlocksByMemberId → isError=${result.isError()}');

// Inspect error after translation:
result.exceptionOrNull().toString().let((e) {
  if (e is ApiError) {
    _log.warning('Type=${e.type} Status=${e.statusCode} Msg=${e.technicalMessage}');
  }
});
```

---

## Reference

- `concepts/dio-pipeline.md` — interceptor chain
- `concepts/supabase-vs-rest.md` — error split
- `guides/error-to-user-message.md` — translation pipeline
- `lib/core/api_error.dart` — full source
