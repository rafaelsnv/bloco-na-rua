<!-- Context: project-intelligence/concepts/result-handling | Priority: high | Version: 1.0 | Updated: 2026-07-02 -->

# Result Handling — `AsyncResult<T>`

**Core Concept**: Every async operation in the data/domain layers returns `AsyncResult<T>` (= `Future<Result<T>>`). Cubits inspect `.isSuccess()` / `.isError()` instead of try/catching.

---

## The Type

From `package:result_dart`:
```dart
typedef AsyncResult<T> = Future<Result<T>>;

sealed class Result<T> {
  bool get isSuccess();
  bool get isError();
  T? getOrNull();
  Exception? exceptionOrNull();
}

class Success<T>(T value) extends Result<T>;
class Failure<T>(Exception exception) extends Result<T>;
```

**Why**: Force every consumer to consider BOTH success and failure paths at compile time.

---

## Producer Pattern (Repository / UseCase)

```dart
@override
AsyncResult<List<MeetingsEntity>> getByBlock(int blockId) async {
  try {
    final list = await _api.getByBlock(blockId);
    return Success(list);
  } on DioException catch (e) {
    _log.warning('getByBlock($blockId) failed', e);
    return Failure(ApiError.fromDioException(e));
  } catch (e) {
    return Failure(Exception(e.toString()));
  }
}
```

**Rules**:
1. ALWAYS return `AsyncResult<T>`, never `Future<T>` directly
2. Translate known exceptions (`DioException` → `ApiError`)
3. Wrap unknown exceptions in `Failure(Exception(...))`

---

## Consumer Pattern (Cubit)

```dart
final result = await _useCase.invoke();

if (result.isError()) {
  emit(state.copyWith(
    status: Status.failure,
    errorMessage: _extractUserMessage(result.exceptionOrNull()),
  ));
  return;
}

emit(state.copyWith(
  status: Status.success,
  data: result.getOrNull() ?? <default>,
));
```

---

## Parallel Pattern (`Future.wait`)

```dart
final results = await Future.wait([
  _useCase1.call(),
  _useCase2.call(),
]);

if (results.any((r) => r.isError())) {
  final err = results.firstWhere((r) => r.isError()).exceptionOrNull();
  emit(state.copyWith(
    status: Status.failure,
    errorMessage: _extractUserMessage(err),
  ));
  return;
}

final blocks = results[0].getOrNull() ?? [];
final meetings = results[1].getOrNull() ?? [];
```

---

## Chain Pattern

```dart
final userDataResult = await _getCurrentUserData();
if (userDataResult.isError()) return Failure(userDataResult.exceptionOrNull()!);
final userId = userDataResult.getOrNull()!.id;

final blocksResult = await _membersRepo.getBlocksByMemberId(userId);
if (blocksResult.isError()) return Failure(blocksResult.exceptionOrNull()!);
return blocksResult;   // already an AsyncResult
```

---

## Key Points

1. **Use `Result.failure(e)` if `e` is an `Exception`**; use `Success(value)` for value
2. **`isError()` is the canonical check** — not `exceptionOrNull() != null`
3. **`getOrNull()` returns `T?`** — combine with `?? defaultValue` to keep flow linear
4. **Don't catch in UseCase THEN wrap in `Future.error`** — just return `Failure(...)`
5. **Don't let Exceptions escape data/domain layer** — only Cubits can `try/catch` for translation

---

## Common Mistakes

| Mistake                                                  | Why it's wrong                              |
| -------------------------------------------------------- | ------------------------------------------- |
| `try { return await _api.call(); } catch { return Success([]); }` | Swallows errors; UI never knows |
| `final result = await _useCase(); result.fold((s) => ..., (e) => ...)` | `fold` is for `Either` types, not `Result` |
| `await _useCase() ?? defaultValue`                        | Returns the Future itself, not the value    |
| Returning `T` directly from a repository                  | Breaks contract; UI can't handle errors     |

---

## Reference

- `result_dart` package: https://pub.dev/packages/result_dart
- `core/irepository_base.dart` — `AsyncResult<List<T>>` contract
- `domain/use_cases/home/get_home_data_use_case.dart` — canonical
- `examples/home-feature-flow.md` — end-to-end
- `concepts/dio-pipeline.md` — error translation upstream
