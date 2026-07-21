# swagger_dart_code_generator Setup Plan

## Overview

Add [swagger_dart_code_generator](https://github.com/epam-cross-platform-lab/swagger-dart-code-generator) to `bloco_na_rua` to generate type-safe API client and model classes from `swagger.json`.

## API Surface (from swagger.json)

| Tag | Endpoints |
| --- | --------- |
| **Admin** | `DELETE /api/v1/admin/signup-cleanup/{uuid}` |
| **Auth** | `POST /api/v1/Auth/login` |
| **CarnivalBlockMembers** | `GET`, `POST`, `PUT /{id}`, `DELETE /{id}`, `GET /block/{blockId}` |
| **CarnivalBlocks** | `GET`, `POST`, `GET /{id}`, `PUT /{id}`, `DELETE /{id}` |
| **MeetingPresences** | `GET`, `POST`, `GET /{id}`, `PUT /{id}`, `DELETE /{id}` |
| **Meetings** | `GET`, `POST`, `GET /{id}`, `PUT /{id}`, `DELETE /{id}`, `GET /block/{blockId}` |
| **Members** | `GET`, `POST`, `GET /{id}`, `PUT /{id}`, `DELETE /{id}` |

## Models to be generated

- `AdminSignupCleanupUuidDeleteRequest`
- `CarnivalBlockMemberCreate` / `CarnivalBlockMemberResponse` / `CarnivalBlockMemberUpdate`
- `CarnivalBlockCreate` / `CarnivalBlockResponse` / `CarnivalBlockUpdate`
- `LoginRequest` / `LoginResponse`
- `MeetingCreate` / `MeetingResponse` / `MeetingUpdate`
- `MeetingPresenceCreate` / `MeetingPresenceResponse` / `MeetingPresenceUpdate`
- `MemberCreate` / `MemberResponse` / `MemberUpdate`
- `ProblemDetails`
- `RolesEnum`

## Implementation Steps

### Step 1 — Add dependency

```yaml
# pubspec.yaml
dev_dependencies:
  swagger_dart_code_generator: ^4.1.1
```

### Step 2 — Create `build.yaml`

```yaml
targets:
  swagger_dart_code_generator:
    options:
      input: swagger.json
      output: lib/api/
      date_format: iso8601
      include_if_null: false
      use_carousel: false
      remove_prefix: false
      enums: {}
```

### Step 3 — Run build_runner

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Step 4 — Wire into existing Dio client

```dart
// lib/api/api.dart is generated — pass your Dio instance:
final api = Api(dio);
```

### Step 5 — (Optional) Auth interceptor

The API uses Bearer JWT authentication. Configure your Dio client with an interceptor that attaches the token from `LoginResponse` to all secured requests.

## Generated File Structure

```
lib/api/
  api.dart                          # Single class with all API clients
  models/
    admin_signup_cleanup_uuid_delete_request.dart
    carnival_block_member_create.dart
    carnival_block_member_response.dart
    carnival_block_member_update.dart
    carnival_block_create.dart
    carnival_block_response.dart
    carnival_block_update.dart
    login_request.dart
    login_response.dart
    meeting_create.dart
    meeting_presence_create.dart
    meeting_presence_response.dart
    meeting_presence_update.dart
    meeting_response.dart
    meeting_update.dart
    member_create.dart
    member_response.dart
    member_update.dart
    problem_details.dart
    roles_enum.dart
```

## Compatibility with Existing Dependencies

| Dependency | Status | Notes |
| ---------- | ------ | ----- |
| `dio` | ✅ Compatible | Generator uses Dio natively |
| `freezed` / `json_serializable` | ⚠️ Coexists | Generator creates plain classes with `toJson`/`fromJson` — use freezed for domain models, generated for API DTOs |
| `result_dart` | ✅ Compatible | Wrap raw generated models with `Result` at call site |
| `build_runner` | ✅ Already present | Required by the generator |
