<!-- Context: project-intelligence/concepts/stack | Priority: high | Version: 3.0 | Updated: 2026-07-02 -->

# Technology Stack — BlocoNaRua

**Core Concept**: Flutter mobile app with a Dio + Supabase hybrid backend. State management via flutter_bloc, DI via Provider, models via Freezed.

---

## Runtime Environment

| Tool         | Version        | Notes                              |
| ------------ | -------------- | ---------------------------------- |
| Flutter SDK  | ^3.8.1         | Dart 3.8+                          |
| Flutter Intl | `flutter_localizations` | pt-BR (default) + en |

---

## State & DI

| Package         | Version  | Role                                    |
| --------------- | -------- | --------------------------------------- |
| `flutter_bloc`    | ^9.1.1   | Cubit + Bloc state management           |
| `provider`        | ^6.1.5   | DI container (single MultiProvider)    |
| `equatable`       | ^2.0.7   | State equality (no rebuild surprises)  |
| `result_dart`     | ^2.1.1   | `AsyncResult<T>` for repo/usecase calls |

---

## Networking

| Package              | Version | Role                                   |
| -------------------- | ------- | -------------------------------------- |
| `dio`                  | ^5.9.0  | HTTP client (REST API for entities)    |
| `pretty_dio_logger`    | ^1.4.0  | Dev-time request/response pretty log   |
| `supabase_flutter`     | ^2.10.0 | Auth backend (email/password)          |
| `gotrue`               | ^2.14.0 | GoTrue SDK (Supabase auth lib)         |

**Decision**: Custom Dio REST for business entities; Supabase only for authentication.

---

## Models & Code Generation

| Package                | Version  | Role                              |
| ---------------------- | -------- | --------------------------------- |
| `freezed_annotation`     | ^3.1.0   | `@freezed sealed class` entities  |
| `json_annotation`        | ^4.9.0   | JSON `Map<String, dynamic>` ↔ Dart |
| `freezed` (dev)          | ^3.2.0   | Code generator                    |
| `json_serializable` (dev)| ^6.7.1   | JSON codegen                      |
| `build_runner` (dev)     | ^2.7.0   | Codegen orchestrator              |

Run after entity changes: `dart run build_runner build --delete-conflicting-outputs`

---

## Routing

| Package    | Version  | Role                              |
| ---------- | -------- | --------------------------------- |
| `go_router` | ^17.2.3 | Declarative routing + redirects   |

---

## UX / Forms / Visuals

| Package              | Version  | Role                                  |
| -------------------- | -------- | ------------------------------------- |
| `cupertino_icons`     | ^1.0.8   | iOS-style icons                       |
| `carousel_slider`     | ^5.1.1   | Image carousel (e.g., block carousel) |
| `brasil_fields`       | ^1.14.0  | CPF, CNPJ, phone, currency formatters |
| `intl`                | any      | Date/number formatting                |

---

## Persistence & Config

| Package             | Version  | Role                                  |
| ------------------- | -------- | ------------------------------------- |
| `shared_preferences` | ^2.5.3   | Token / settings persistence           |
| `flutter_dotenv`     | ^6.0.0   | `.env` file → env vars               |
| `logging`            | ^1.3.0   | `Logger('ContextName')` per component |
| `command_it`         | ^9.5.1   | CLI command pattern (if used)         |

---

## Tests

| Package             | Version  | Role                                |
| ------------------- | -------- | ----------------------------------- |
| `flutter_test` (dev)  | SDK      | Widget + unit tests                 |
| `integration_test` (dev)| SDK    | E2E tests (use `driver_main.dart`)   |
| `test` (dev)          | ^1.30.0  | Pure Dart tests (no Flutter)        |
| `flutter_lints` (dev) | ^6.0.0  | Lints                               |

---

## Why These Choices

1. **Hybrid backend** — Supabase = free auth with email/password out-of-the-box; Dio REST = full control over business entities and custom endpoints.
2. **`result_dart`** over `Either` — simpler, no `fold` boilerplate, idiomatic `.isSuccess()`/`.isError()`.
3. **`provider` over `get_it`/`riverpod`** — simpler API, single MultiProvider in `main.dart`, no annotation processing.
4. **Freezed over manual classes** — automatic `copyWith`, `==`, sealed unions for entity variants.
5. **`go_router` over `Navigator 2.0`** — declarative, redirect logic, easy param parsing.

---

## Reference

- `pubspec.yaml` — full dependency lock
- `concepts/architecture.md` — how layers fit together
- `technical-api-pattern.md` — Dio + Supabase split
- `lookup/cli-commands.md` — common commands
