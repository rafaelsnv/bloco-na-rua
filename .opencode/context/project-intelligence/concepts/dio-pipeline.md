<!-- Context: project-intelligence/concepts/dio-pipeline | Priority: high | Version: 1.0 | Updated: 2026-07-02 -->

# Dio Pipeline — Interceptor Chain

**Core Concept**: Every HTTP request flows through TWO interceptors in order: `DioErrorInterceptor` (normalizes errors) → `PrettyDioLogger` (dev-time logs). Errors surface as `ApiError` with pt-BR user messages.

---

## Order Matters

```dart
final client = Dio(opts);
client.interceptors.add(DioErrorInterceptor());   // FIRST
client.interceptors.add(PrettyDioLogger(...));    // SECOND (dev only)
```

**Why this order**:
1. `DioErrorInterceptor` wraps raw `DioException` to add context, then rethrows
2. `PrettyDioLogger` sees the wrapped exception + the response (or null)
3. Repositories catch `DioException` and call `ApiError.fromDioException`

If reversed, the logger would log raw errors before translation.

---

## Where Errors Surface

```
Network → DioException
        → DioErrorInterceptor (adds context, logs warning, rethrows)
          → PrettyDioLogger (dev: prints to console)
            → Repository catches:
                try { ... }
                on DioException catch (e) {
                  return Failure(ApiError.fromDioException(e));
                }
              → UseCase sees AsyncResult<T> with Failure
                → Cubit emits status: failure + errorMessage = ApiError.userMessage
                  → Screen displays it
```

---

## `DioErrorInterceptor` (sketch)

```dart
class DioErrorInterceptor extends Interceptor {
  final _log = Logger('DioErrorInterceptor');

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _log.warning('${err.requestOptions.method} ${err.requestOptions.path} '
        'failed: ${err.type} ${err.message}');
    handler.next(err);   // continue with wrapped error
  }
}
```

---

## `ApiError.fromDioException` Decision Tree

```
DioException.type
├── connectionTimeout | sendTimeout | receiveTimeout
│   → ApiError(type: ApiErrorType.timeout, userMessage: "Conexão lenta...")
├── connectionError
│   → ApiError(type: network, userMessage: "Sem conexão com a internet...")
├── badResponse
│   → ApiError.fromResponse(exception.response)
│       ├── 400 → ApiError(type: validation, userMessage: "Dados inválidos...")
│       ├── 401 → ApiError(type: auth, userMessage: "Sessão expirada...")
│       ├── 403 → ApiError(type: auth, userMessage: "Sem permissão...")
│       ├── 404 → ApiError(type: notFound, userMessage: "Recurso não encontrado...")
│       ├── 503 → ApiError(type: server, userMessage: "Servidor indisponível...")
│       └── 5xx → ApiError(type: server, userMessage: "Erro no servidor...")
├── cancel
│   → ApiError(type: unknown, userMessage: "Algo inesperado...")
├── badCertificate
│   → ApiError(type: network, userMessage: "Sem conexão...")
└── unknown (SocketException or ConnectionRefused in message)
    → ApiError(type: network, ...)
```

See `examples/dio-error-translation.dart` for the full source.

---

## Key Points

1. **`ApiError.userMessage`** is what the UI shows — pt-BR string
2. **`ApiError.technicalMessage`** is what the logger logs
3. **`ApiError.statusCode`** — preserved for client-side handling (e.g., 401 → logout)
4. **Never let a `DioException` escape a repository** — always translate first
5. **`validateStatus` on BaseOptions** allows 4xx without throwing — useful for "expected" 404s

---

## Debugging Tips

```dart
// In a Cubit, log the typed error:
_log.warning('Failed to load', error);
emit(state.copyWith(
  status: HomeStatus.failure,
  errorMessage: error is ApiError
    ? error.userMessage
    : error.toString(),
));

// In a Repository, log before translating:
_log.warning('getByBlock($id) → ${e.type} (${e.response?.statusCode})', e);
```

---

## Reference

- `core/api_error.dart` — `ApiError` class + factories
- `core/error_types.dart` — `ApiErrorType` enum
- `core/error_messages.dart` — pt-BR strings
- `data/services/api/base/dio_error_interceptor.dart`
- `data/services/api/base/base_api_client.dart`
- `examples/dio-error-translation.dart`
- `errors/dio-supabase-errors.md` — common gotchas
