<!-- Context: development/guides/flutter-di | Priority: high | Version: 1.0 | Updated: 2026-06-14 -->

# Guide: Provider Dependency Injection

**Purpose**: Singleton pattern for repositories and API clients using Provider.

---

## Provider Setup

```dart
List<SingleChildWidget> get providers {
  return [
    // Core
    Provider<SupabaseClient>(create: (context) => supabaseClient),
    Provider(create: (context) => SharedPreferencesService()),

    // API Clients
    Provider<IBaseApiClient>(
      create: (context) => BaseApiClient(
        clientFactory: (options) {
          final client = Dio(options);
          client.interceptors.add(DioErrorInterceptor());
          client.interceptors.add(PrettyDioLogger(
            requestBody: true,
            responseBody: true,
          ));
          return client;
        },
        options: baseOptions,
      ),
    ),

    // Per-entity API clients
    Provider<IMeetingsApiClient>(
      create: (context) => MeetingsApiClient(context.read<IBaseApiClient>()),
    ),
    Provider<IMembersApiClient>(
      create: (context) => MembersApiClient(context.read<IBaseApiClient>()),
    ),

    // Repositories
    Provider<IMeetingsRepository>(
      create: (context) => MeetingsRepository(
        meetingsApiClient: context.read<IMeetingsApiClient>(),
      ),
    ),

    // Use Cases
    Provider<GetUserMeetingsUseCase>(
      create: (context) => GetUserMeetingsUseCase(
        getCurrentUserData: context.read<GetCurrentUserData>(),
        membersRepo: context.read<IMembersRepository>(),
      ),
    ),

    // Cubits
    Provider<ProfileCubit>(
      create: (context) => ProfileCubit(
        authRepository: context.read<IAuthRepository>(),
        membersRepository: context.read<IMembersRepository>(),
      ),
    ),
  ];
}
```

---

## Usage in Widgets

```dart
// In build method
BlocProvider(
  create: (ctx) => EntityCubit(
    repo: ctx.read<IEntityRepository>(),
  ),
  child: ...
)

// Or for simple values
final myService = context.read<MyService>();
```

---

## DI Pattern Summary

| Type | Pattern | Example |
|------|---------|---------|
| Singleton services | `Provider` | `SharedPreferencesService` |
| API clients | `Provider` + interface | `IMeetingsApiClient` |
| Repositories | `Provider` + interface | `IMeetingsRepository` |
| Use cases | `Provider` | `GetUserMeetingsUseCase` |
| Cubits | `Provider` | `ProfileCubit` |

---

## Key Points

1. **Interfaces** - Use `I` prefix for repository/API interfaces
2. **Read-only** - `context.read<T>()` for synchronous access
3. **Lazy loading** - Providers created on first access
4. **Single source** - Register once in `providers` list

---

## Reference

- `lib/config/dependencies.dart` - Full implementation
- `lib/main.dart` - `MultiProvider(providers: providers, ...)`
