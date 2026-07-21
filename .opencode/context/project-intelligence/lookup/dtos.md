<!-- Context: project-intelligence/lookup/dtos | Priority: medium | Version: 1.0 | Updated: 2026-07-02 -->

# DTOs Catalog

**Core Concept**: DTOs are wire-format freezed classes used exclusively for HTTP request/response payloads at the data-service boundary. They are distinct from **entities** (domain models in `lib/domain/entities/`) — DTOs describe the JSON shape sent/received over the network, while entities describe the in-app domain. All 5 DTOs are `@freezed` classes with `fromJson` factories; they are consumed only by their corresponding `*ApiClient` and never reach the domain layer.

---

## Auth DTOs

3 DTOs under `lib/data/services/auth/models/`. Consumed by `AuthApiClient` in `lib/data/services/auth/auth_api_client.dart` (Supabase-backed).

| DTO              | Source Path                                                          | Fields                                                              | Consumed By                                     |
| ---------------- | -------------------------------------------------------------------- | ------------------------------------------------------------------- | ----------------------------------------------- |
| `LoginRequest`    | `lib/data/services/auth/models/login_request/login_request.dart`     | `email` (String), `password` (String)                              | `AuthApiClient.logIn(LoginRequest)`             |
| `LoginResponse`   | `lib/data/services/auth/models/login_response/login_response.dart`   | `userUuid` (String), `accessToken` (String), `refreshToken` (String?) | `AuthApiClient.logIn` / `signUp` → returns this |
| `SignUpRequest`   | `lib/data/services/auth/models/signup_request/signup_request.dart`   | `name`, `email`, `phone`, `password`, `profileImage` (all String)   | `AuthApiClient.signUp(SignUpRequest)`           |

> **Note**: `LoginResponse` is the return type for both `logIn` and `signUp` — Supabase's `signUp` returns a `Session` with the same shape as `signInWithPassword`, so a single response DTO covers both flows.

---

## `LoginRequest`

**File**: `lib/data/services/auth/models/login_request/login_request.dart`

```dart
@freezed
sealed class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String email,
    required String password,
  }) = _LoginRequest;
  // ...
}
```

- **Purpose**: Wire payload sent to `AuthApiClient.logIn`. Both fields are required.
- **Used by**: `AuthApiClient.logIn(LoginRequest loginRequest)` — only call site.

---

## `LoginResponse`

**File**: `lib/data/services/auth/models/login_response/login_response.dart`

```dart
@freezed
sealed class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required String userUuid,
    required String accessToken,
    String? refreshToken,
  }) = _LoginResponse;
  // ...
}
```

- **Purpose**: Session info returned by the auth layer. `userUuid` and `accessToken` are required; `refreshToken` is optional (Supabase may omit it on certain flows).
- **Used by**: Returned by `AuthApiClient.logIn` and `AuthApiClient.signUp`. Both methods construct a `LoginResponse` from the Supabase `Session`.

---

## `SignUpRequest`

**File**: `lib/data/services/auth/models/signup_request/signup_request.dart`

```dart
@freezed
sealed class SignUpRequest with _$SignUpRequest {
  const factory SignUpRequest({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String profileImage,
  }) = _SignUpRequest;
  // ...
}
```

- **Purpose**: Wire payload for new-account creation. All 5 fields are required (the wire schema is stricter than the eventual `MembersEntity`).
- **Used by**: `AuthApiClient.signUp(SignUpRequest signUpRequest)` — only call site.

---

## Member DTOs

2 DTOs under `lib/data/services/api/members/`. Consumed by `MembersApiClient` in `lib/data/services/api/members/members_api_client.dart` (REST/Dio-backed via `IBaseApiClient`).

| DTO             | Source Path                                                      | Fields                                                                          | Consumed By                                                       |
| --------------- | ---------------------------------------------------------------- | ------------------------------------------------------------------------------- | ----------------------------------------------------------------- |
| `MemberCreate`   | `lib/data/services/api/members/create/member_create.dart`       | `name`, `email`, `phone`, `profileImage`, `uuid` (all required String)          | `MembersApiClient.createAsync(MemberCreate model)`                |
| `MemberUpdate`   | `lib/data/services/api/members/update/member_update.dart`       | `name`, `email`, `phone`, `profileImage` (all nullable String?)                | `MembersApiClient.updateAsync(int id, Map<String, dynamic> data)` |

> **Note on `MemberUpdate`**: Despite the DTO being defined, `MembersApiClient.updateAsync` currently accepts a raw `Map<String, dynamic>` rather than the typed `MemberUpdate`. The DTO exists for typed-construction convenience at call sites; conversion to `Map` is done before reaching the api client. This is a known minor drift — prefer typing the parameter directly if you refactor the api client.

---

## `MemberCreate`

**File**: `lib/data/services/api/members/create/member_create.dart`

```dart
@freezed
sealed class MemberCreate with _$MemberCreate {
  const factory MemberCreate({
    required String name,
    required String email,
    required String phone,
    required String profileImage,
    required String uuid,
  }) = _MemberCreate;
  // ...
}
```

- **Purpose**: Wire payload for `POST {basePath}Members` (create a member record server-side). `uuid` is supplied by the caller (the Supabase auth user id from `LoginResponse.userUuid`).
- **Used by**: `MembersApiClient.createAsync` — calls `model.toJson()` and posts it.

---

## `MemberUpdate`

**File**: `lib/data/services/api/members/update/member_update.dart`

```dart
@freezed
abstract class MemberUpdate with _$MemberUpdate {
  const factory MemberUpdate({
    String? name,
    String? email,
    String? phone,
    String? profileImage,
  }) = _MemberUpdate;
  // ...
}
```

- **Purpose**: Partial-update wire payload for `PUT {basePath}Members/{id}`. All fields are nullable so callers can send a PATCH-style subset.
- **Used by**: `MembersApiClient.updateAsync` — call sites build a `MemberUpdate` and convert to `Map<String, dynamic>` before invoking the api client.

---

## Adding a New DTO

1. Create a folder under the appropriate `data/services/{feature}/models/` (auth) or `data/services/api/{feature}/{verb}/` (REST CRUD) tree
2. Add `{dto_name}.dart` with `@freezed sealed class XxxDto with _$XxxDto` and a `factory XxxDto.fromJson(Map<String, dynamic> json)` factory
3. Add the matching `part '{dto_name}.freezed.dart';` and `part '{dto_name}.g.dart';` directives
4. Run: `dart run build_runner build --delete-conflicting-outputs`
5. Wire the DTO into the corresponding `*ApiClient` method signature
6. Update this catalog
7. Update `business-tech-bridge.md` if the DTO surfaces a new wire contract

> Follow the per-concern folder convention: `data/services/auth/models/{verb}_{kind}/` for Supabase-backed auth, and `data/services/api/{resource}/{verb}/` for REST CRUD. See `naming-conventions.md` for the full rule set.

---

## Reference

- `lib/data/services/auth/auth_api_client.dart` — consumes the 3 auth DTOs
- `lib/data/services/api/members/members_api_client.dart` — consumes the 2 member DTOs
- `lookup/entities.md` — for domain entities (vs these wire-format DTOs)
- `concepts/freezed-entity.md` — full freezed pattern (applies equally to DTOs)
- `naming-conventions.md` — folder + file naming rules
- `business-tech-bridge.md` — which wire contracts drive which features
