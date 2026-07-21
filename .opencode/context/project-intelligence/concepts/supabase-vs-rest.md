<!-- Context: project-intelligence/concepts/supabase-vs-rest | Priority: high | Version: 1.0 | Updated: 2026-07-02 -->

# Supabase vs REST — When to Use Which

**Core Concept**: Supabase = auth only. Custom REST API = business entities. NEVER mix them. Each has its own client, its own error pipeline.

---

## Decision Tree

```
Need to handle: SIGN-IN / SIGN-UP / SIGN-OUT / TOKEN REFRESH
└── YES → Use Supabase (`AuthApiClient`)
Need to handle: GET / POST / PUT / DELETE on /carnival-block*, /meeting*, etc.
└── YES → Use Dio REST (`BaseApiClient`)
Need to handle: AUTH-GATED endpoints (backend respects Supabase JWT)
└── YES → Use Dio REST (pass JWT via Authorization header — TBD)
Need to STORE/RETRIEVE small key-value pairs (token, last sync)
└── YES → Use `SharedPreferences` (NOT Supabase)
```

---

## Why Two Backends?

| Concern       | Supabase                     | Custom REST                          |
| ------------- | ---------------------------- | ------------------------------------ |
| Auth           | ✅ Free, secure, JWT          | ❌ Have to build + maintain           |
| Business CRUD  | ❌ Tables + RLS = complicated | ✅ Full control over endpoints        |
| Image upload   | ✅ Storage built-in           | ⚠️ Need separate upload service       |
| Real-time      | ✅ Realtime channels          | ❌ Have to build (websockets/SSE)     |
| Custom logic   | ❌ Stored procs only          | ✅ Free backend logic                 |

**Verdict**: Supabase's strengths (auth) are quick wins. Its constraints (RLS) would slow down our domain logic. So we use Supabase ONLY for auth, and a custom REST API for everything else.

---

## Client Setup

### Supabase (in `main.dart`)

```dart
await Supabase.initialize(
  url: dotenv.env['SUPABASE_URL']!,
  anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  realtimeClientOptions: RealtimeClientOptions(
    logLevel: RealtimeLogLevel.warn,
  ),
);
```

Then access via `Supabase.instance.client` (singleton).

### Dio REST (in `dependencies.dart`)

```dart
Provider<IBaseApiClient>(
  create: (_) => BaseApiClient(
    clientFactory: (opts) {
      final client = Dio(opts);
      client.interceptors.add(DioErrorInterceptor());
      client.interceptors.add(PrettyDioLogger(...));
      return client;
    },
    options: BaseOptions(
      baseUrl: dotenv.env['API_URL']!,
      receiveDataWhenStatusError: true,
      validateStatus: (s) => s != null && s >= 200 && s < 500,
    ),
  ),
),
```

---

## Error Pipeline Differences

| Aspect      | Supabase                          | Dio REST                              |
| ----------- | --------------------------------- | ------------------------------------- |
| Exception   | `AuthException` (from gotrue)     | `DioException`                          |
| Translation | None (use `e.message` directly)   | `ApiError.fromDioException(e)`         |
| User-facing | Use `e.message` (English)         | Use `ApiError.userMessage` (pt-BR)     |
| Logging     | `Logger('AuthApiClient').severe`  | Same pattern                           |

---

## Where Each Lives in Code

| Layer       | Supabase File                            | REST File                                      |
| ----------- | ---------------------------------------- | ---------------------------------------------- |
| Bootstrap   | `main.dart` (init Supabase)              | `dependencies.dart` (register BaseApiClient)   |
| Auth client | `data/services/auth/auth_api_client.dart` | `data/services/api/base/base_api_client.dart`  |
| Repo        | `data/repositories/auth/auth_repository.dart` | `data/repositories/{feature}/...`             |
| UseCase     | (none — direct in repo)                  | (when orchestrated)                             |
| Cubit       | `ui/auth/cubit/auth_cubit.dart`          | `ui/{feature}/cubit/...`                        |

---

## Future: When to Reconsider

| Signal                                         | Action                                       |
| ---------------------------------------------- | -------------------------------------------- |
| Backend logic gets complex                      | Consider moving to Supabase RPC functions     |
| Image upload becomes needed                     | Use Supabase Storage directly                 |
| Real-time features requested                     | Use Supabase Realtime channels                |
| Auth evolves (OAuth, MFA)                        | Stays on Supabase                              |
| Custom REST becomes a bottleneck                 | Move to a single Supabase Postgres backend    |

---

## Reference

- `concepts/stack.md` — package versions
- `concepts/dio-pipeline.md` — error chain
- `technical-api-pattern.md` — code-level split
- `data/services/auth/auth_api_client.dart`
- `data/services/api/base/base_api_client.dart`
- `decisions-log.md` — initial hybrid decision
