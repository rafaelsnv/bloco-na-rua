<!-- Context: project-intelligence/lookup/naming-conventions | Priority: medium | Version: 3.0 | Updated: 2026-07-02 -->

# Naming Conventions — Quick Reference

**Snip from `technical-naming.md`** for grep-friendly use.

| Type | Convention | Example |
|------|------------|---------|
| Files | `snake_case.dart` | `home_cubit.dart` |
| Folders | **camelCase** (not snake_case) | `carnivalBlock`, `meetingPresences` |
| Classes | PascalCase | `HomeCubit` |
| Entities | PascalCase + Entity | `CarnivalBlocksEntity` |
| Interfaces | PascalCase + `I` prefix | `IMeetingsRepository` |
| State classes | PascalCase + State | `HomeState` |
| State enums | PascalCase + Status | `HomeStatus` (values: camelCase) |
| Cubit classes | PascalCase + Cubit | `HomeCubit` |
| Use cases | PascalCase + UseCase | `GetHomeDataUseCase` |
| Screen widgets | PascalCase + Screen | `HomeScreen` |
| Variables | camelCase | `userCount` |
| Constants | camelCase (NO `k` prefix) | `baseOptions` |
| Private fields | `_camelCase` | `_membersRepo` |
| Enum values | camelCase | `HomeStatus.loading` |
| Route constants | `Routes.x` (camelCase) | `Routes.userMeetings` |
| Path params | camelCase | `:blockId` |
| Routes (paths) | kebab-case or `/` | `/`, `/login`, `/meeting-presences` |

## Quote Style

Use double quotes in Dart: `"text"` (not `'text'`).

## Related

- `technical-naming.md` — full version with examples and bad/good
- `technical-domain.md` — layer responsibilities
