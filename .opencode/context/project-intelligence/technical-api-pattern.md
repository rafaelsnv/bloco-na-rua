<!-- Context: project-intelligence/technical-api | Priority: high | Version: 1.0 | Updated: 2026-05-17 -->

# API Patterns

**Purpose**: Detailed API client patterns for Flutter/Dart projects.
**Audience**: AI agents implementing API integrations

## BaseApiClient Pattern

```dart
class BaseApiClient implements IBaseApiClient {
  final String basePath = '/api/v1/';
  late final Dio client;

  AsyncResult<List<TEntity>> getAllAsync<TEntity extends EntityBase>(
    JsonFactory<TEntity> fromJsonFactory,
  ) async {
    try {
      String endpoint = TEntity.toString().replaceAll('Entity', '').toLowerCase();
      final response = await client.get('$basePath$endpoint');
      if (response.statusCode != 200) return Failure(formatError(response));
      return Success((response.data as List).map((e) => fromJsonFactory(e)).toList());
    } catch (error) {
      return Failure(Exception('An error occurred: $error'));
    }
  }

  AsyncResult<TEntity> getByIdAsync<TEntity extends EntityBase>(
    int id, JsonFactory<TEntity> fromJsonFactory,
  ) async { /* ... */ }

  AsyncResult<TEntity> createAsync<TEntity extends EntityBase>(
    Map<String, dynamic> data, JsonFactory<TEntity> fromJsonFactory,
  ) async { /* ... */ }
}
```

## Conventions

| Convention | Value |
|------------|-------|
| Entity-to-endpoint | `{EntityName}Entity` → `{entity_name}` |
| HTTP 200 | Success |
| HTTP 201/200 | Created |
| HTTP 204 | Deleted |

## Error Handling

```dart
Exception formatError(Response response) => Exception(
  'Request failed: ${response.statusCode} - ${response.statusMessage}',
);
```

## 📂 Codebase References

**Client**: `lib/data/api/base_api_client.dart`
**Repository**: `lib/data/repositories/entity_repository.dart`

## Related Files

- `technical-domain.md` - Entry point
- `technical-component-pattern.md` - State/Cubit patterns
