<!-- Context: project-intelligence/examples/state-pattern | Priority: high | Version: 3.1 | Updated: 2026-07-02 -->

# State Pattern — Cubit + Equatable + copyWith

**Core Concept**: Each Cubit holds a plain Equatable state with an `enum Status` for loading phases. NOT sealed/freezed — keep it boring, predictable, and easy to debug.

---

## Canonical Example: HomeState

**File**: `lib/ui/home/cubit/home_state.dart`

```dart
import 'package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart';
import 'package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart';
import 'package:equatable/equatable.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.blocks = const [],
    this.meetings = const [],
    this.errorMessage,
  });

  final HomeStatus status;
  final List<CarnivalBlocksEntity> blocks;
  final List<MeetingsEntity> meetings;
  final String? errorMessage;

  HomeState copyWith({
    HomeStatus? status,
    List<CarnivalBlocksEntity>? blocks,
    List<MeetingsEntity>? meetings,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      blocks: blocks ?? this.blocks,
      meetings: meetings ?? this.meetings,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, blocks, meetings, errorMessage];
}
```

---

## Cubit Usage Pattern

```dart
class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required GetHomeDataUseCase getHomeDataUseCase})
      : _getHomeDataUseCase = getHomeDataUseCase,
        super(const HomeState());

  Future<void> loadHomeData() async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final results = await Future.wait([
        _getHomeDataUseCase.getCarnivalBlocks(),
        _getHomeDataUseCase.getMeetings(),
      ]);

      if (results.any((r) => r.isError())) {
        final err = results.firstWhere((r) => r.isError()).exceptionOrNull();
        emit(state.copyWith(
          status: HomeStatus.failure,
          errorMessage: _extractUserMessage(err),
        ));
        return;
      }

      emit(state.copyWith(
        status: HomeStatus.success,
        blocks: results[0].getOrNull() ?? [],
        meetings: results[1].getOrNull() ?? [],
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.failure,
        errorMessage: _extractUserMessage(e),
      ));
    }
  }

  String _extractUserMessage(Object? error) {
    if (error is ApiError) return error.userMessage;
    return error?.toString() ?? 'Erro desconhecido';
  }
}
```

---

## Key Points

1. **Plain class with `enum Status`** — easy to read, no codegen needed (DEFAULT for most cubits)
2. **`copyWith`** manually — keeps state file <100 lines
3. **`Equatable.props`** — list ALL fields, otherwise updates don't trigger rebuilds
4. **Error translation** — translate `ApiError` → user-facing pt-BR string in cubit
5. **Freezed for UI states only when state is a sealed union with payload variants** (e.g. `_Loaded(data)`, `_Error(msg)`). For plain `enum Status` + nullable data, stick to plain Equatable. See `decisions-log.md` §"Plain Class UI States" (Revised 2026-07-02).

---

## Anti-Patterns

- ❌ Don't use freezed for single-state / flat cubit states (codegen with no benefit)
- ✅ Freezed IS appropriate when state is a sealed union with payload-carrying variants (e.g. `ProfileState._Loaded(member)`, `MeetingPresencesState._Yes/_No/_Maybe`)
- ❌ Don't pass `null` to `copyWith` to "clear" — make a separate `clearX()` method
- ❌ Don't store Cubits in singletons — create via `BlocProvider(create: ...)`

---

## When to Add a Field

Ask: "Does the UI distinguish between two states with only this field changing?"

```
Initial → Loading → Success → Failure
                   ↓
            + side data (blocks, meetings)
                   ↓
            + error info (errorMessage)
```

If yes → add to state. If no → keep in the Cubit as a private field.

---

## Reference

- `concepts/bloc-state-pattern.md` — deeper theory + decision tree
- `examples/home-feature-flow.md` — end-to-end
- `lookup/cubits.md` — all cubits in the project
- `errors/common-errors.md` — state-update pitfalls
