<!-- Context: project-intelligence/technical-naming | Priority: high | Version: 1.0 | Updated: 2026-05-17 -->

# Naming Conventions

**Purpose**: Complete naming conventions for Flutter/Dart projects.
**Audience**: AI agents generating Flutter/Dart code

## File Naming

| Type | Convention | Example |
|------|------------|---------|
| Regular files | snake_case | `entity_repository.dart` |
| Folders | kebab-case | `entity/edit/` |
| Test files | `*_test.dart` | `create_entity_cubit_test.dart` |
| Generated files | `*.freezed.dart`, `*.g.dart` | `user_entity.freezed.dart` |

## Class Naming

| Type | Convention | Example |
|------|------------|---------|
| Classes | PascalCase | `EntityRepository` |
| Entities | PascalCase + Entity suffix | `UserEntity` |
| Interfaces | PascalCase + `I` prefix | `IEntityRepository` |
| State classes | PascalCase + State suffix | `CreateEntityState` |
| State variants | sealed + final classes | `CreateEntitySuccess` |
| Cubit classes | PascalCase + Cubit suffix | `CreateEntityCubit` |
| Screen widgets | PascalCase + Screen suffix | `CreateEntityScreen` |
| Extensions | PascalCase + Extension suffix | `StringExtension` |

## Member Naming

| Type | Convention | Example |
|------|------------|---------|
| Functions | verbPhrase (camelCase) | `getUserById` |
| Predicates | is/has/can prefix | `isValid`, `hasPermission` |
| Variables | descriptive (camelCase) | `userCount` not `uc` |
| Constants | camelCase + k prefix | `kApiBaseUrl` |
| Private fields | _camelCase | `_repo`, `_entityId` |
| Enums | PascalCase | `UserRole.admin` |
| Enum values | UPPER_SNAKE_CASE | `UserRole.admin` |

## Code Examples

```dart
// ✅ Correct
class UserEntity extends EntityBase { ... }
interface IUserRepository { ... }
sealed class UserState extends Equatable { ... }
final class UserLoaded extends UserState { ... }
class UserCubit extends Cubit<UserState> { ... }
static const kDefaultPageSize = 20;

// ❌ Incorrect
class user_entity { }           // Should be PascalCase
class userRepository { }        // Should be PascalCase
const MAX_SIZE = 100;           // Should be kPrefix
```

## Routes Naming

| Type | Convention | Example |
|------|------------|---------|
| Route constants | camelCase | `routes.login` |
| Route paths | kebab-case | `/user-profile` |
| Route params | camelCase | `:entityId` |

## 📂 Codebase References

**Entities**: `lib/domain/entities/`
**Repositories**: `lib/data/repositories/`
**States**: `lib/domain/states/`
**Cubits**: `lib/domain/cubits/`
**Screens**: `lib/ui/screens/`
**Routes**: `lib/ui/router/routes.dart`

## Related Files

- `technical-domain.md` - Entry point
- `technical-component-pattern.md` - State/Cubit/Screen patterns
