<!-- Context: project-intelligence/concepts/architecture | Priority: critical | Version: 2.0 | Updated: 2026-11-19 -->

# Architecture - Clean Architecture (Bloco na Rua)

**Core Concept**: Clean Architecture with unidirectional data flow: UI Layer (Screens, Widgets, Cubits) → Domain Layer (Use Cases, Entities) → Data Layer (Repositories, API Clients, Services).

---

## Directory Structure

```
lib/
├── main.dart                 # Entry point, dotenv API_URL init
├── main_app.dart             # MaterialApp.router with AuthCubit
├── config/
│   └── dependencies.dart    # Provider DI setup
├── core/                     # Base interfaces, utilities
├── data/
│   ├── repositories/         # Repository implementations
│   └── services/
│       ├── api/             # API clients (base, meetings, blocks, etc.)
│       └── auth/            # Auth API client (REST /api/v1/Auth/*) + Google sign-in service
├── domain/
│   ├── entities/            # freezed entities (Meeting, Block, Member, etc.)
│   └── use_cases/           # Business logic use cases
├── routing/
│   ├── router.dart          # GoRouter with auth redirect
│   └── routes.dart          # Route constants
└── ui/
    ├── auth/                # Login, SignUp screens
    ├── carnivalBlock/       # Block CRUD screens
    ├── home/                # Home screen with blocks/meetings
    ├── meetings/            # Meeting screens (create, edit, details)
    ├── members/             # Members list screen
    └── core/tokens/         # Design tokens (AppColors, Spacing, AppElevation)
```

---

## Key Points

1. **Provider for DI** — NOT flutter_modular; bindings in `config/dependencies.dart`
2. **GoRouter with auth guards** — redirect based on AuthCubit state; route names in `routing/routes.dart`
3. **freezed entities** — immutable domain entities in `domain/entities/`; regenerate with build_runner
4. **result_dart** — repositories/services return `Result<T>` (Success/Failure), never throw across layers
5. **dio API clients** — grouped under `data/services/api/` against REST backend `/api/v1/`

---

## Minimal Example

GoRouter auth redirect pattern (`routing/router.dart`):

```dart
final router = GoRouter(
  redirect: (context, state) {
    final authed = context.read<AuthCubit>().state is AuthAuthenticated;
    final loggingIn = state.matchedLocation == Routes.login;
    if (!authed && !loggingIn) return Routes.login;
    if (authed && loggingIn) return Routes.home;
    return null;
  },
);
```

---

## Reference

- Full structure: `README.md` ("Project Structure" section)
- State management details: `README.md` ("Architecture" section)
- Design tokens: `../lookup/design-tokens.md`
