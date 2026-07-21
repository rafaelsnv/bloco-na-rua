<!-- Context: project-intelligence/errors/common-errors | Priority: medium | Version: 4.0 | Updated: 2026-07-13 -->

# Common Build Errors — BlocoNaRua

**Quick reference**: Error → Fix mappings specific to this project's tooling.

## Freezed / Codegen

| Error | Fix |
|-------|-----|
| `.freezed.dart` not found after edit | Run `dart run build_runner build --delete-conflicting-outputs` |
| `'_$XxxEntity' isn't a mixin` after rename | Delete `.freezed.dart` and `.g.dart`, regenerate |
| `fromJson` undefined on entity | Add `@freezed` annotation + factory `fromJson` + run codegen |
| Modifying freezed file has no effect | Stop and restart the dev runner (`--watch`); some IDEs cache |
| Stale `.g.dart` after renaming a field | Delete + re-run `build_runner` |

## Dio / Networking

| Error | Fix |
|-------|-----|
| `DioException` escapes a Repository | Wrap in `try { ... } on DioException catch (e) { return Failure(ApiError.fromDioException(e)); }` |
| `ApiError.userMessage` is null | Ensure factory went through `ApiError.fromDioException` (NOT raw exception) |
| `validateStatus` swallowing 404 | Either tighten status range or handle `response.statusCode == 404` explicitly |
| `10.0.2.2` not working on iOS | iOS simulator uses `localhost` instead |
| Real device not reaching backend | Use machine's LAN IP (not `localhost`, not `10.0.2.2`) |

## Cubits / Bloc

| Error | Fix |
|-------|-----|
| UI not rebuilding after `emit` | Add field to `props` list in State class (Equatable) |
| Cubit throws on `super(const MyState())` | State class needs `const` constructor |
| `BlocProvider` not found in route | Make sure `BlocProvider` wraps the screen (not wraps the route) |
| Post-dispose crash after async gap | Add `mounted` guard before `emit` after `await` |

## Async Safety

| Error | Fix |
|-------|-----|
| Duplicate snackbars on repeated actions | Use `listenWhen` in BlocListener to filter duplicate states |
| Race condition on `currentUuid` | Cache `Future<String?>` not the resolved value — share the future itself |
| N+1 queries in screen | Use `Future.wait([...])` for parallel fetches instead of sequential awaits |

## Error Message Extraction

| Pattern | Fix |
|---------|-----|
| Duplicated `_extractUserMessage` in 12+ cubits | Extract to `lib/core/errors/api_error_utils.dart` — single source of truth |

## Supabase

| Error | Fix |
|-------|-----|
| `Bad state: Future not completed` on auth call | Missing `await Supabase.initialize(...)` in `main()` |
| `AuthException: Invalid login credentials` | Show generic pt-BR message — do NOT echo `e.message` |
| `currentSession` null after backgrounding | Handle 401 — see `living-notes.md` Q1 |
| `pubspec.yaml` gotrue / supabase version mismatch | Run `flutter pub outdated` and align |

## Imports / Paths

| Error | Fix |
|-------|-----|
| `package:bloco_na_rua/core/...` not found | Path is correct; check `pubspec.yaml` for `name: bloco_na_rua` |
| `import 'shared_preferencies_service.dart'` | YES, this misspelling is correct — file is named with typo (see `living-notes.md` debt) |

## Routing

| Error | Fix |
|-------|-----|
| Route infinite-loop | Make sure `_redirect` returns `null` (not always a path) for valid cases |
| `state.pathParameters['id']` returns null | Path doesn't have `:id`; check route definition |

## Reference

- `concepts/freezed-entity.md` — full codegen guide
- `concepts/dio-pipeline.md` — interceptor chain
- `guides/error-to-user-message.md` — error translation
- `errors/dio-supabase-errors.md` — additional Dio/Supabase gotchas
- `living-notes.md` — open issues
