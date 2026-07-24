<!-- Context: project-intelligence/examples/module-pattern | Priority: high | Version: 3.0 | Updated: 2026-07-02 -->

# Module / DI Pattern — Provider, NOT Modular

**Core Concept**: Single-file DI using the `provider` package. All `Provider`s live in `lib/config/dependencies.dart`. NO Modular, NO GetIt, NO annotations.

---

## Why Provider

| Decision        | Pro                                  | Con                                |
| --------------- | ------------------------------------ | ---------------------------------- |
| **Provider** ✅  | Simple, idiomatic Flutter, no codegen | No automatic lazy singletons        |
| Modular         | Powerful, code-splitting             | Overkill for ~15 dependencies     |
| GetIt           | Singleton registry                   | Two systems (DI + widget tree)    |
| Riverpod        | Compile-safe, scoped providers       | Adds complexity, learning curve   |

**Verdict**: Single `MultiProvider` in `main.dart` reading from `List<SingleChildWidget>` exported by `dependencies.dart`.

---

## Setup: `lib/config/dependencies.dart`

```dart
import 'package:bloco_na_rua/data/repositories/meetings/imeetings_repository.dart';
import 'package:bloco_na_rua/data/repositories/meetings/meetings_repository.dart';
import 'package:bloco_na_rua/data/services/api/base/ibase_api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:provider/single_child_widget.dart';

// 1. Configure Dio base options
var baseOptions = BaseOptions(
  baseUrl: dotenv.env['API_URL']!,
  receiveDataWhenStatusError: true,
  validateStatus: (status) =>
      status != null && status >= 200 && status < 500,
);

// 2. Export a single provider list
List<SingleChildWidget> get providers => [
  // === Core infra ===
  Provider<IBaseApiClient>(
    create: (_) => BaseApiClient(
      clientFactory: (opts) {
        final client = Dio(opts);
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

  // === Repositories (interface -> impl) ===
  Provider<IMeetingsRepository>(
    create: (c) => MeetingsRepository(meetingsApiClient: c.read()),
  ),

  // === Use Cases ===
  Provider<GetUserMeetingsUseCase>(
    create: (c) => GetUserMeetingsUseCase(
      getCurrentUserData: c.read(),
      membersRepo: c.read(),
    ),
  ),

  // === Cubits (long-lived, page-scoped ones go in router) ===
  Provider<ProfileCubit>(
    create: (c) => ProfileCubit(
      authRepository: c.read(),
      membersRepository: c.read(),
    ),
  ),
];
```

## Wire in `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(/* ... */);
  runApp(MultiProvider(providers: providers, child: const MainApp()));
}
```

---

## Consume in a Cubit (page-scoped)

```dart
pageBuilder: (context, state) => _buildPageWithSlideTransition(
  context: context,
  state: state,
  child: BlocProvider(
    create: (context) =>
        HomeCubit(getHomeDataUseCase: context.read())
          ..loadHomeData(),
    child: const HomeScreen(),
  ),
);
```

**Note**: `HomeCubit` is NOT registered in `providers` because it depends on a path parameter / per-page state. Page-scoped cubits live in `router.dart`; globally-scoped ones go in `dependencies.dart`.

---

## Key Points

1. **Two scopes**: global (in `providers`) vs page (in `router.dart`)
2. **`Provider<T>`** for stateless infra; **`ChangeNotifierProvider`** only for `IAuthRepository` (needs notifyListeners)
3. **No annotation processing** — `flutter pub get` only; no build_runner
4. **`context.read<T>()`** in cubit constructors (don't use `Provider.of<T>(context)`)
5. **Single file** — `dependencies.dart` is the ONE place to register providers

---

## What Goes Where?

| Item                          | Scope          | Where                                     |
| ----------------------------- | -------------- | ----------------------------------------- |
| Dio client, interceptors       | Global         | `dependencies.dart`                       |
| Repositories                  | Global         | `dependencies.dart`                       |
| Use cases                     | Global         | `dependencies.dart`                       |
| Supabase client                | Global         | `dependencies.dart`                       |
| Auth cubit (long-lived)       | Global         | `dependencies.dart` (or `main_app.dart`)  |
| Page-detail cubits (id-bound) | Page           | `router.dart`                             |
| Form-cubit (validation)       | Page           | `router.dart`                             |

---

## Reference

- `concepts/architecture.md` — DI section
- `concepts/stack.md` — provider version
- `lookup/routes.md` — page-scoped cubits
- `examples/home-feature-flow.md` — full trace
