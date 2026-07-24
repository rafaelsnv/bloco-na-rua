<!-- Context: project-intelligence/concepts/freezed-entity | Priority: high | Version: 1.0 | Updated: 2026-07-02 -->

# Freezed Entities — `@freezed sealed class`

**Core Concept**: Domain entities use `@freezed sealed class` with JSON serialization to get `copyWith`, `==`, `fromJson` for free. Every entity extends `EntityBase` for `id`, `createdAt`, `updatedAt`.

---

## Canonical Example: `CarnivalBlocksEntity`

```dart
import 'package:bloco_na_rua/core/entity_base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'carnival_blocks_entity.freezed.dart';
part 'carnival_blocks_entity.g.dart';

@freezed
sealed class CarnivalBlocksEntity extends EntityBase
    with _$CarnivalBlocksEntity {
  @override
  final int ownerId;
  @override
  final String name;
  @override
  final String inviteCode;
  @override
  final String managersInviteCode;
  @override
  final String carnivalBlockImage;

  CarnivalBlocksEntity._({
    required this.ownerId,
    required this.name,
    required this.inviteCode,
    required this.managersInviteCode,
    required this.carnivalBlockImage,
    required super.id,
  }) : super();

  factory CarnivalBlocksEntity({
    required int id,
    required int ownerId,
    required String name,
    required String managersInviteCode,
    required String carnivalBlockImage,
    required String inviteCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CarnivalBlocksEntity;

  factory CarnivalBlocksEntity.fromJson(Map<String, dynamic> json) =>
      _$CarnivalBlocksEntityFromJson(json);
}
```

---

## File Triplet (Required)

```
lib/domain/entities/carnivalBlock/
├── carnival_blocks_entity.dart         # source (you edit)
├── carnival_blocks_entity.freezed.dart # generated (do NOT edit)
└── carnival_blocks_entity.g.dart       # generated (do NOT edit)
```

---

## Generate After Editing

```bash
dart run build_runner build --delete-conflicting-outputs

# Or, for code-watch during dev:
dart run build_runner watch --delete-conflicting-outputs
```

---

## `EntityBase` Base Class

All entities share these fields via `lib/core/entity_base.dart`:

```dart
typedef JsonFactory<T> = T Function(Map<String, dynamic> json);

abstract class EntityBase {
  EntityBase({required this.id, this.createdAt, this.updatedAt});
  final int id;
  DateTime? createdAt;
  DateTime? updatedAt;
}
```

So every entity has `id` (required), `createdAt`, `updatedAt` (optional).

---

## Repository Base Contract

```dart
abstract interface class IRepositoryBase<TEntity extends EntityBase> {
  AsyncResult<List<TEntity>> getAllAsync();
  AsyncResult<TEntity> getByIdAsync(int id);
  AsyncResult deleteByIdAsync(int id);
  AsyncResult<TEntity> createAsync(Map<String, dynamic> data);
}
```

Implementing repos get free CR(U)D — just override for their entity.

---

## Variants with `sealed` Unions

For state machines (e.g., meeting status), use multiple factory constructors:

```dart
@freezed
sealed class MeetingsEntity extends EntityBase with _$MeetingsEntity {
  MeetingsEntity._({required super.id}) : super();

  factory MeetingsEntity.scheduled({...}) = Scheduled;
  factory MeetingsEntity.completed({...}) = Completed;
  factory MeetingsEntity.cancelled({...}) = Cancelled;
}
```

Consume with `switch (meeting) { ... }` for exhaustive matching.

---

## Key Points

1. **Always extend `EntityBase`** — keeps `id` consistent
2. **`@override` on top of base fields** — required by freezed
3. **`CarnivalBlocksEntity._({...}) : super()`** private constructor — enforced by codegen
4. **`fromJson` is auto-generated** — just provide the factory signature
5. **`freezed` + `json_serializable` work together** — keep BOTH packages in sync

---

## Gotchas

| Gotcha                                                       | Fix                                                      |
| ------------------------------------------------------------ | -------------------------------------------------------- |
| Forgot to run `build_runner` after edit                       | Run: `dart run build_runner build --delete-conflicting-outputs` |
| Field defaults to nullable                                    | Make it required in factory, optional in private ctor    |
| Stale `.freezed.dart` after rename                            | Delete the `.freezed.dart` + `.g.dart`, re-run           |
| JSON key mismatch (snake_case vs camelCase)                   | Add `@JsonKey(name: 'snake_case_key')` to the field       |
| Cannot serialize `DateTime`                                   | It's auto-handled by `json_serializable`                  |
| Sealed union + no exhaustiveness                              | Add `default` branch or fix the `switch`                  |

---

## Reference

- `core/entity_base.dart`
- `core/irepository_base.dart`
- `domain/entities/{carnivalBlock, meetings, members, ...}/`
- `lookup/entities.md` — all entities
- `decisions-log.md` — why freezed over manual classes
