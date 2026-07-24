<!-- Context: project-intelligence/guides/error-to-user-message | Priority: high | Version: 1.0 | Updated: 2026-07-02 -->

# Guide — Error → User Message Translation

**Core Concept**: Every error eventually becomes a pt-BR string. The translation pipeline: `DioException` → `ApiError.userMessage` → `Cubit.errorMessage` → UI text. Use this guide when adding new error types or error UI.

---

## The Pipeline

```
Network failure
  ↓
DioException (raw)
  ↓
DioErrorInterceptor (logs context)
  ↓
Repository catches → ApiError.fromDioException(e)
  ↓
UseCase sees AsyncResult.failure(ApiError)
  ↓
Cubit reads exceptionOrNull() → emits errorMessage
  ↓
Screen shows text widget with the string
```

---

## Where Translations Live

| File                                  | Contains                                       |
| ------------------------------------- | ---------------------------------------------- |
| `lib/core/error_messages.dart`        | The actual pt-BR strings                       |
| `lib/core/error_types.dart`           | `ApiErrorType` enum                             |
| `lib/core/api_error.dart`             | `ApiError.fromDioException` + `fromResponse`     |

---

## Adding a New Error Type

### Step 1: Add to `ApiErrorType` enum

```dart
enum ApiErrorType {
  network,
  timeout,
  server,
  auth,
  validation,
  notFound,
  rateLimited,    // ← new
  unknown,
}
```

### Step 2: Add a translation string

```dart
// lib/core/error_messages.dart
class ErrorMessages {
  ErrorMessages._();
  // ... existing ...
  static const rateLimited =
    'Muitas requisições. Aguarde alguns segundos.';
}
```

### Step 3: Add the factory case

```dart
// lib/core/api_error.dart
factory ApiError.fromResponse(Response? response) {
  // ... existing ...
  switch (statusCode) {
    // ... existing ...
    case 429:
      return ApiError(
        type: ApiErrorType.rateLimited,
        userMessage: ErrorMessages.rateLimited,
        technicalMessage: response?.statusMessage ?? '',
        statusCode: statusCode,
      );
    // ...
  }
}
```

### Step 4: Update `core/error_types.dart` reference docs

Add a doc comment for the new variant.

---

## Adding a New DioException Type

If Dio introduces a new `DioExceptionType`:

```dart
factory ApiError.fromDioException(DioException exception) {
  switch (exception.type) {
    // ... existing ...
    case DioExceptionType.connectionProxy:
      return ApiError(
        type: ApiErrorType.network,
        userMessage: ErrorMessages.network,
        technicalMessage: exception.message,
      );
  }
}
```

---

## Cubit Helper

A common pattern in cubits:

```dart
String _extractUserMessage(Object? error) {
  if (error == null) return 'Erro desconhecido';
  if (error is ApiError) return error.userMessage;
  if (error is Exception) {
    final msg = error.toString();
    if (msg.startsWith('Exception: ')) return msg.substring(11);
    return msg;
  }
  return error.toString();
}
```

**Use this** in every cubit that takes an `AsyncResult` and emits a status.

---

## UI Display Pattern

```dart
BlocBuilder<MyCubit, MyState>(
  builder: (context, state) {
    switch (state.status) {
      case HomeStatus.failure:
        return ErrorView(message: state.errorMessage ?? 'Erro');
      // ...
    }
  },
),
```

```dart
class ErrorView extends StatelessWidget {
  const ErrorView({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}
```

---

## Anti-Patterns

| Anti-Pattern                                            | Why wrong                                  |
| ------------------------------------------------------- | ----------------------------------------- |
| Show `e.toString()` directly to user                     | Exposes stack traces, not localized       |
| Embed strings in Cubit instead of ErrorMessages          | Inconsistent, hard to translate          |
| Skip Cubit and emit error from UseCase                   | UI must observe Cubit state only           |
| Use English error messages in pt-BR UI                   | Breaks UX                                  |
| Forget to add `'Exception: '` prefix strip                | "Exception: Network unreachable" ugly      |

---

## Reference

- `lib/core/api_error.dart` — translation factories
- `lib/core/error_messages.dart` — pt-BR strings
- `lib/core/error_types.dart` — type enum
- `examples/dio-error-translation.dart` — full source
- `concepts/dio-pipeline.md` — interceptor chain
- `errors/dio-supabase-errors.md` — common gotchas
