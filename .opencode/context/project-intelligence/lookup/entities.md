<!-- Context: project-intelligence/lookup/entities | Priority: high | Version: 1.0 | Updated: 2026-07-02 -->

# Entities Catalog

**Core Concept**: 5 freezed entities, all extending `EntityBase`. Each lives in `lib/domain/entities/{feature}/` with the `entity.dart` source + 2 generated files.

---

## Table

| Entity                            | Folder                                | Key Fields                                                |
| --------------------------------- | ------------------------------------- | --------------------------------------------------------- |
| `CarnivalBlocksEntity`              | `entities/carnivalBlock/`              | ownerId, name, inviteCode, managersInviteCode, image     |
| `CarnivalBlockMembersEntity`        | `entities/carnivalBlockMembers/`       | (join entity) carnivalBlockId, memberId, role            |
| `MeetingsEntity`                    | `entities/meetings/`                   | meetingDateTime, location, title, blockId                 |
| `MembersEntity`                     | `entities/members/`                    | name, email, phone, createdAt, updatedAt                 |
| `MeetingPresencesEntity`            | `entities/meetingPresences/`           | memberId, meetingId, status (RSVP)                         |

---

## `CarnivalBlocksEntity`

**File**: `lib/domain/entities/carnivalBlock/carnival_blocks_entity.dart`

```dart
@freezed
sealed class CarnivalBlocksEntity extends EntityBase
    with _$CarnivalBlocksEntity {
  // Inherits: id, createdAt, updatedAt
  final int ownerId;
  final String name;
  final String inviteCode;
  final String managersInviteCode;
  final String carnivalBlockImage;
}
```

---

## `CarnivalBlockMembersEntity`

Join table between a CarnivalBlock and a Member, with a role.

| Role | Meaning                              |
| ---- | ------------------------------------ |
| 0    | Member                                |
| 1    | Manager (managersInviteCode path)     |

---

## `MeetingsEntity`

| Field              | Type    | Notes                          |
| ------------------ | ------- | ------------------------------ |
| `meetingDateTime`   | String? | ISO 8601 → `DateTime.parse`    |
| `location`          | String? | Free-form address              |
| `title`             | String? | Display title                  |
| `blockId`           | int     | FK to CarnivalBlocksEntity     |

---

## `MembersEntity`

Stored after successful sign-in. Used for `GetCurrentUserData`.

---

## `MeetingPresencesEntity`

RSVP per (member, meeting). `status` is a 3-state enum (planned):
- 0 = pending / not responded
- 1 = yes
- 2 = no

---

## Adding a New Entity

1. Create folder `lib/domain/entities/{feature}/`
2. Add `{feature}_entity.dart` with `@freezed sealed class XxxEntity extends EntityBase`
3. Add `factory XxxEntity.fromJson(Map<String, dynamic> json)` factory
4. Run: `dart run build_runner build --delete-conflicting-outputs`
5. Update this catalog
6. Update `business-tech-bridge.md`

---

## Reference

- `core/entity_base.dart` — base class
- `concepts/freezed-entity.md` — full pattern
- `business-tech-bridge.md` — which entities drive which features
