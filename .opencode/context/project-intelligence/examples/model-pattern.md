<!-- Context: project-intelligence/examples/model-pattern | Priority: high | Version: 2.0 | Updated: 2026-11-17 -->

# Entity Pattern Example

**Core Concept**: Domain entities are Freezed sealed classes extending `EntityBase`, with JSON deserialization generated via `_$XFromJson` codegen. Model on `MeetingsEntity`.

---

## Entity Definition

```dart
@freezed
sealed class MeetingEntity extends EntityBase with _$MeetingEntity {
  const factory MeetingEntity({
    required String id,
    required String title,
    required DateTime startsAt,
    String? location,
  }) = _MeetingEntity;

  factory MeetingEntity.fromJson(Map<String, dynamic> json) =>
      _$MeetingEntityFromJson(json);
}
```

---

## Generated Files

Run `dart run build_runner build` after edits:

| File | Purpose |
|------|---------|
| `meetings_entity.freezed.dart` | sealed class, copyWith, equality |
| `meetings_entity.g.dart` | `_$MeetingEntityFromJson` / toJson |

---

## Key Points

1. `@freezed sealed class ... extends EntityBase` — every entity follows this shape
2. `const factory` constructor defines fields; Freezed generates `copyWith` + equality
3. `fromJson` factory delegates to generated `_$XFromJson` — never hand-write JSON parsing
4. Entities live per-domain subfolder, e.g. `lib/domain/entities/meetings/`
5. Repositories map API responses to these entities (see `technical-api-pattern.md`)

---

## Reference

- Full example: `lib/domain/entities/meetings/meetings_entity.dart`
- Codebase entities: `lib/domain/entities/`
- State layer: `examples/state-pattern.md`
