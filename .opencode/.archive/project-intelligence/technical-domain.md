<!-- Context: project-intelligence/technical | Priority: critical | Version: 2.0 | Updated: 2026-06-09 -->

# Technical Domain

**Purpose**: Tech stack, architecture patterns, and coding conventions across all frameworks.
**Audience**: AI agents working on any project in this environment.
**Last Updated**: 2026-06-09

## Quick Reference

**Update Triggers**: Tech stack changes | New patterns | Architecture decisions
**Version**: 2.0 (merged from framework-specific files)

---

## Primary Stack

### .NET 8.0
| Layer | Technology | Version | Rationale |
|-------|------------|---------|-----------|
| Framework | .NET 8.0 | 8.0 | LTS, cross-platform |
| Language | C# 12 | latest | Primary constructor support |
| Web | ASP.NET Core | 8.0 | RESTful API |
| ORM | Entity Framework Core | 8.x | PostgreSQL via Npgsql |

### Flutter
| Layer | Technology | Version | Rationale |
|-------|------------|---------|-----------|
| Framework | Flutter | 3.8.1+ | Cross-platform mobile/desktop |
| Language | Dart | SDK ^3.8.1 | Flutter native |
| State | flutter_bloc (Cubit) | 9.1.1 | Predictable unidirectional flow |
| Navigation | go_router | 17.2.3 | Declarative routing with auth guards |
| HTTP | dio | 5.9.0 | Interceptors, logging |
| Code Gen | freezed + json_serializable | 3.2.0 / 6.7.1 | Immutable models |

---

## API Patterns

### .NET API Pattern
```csharp
[ApiController]
[Route("api/v{version:apiVersion}/[controller]")]
public class XxxController(IXxxService service) : ControllerBase
{
    private readonly IXxxService _service = service;
}
```
- **Route**: `api/v{version:apiVersion}/[controller]`
- **DTOs**: Record classes (`*Create`, `*Update`, `*Response`)
- **Error**: `KeyNotFoundException` → 404, `UnauthorizedAccessException` → 401

### Flutter API Pattern
```dart
class BaseApiClient implements IBaseApiClient {
  final String basePath = '/api/v1/';
  late final Dio client;

  AsyncResult<List<TEntity>> getAllAsync<TEntity extends EntityBase>(
    JsonFactory<TEntity> fromJsonFactory,
  ) async { /* ... */ }
}
```
- **Convention**: `{EntityName}Entity` → endpoint `{entity_name}`
- **Return**: `AsyncResult<T>` (Success/Failure)

---

## Component Patterns

### .NET Service Pattern
```csharp
public class XxxService(
    IXxxRepository repository,
    IAuthorizationService authorizationService
) : IXxxService
{
    private readonly IXxxRepository _repository = repository;
    // Primary constructor injection (C# 12)
}
```

### Flutter State/Cubit Pattern
```dart
sealed class EntityState extends Equatable {
  const EntityState();
  @override List<Object?> get props => [];
}
final class EntityLoading extends EntityState {}
final class EntitySuccess extends EntityState {}
final class EntityError extends EntityState {
  final String message;
  const EntityError(this.message);
}

class EntityCubit extends Cubit<EntityState> {
  EntityCubit({required IEntityRepository repo}) : _repo = repo, super(EntityInitial()) {
    loadEntity();
  }
}
```

### Flutter Screen Pattern
```dart
class EntityScreen extends StatefulWidget {
  const EntityScreen({super.key, required this.entityId});
  @override State<EntityScreen> createState() => _EntityScreenState();
}

class _EntityScreenState extends State<EntityScreen> {
  @override Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => EntityCubit(repo: ctx.read<IEntityRepository>()),
      child: BlocConsumer<EntityCubit, EntityState>(
        listener: (ctx, state) {
          if (state is EntitySuccess) ctx.go(Routes.home);
          else if (state is EntityError) { ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(state.message))); }
        },
        builder: (ctx, state) { /* ... */ },
      ),
    );
  }
}
```

---

## Naming Conventions

### .NET
| Type | Convention | Example |
|------|------------|---------|
| Files | PascalCase | `CarnivalBlocksRepository.cs` |
| Classes | PascalCase | `CarnivalBlockService` |
| Interfaces | I prefix | `ICarnivalBlockService` |
| Entities | PascalCase + Entity | `CarnivalBlockEntity` |
| Fields | _camelCase | `_repository` |
| Properties | PascalCase | `CarnivalBlockImage` |
| Methods | PascalCase | `GetAllAsync` |

### Flutter/Dart
| Type | Convention | Example |
|------|------------|---------|
| Files | snake_case | `entity_repository.dart` |
| Folders | kebab-case | `entity/edit/` |
| Classes | PascalCase | `EntityRepository` |
| Entities | PascalCase + Entity | `UserEntity` |
| State classes | sealed + State suffix | `UserState` |
| Cubit | PascalCase + Cubit | `UserCubit` |
| Private fields | _camelCase | `_repo` |
| Constants | k prefix | `kDefaultPageSize` |

---

## Code Standards

### .NET
1. 4-space indentation, Allman braces
2. Primary constructor injection (C# 12)
3. Prefer `var` everywhere
4. Record classes for DTOs

### Flutter
1. Clean Architecture: UI → Domain → Data
2. Sealed state classes with `Equatable`
3. Provider DI via `context.read<T>()`
4. Code gen: `flutter pub run build_runner build --delete-conflicting-outputs`

---

## Security Requirements

### .NET
1. `X-Logged-Member` header for write operations
2. Role-based authorization via `IAuthorizationService.GetMemberRole()`
3. `KeyNotFoundException` → 404, `UnauthorizedAccessException` → 401

### Flutter
1. Trim TextField values before submission
2. API errors → SnackBar
3. `.env` required - app crashes on startup if missing

---

## 📂 Codebase References

**.NET**: `BlocoNaRua.sln` (6 projects) - `BlocoNaRua.Restful/`, `BlocoNaRua.Services/`, `BlocoNaRua.Data/`
**Flutter**: `lib/` structure (ui/, domain/, data/) - `pubspec.yaml`

---

## Related Files

- `business-domain.md` - Business context
- `decisions-log.md` - Decision history
- `business-tech-bridge.md` - Business-technical mapping