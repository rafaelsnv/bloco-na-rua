<!-- Context: project-intelligence/technical-domain | Priority: critical | Version: 3.0 | Updated: 2026-07-02 -->

# Technical Domain — BlocoNaRua

**Core Concept**: Flutter mobile app talking to TWO backends — Supabase for auth, custom REST API for business entities (CarnivalBlock, Meetings, Members, etc.). Pt-BR user-facing surface.

---

## High-Level Components

```
┌─────────────────────────────────────────────────────────┐
│                    Flutter App (Mobile)                  │
│                                                          │
│  ┌──────────┐  ┌──────────┐  ┌──────────────────────┐   │
│  │   UI     │  │  Domain  │  │   Data Layer          │   │
│  │ (Cubits) │→ │(UseCase) │→ │ (Repo → ApiClient)   │   │
│  └──────────┘  └──────────┘  └──────────┬───────────┘   │
│                                          │                │
│  ┌─────────────────┐  ┌─────────────────┐ │                │
│  │  GoRouter       │  │   Provider DI   │ │                │
│  └─────────────────┘  └─────────────────┘ │                │
└──────────────────────────────────────────┼────────────────┘
                                           │
                ┌──────────────────────────┴─────┐
                │                                 │
        ┌───────▼────────┐              ┌────────▼────────┐
        │   Supabase     │              │   REST API      │
        │  (Auth)        │              │  (Entities)     │
        │  - signIn      │              │  - CarnivalBlock │
        │  - signUp      │              │  - Meetings      │
        │  - signOut     │              │  - Members       │
        │  - session     │              │  - Presences     │
        └────────────────┘              └─────────────────┘
```

---

## Project Structure

```
bloco_na_rua/                       # Flutter app root
├── lib/                            # Source code
│   ├── config/dependencies.dart    # SINGLE DI file
│   ├── core/                       # Cross-cutting
│   ├── data/                       # Infra: repos, api, services
│   ├── domain/                     # Pure Dart: entities, use cases
│   ├── routing/                    # GoRouter + Routes
│   └── ui/                         # Feature-first UI
├── test/                           # Unit tests
├── integration_test/               # E2E tests
├── android/, ios/, build/,         # Platform scaffolding
├── pubspec.yaml                    # Dart dependencies
├── opencode.jsonc                  # OpenCode agent config
└── architecture_summary.md         # High-level overview (redundant)
```

See `concepts/architecture.md` for the full lib/ tree.

---

## Backend Architecture (external services)

### Service 1: Supabase (Authentication)

- **Used for**: sign-up, sign-in, sign-out, session persistence
- **Tokens**: JWT issued by Supabase; stored in `SharedPreferences` via `SharedPreferencesService`
- **Init**: `await Supabase.initialize(url:, anonKey:)` in `main.dart`
- **Client access**: `Supabase.instance.client`

### Service 2: Custom REST API (Business Entities)

- **Base URL**: `dotenv.env['API_URL']!` (configured per env)
- **Endpoints**: CarnivalBlock CRUD, Meetings CRUD, Members CRUD, MeetingPresences CRUD
- **Client**: `Dio` with `DioErrorInterceptor` + `pretty_dio_logger` (dev only)
- **Convention**: each entity has `I{Feature}ApiClient` (interface) + `{Feature}ApiClient` (impl)

---

## Per-Stack Layer Responsibilities

| Layer        | Responsibility                                              |
| ------------ | ----------------------------------------------------------- |
| **UI**        | Render state, dispatch user intent, NO business logic       |
| **Cubit**     | Translate user intent → UseCase calls → State mutations     |
| **UseCase**   | Orchestrate repos, return `AsyncResult<T>`                |
| **Repository**| Map entity ↔ API, wrap in `AsyncResult<T>`, log errors     |
| **ApiClient** | HTTP call + parse JSON to entity                           |
| **Dio**       | Transport + interceptors + retry                          |

---

## Auth Flow

```
User → LoginScreen → BlocProvider<AuthCubit>
                  ↓
AuthCubit.signIn(email, password)
                  ↓
AuthRepository.signIn(credentials)
                  ↓
AuthApiClient.signIn(supabaseClient)
                  ↓
Supabase auth → JWT token
                  ↓
SharedPreferencesService.saveToken(jwt)
                  ↓
IAuthRepository.notifyListeners()  ← triggers GoRouter refreshListenable
                  ↓
GoRouter._redirect validates session → redirects to /home
```

---

## Request Lifecycle (Business Entity)

```
User taps "Load blocks" in HomeScreen
  → HomeCubit.loadHomeData() emits HomeStatus.loading
  → GetHomeDataUseCase.getCarnivalBlocks()
    → IMembersRepository.getBlocksByMemberId(userId)
      → ICarnivalBlockMembersApiClient.getByMemberId(userId)
        → BaseApiClient.get<T>(path)
          → Dio.get(API_URL + path)
            → DioErrorInterceptor (logs error, returns translated throwable)
              → pretty_dio_logger (dev only)
              ← JSON response
            → JSON → CarnivalBlocksEntity (via fromJson)
          ← AsyncResult<CarnivalBlocksEntity>
        ← AsyncResult<List<CarnivalBlocksEntity>>
      ← AsyncResult<List<CarnivalBlocksEntity>>
    ← AsyncResult<List<CarnivalBlocksEntity>>
  → emit HomeStatus.success + blocks
HomeScreen rebuilds via BlocBuilder
```

---

## Cross-References

- `concepts/architecture.md` — layer relationships
- `concepts/stack.md` — package versions
- `concepts/dio-pipeline.md` — interceptor chain
- `technical-api-pattern.md` — REST + Supabase split
- `technical-component-pattern.md` — per-layer contracts
