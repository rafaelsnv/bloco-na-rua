<!-- Context: standards/overrides | Priority: critical | Version: 1.0 | Updated: 2026-07-03 -->

# Standards Overrides

> Local project decisions that override global defaults. Document the **what**, **why**, and **where to find** the authoritative local reference.

## Quick Reference

| Override # | Topic | Global Default | Local Decision | Authority | Date |
| ---------- | ----- | -------------- | -------------- | --------- | ---- |
| 1 | Cubit UI State Pattern | `sealed class XxxState extends Equatable` | Plain `Equatable` + `enum Status`; `@freezed sealed` only for sealed unions with payload variants | Local `bloc-state-pattern.md` + `decisions-log.md` | 2026-07-02 |

---

## Override 1: Cubit UI State Pattern (CRITICAL)

### Global Default

**Source**: `~/.config/opencode/context/core/standards/dart.md` (lines 47–61)

```dart
sealed class CreateEntityState extends Equatable {
  const CreateEntityState();
}
final class CreateEntityInitial extends CreateEntityState {}
final class CreateEntityLoading extends CreateEntityState {}
final class CreateEntitySuccess extends CreateEntityState {
  final UserEntity entity;
  const CreateEntitySuccess(this.entity);
}
final class CreateEntityError extends CreateEntityState {
  final String message;
  const CreateEntityError(this.message);
}
```

**Pattern**: Sealed class hierarchy as the default for all Cubit state classes.

### Local Decision (AUTHORITY: LOCAL WINS)

**Source**: `.opencode/context/project-intelligence/concepts/bloc-state-pattern.md` (lines 1–27, v1.1)
**Rationale**: `.opencode/context/project-intelligence/decisions-log.md` §"Plain Class UI States" (revised 2026-07-02)

**Default** (applies to most cubits):
- Plain `class XxxState extends Equatable`
- `enum Status { initial, loading, success, failure }` carries phase
- Manual `copyWith` for immutable updates
- No code generation required

**Exception** (narrow — sealed unions with payload-carrying variants):
- `@freezed sealed class` permitted when state is a genuine union with payload variants (e.g., `_Loaded(MembersEntity)`, `_Error(String message)`)
- Rationale: union pattern expresses variants more clearly than nested nullable fields; scope limited to ProfileCubit and similar

**Avoided**: Freezed for flat/single-state cubits — adds codegen overhead with no benefit.

**Revision note (2026-07-02)**: Two existing cubits (`ProfileCubit`, `MeetingPresencesCubit`) already used freezed for UI state; rather than re-implement them, the decision was revised to formally permit freezed for union-shaped states. See `decisions-log.md` lines 66–93 for full audit table and rationale.

### Why Local Wins

Global default assumes sealed classes are the best default for all cubits. In this project, most cubit UI states are **flat** — a `Status` enum + one nullable data field. For flat states, sealed hierarchies add:
- Code-generation boilerplate (`build_runner` + freezed)
- Slower rebuilds (more object allocations)
- Harder to log/debug (nested class instantiation)

Plain `Equatable` + `enum Status` is simpler, debuggable, and sufficient. The sealed-class approach is reserved for genuine union shapes where the variant distinction carries meaning.

### Authoritative References

| Ref | File | Key Lines |
|-----|------|-----------|
| Local decision | `project-intelligence/concepts/bloc-state-pattern.md` | Lines 1–27 (decision tree + core concept) |
| Rationale | `project-intelligence/decisions-log.md` | Lines 66–93 (Plain Class UI States, revised 2026-07-02) |
| Examples | `project-intelligence/examples/state-pattern.md` | Lines 100–110 (freezed exception usage) |
| Global default | `~/.config/opencode/context/core/standards/dart.md` | Lines 47–61 (sealed class pattern) |

---

## Future Overrides

No additional conflicts identified at merge time. If future local decisions diverge from global defaults, add them above using the same schema (Override #, Topic, Global Default, Local Decision, Authority, Date).

---

## Related Files

- **Decision tree**: `project-intelligence/concepts/bloc-state-pattern.md`
- **Decision rationale**: `project-intelligence/decisions-log.md` §"Plain Class UI States"
- **Global default (sealed class)**: `~/.config/opencode/context/core/standards/dart.md` §State Pattern
- **Global state management (to sanitize)**: `standards/flutter-state-management.md`
- **Examples**: `project-intelligence/examples/state-pattern.md`
