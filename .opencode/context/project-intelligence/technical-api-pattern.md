<!-- Context: project-intelligence/technical-api-pattern | Priority: critical | Version: 3.0 | Updated: 2026-07-02 -->

# API Pattern — Dio (REST) + Supabase (Auth)

**Core Concept**: Hybrid backend. Dio REST handles business entities. Supabase handles ONLY authentication. A custom interceptor chain translates Dio errors to a typed `ApiError` with pt-BR user messages.

---

## Two Backends, One App

| Concern        | Backend                  | Library           | File(s)                                          |
| -------------- | ------------------------ | ----------------- | ------------------------------------------------ |
| Authentication | Supabase                  | `supabase_flutter` | `data/services/auth/auth_api_client.dart`        |
| Business CRUD  | Custom REST API           | `dio`              | `data/services/api/{feature}/`                   |
| Token storage  | Local                      | `shared_preferences` | `data/services/shared_preferencies_service.dart` |

**NEVER** use Supabase client for business entities — only for auth.

---

## HTTP Pipeline

```
[UseCase]
    ↓
[Repository]
    ↓  ← AsyncResult<T>
[ApiClient]
    ↓  ← returns entity or DioException
[BaseApiClient]
    ↓  ← wraps Dio factory
[Dio] ──→ [DioErrorInterceptor] ──→ [PrettyDioLogger (dev)]
    ↓
[Network]
```

### 1. BaseApiClient (singleton, lib/data/services/api/base/base_api_client.dart)

```dart
class BaseApiClient implements IBaseApiClient {
  BaseApiClient({
    required this.clientFactory,
    required this.options,
  });

  final Dio Function(BaseOptions options) clientFactory;
  final BaseOptions options;
  late final Dio _dio = clientFactory(options);

  @override
  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? query}) =>
    _dio.get<T>(path, queryParameters: query);

  @override
  Future<Response<T>> post<T>(String path, {dynamic data}) =>
    _dio.post<T>(path, data: data);

  // ... put, delete, patch
}
```

### 2. DioErrorInterceptor

Wraps all `DioException`s to add context, then rethrows so the ApiClient can call `ApiError.fromDioException`.

### 3. PrettyDioLogger

Dev-only — logs request/response bodies in console. Strip in production builds.

---

## Repository → ApiClient Pattern

```dart
// lib/data/repositories/meetings/meetings_repository.dart
class MeetingsRepository implements IMeetingsRepository {
  MeetingsRepository({required IMeetingsApiClient meetingsApiClient})
      : _api = meetingsApiClient;

  final IMeetingsApiClient _api;

  @override
  AsyncResult<List<MeetingsEntity>> getByBlock(int blockId) async {
    try {
      final meetings = await _api.getByBlock(blockId);
      return Success(meetings);
    } on DioException catch (e) {
      _log.warning('getByBlock failed for $blockId', e);
      return Failure(ApiError.fromDioException(e));
    } catch (e) {
      _log.severe('Unexpected error in getByBlock', e);
      return Failure(e is Exception ? e : Exception(e.toString()));
    }
  }
}
```

---

## ApiClient Pattern (per entity)

```dart
// lib/data/services/api/meetings/meetings_api_client.dart
class MeetingsApiClient implements IMeetingsApiClient {
  MeetingsApiClient(this._base);

  final IBaseApiClient _base;

  @override
  Future<List<MeetingsEntity>> getByBlock(int blockId) async {
    final response = await _base.get<dynamic>('/meetings', query: {'block': blockId});
    final data = response.data as List;
    return data
      .map((j) => MeetingsEntity.fromJson(j as Map<String, dynamic>))
      .toList();
  }
}
```

---

## Supabase Auth (separate)

```dart
// lib/data/services/auth/auth_api_client.dart
class AuthApiClient {
  AuthApiClient({required SupabaseClient supabaseClient})
      : _supabase = supabaseClient;

  final SupabaseClient _supabase;

  Future<AuthResponse> signIn(String email, String password) =>
    _supabase.auth.signInWithPassword(email: email, password: password);

  Future<AuthResponse> signUp(String email, String password) =>
    _supabase.auth.signUp(email: email, password: password);

  Future<void> signOut() => _supabase.auth.signOut();

  Session? get currentSession => _supabase.auth.currentSession;
}
```

---

## Error Translation (ApiError)

`DioException` → `ApiError` via factory:

```dart
factory ApiError.fromDioException(DioException exception) {
  switch (exception.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return ApiError(
        type: ApiErrorType.timeout,
        userMessage: ErrorMessages.timeout,
        technicalMessage: exception.message,
        statusCode: exception.response?.statusCode,
      );
    case DioExceptionType.badResponse:
      return ApiError.fromResponse(exception.response);
    // ... other types
  }
}
```

See `concepts/dio-pipeline.md` for the full decision tree.

---

## Key Points

1. **`DioErrorInterceptor` is the FIRST interceptor** — converts raw exceptions
2. **`pretty_dio_logger` second** — observes logged translation
3. **All `get/post/put/delete` go through `BaseApiClient`** — never instantiate `Dio` inline
4. **Repositories catch `DioException`** and translate to `ApiError`
5. **Supabase is exempt** from this pipeline (it has its own client)

---

## Reference

- `concepts/dio-pipeline.md` — interceptor chain details
- `concepts/freezed-entity.md` — JSON parsing
- `concepts/result-handling.md` — AsyncResult pattern
- `examples/dio-error-translation.dart` — full translation example
- `errors/dio-supabase-errors.md` — common failures
