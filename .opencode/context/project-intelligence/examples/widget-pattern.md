<!-- Context: project-intelligence/examples/widget-pattern | Priority: high | Version: 3.0 | Updated: 2026-07-02 -->

# Widget Pattern — Per-Feature Folder + BlocBuilder

**Core Concept**: Each UI feature lives in `lib/ui/{feature}/{cubit, widgets}/`. Widgets consume Cubits via `BlocBuilder` (not `Consumer` from provider — we use Bloc here).

---

## Feature Folder Layout

```
lib/ui/home/
├── cubit/
│   ├── home_cubit.dart       # Cubit + state changes
│   └── home_state.dart       # State class (Equatable + copyWith)
└── widgets/
    └── home_screen.dart      # Scaffold + BlocBuilder
```

For complex features, sub-features live in nested folders:
```
lib/ui/carnivalBlock/
├── addMember/{cubit, widgets}/
├── blockDetails/{cubit, widgets}/
├── createBlock/widgets/
├── editBlock/{cubit, widgets}/
└── joinBlock/widgets/
```

---

## Canonical Screen Pattern

**File**: `lib/ui/home/widgets/home_screen.dart` (simplified)

```dart
import 'package:bloco_na_rua/ui/home/cubit/home_cubit.dart';
import 'package:bloco_na_rua/ui/home/cubit/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bloco na Rua')),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          switch (state.status) {
            case HomeStatus.initial:
            case HomeStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case HomeStatus.failure:
              return _ErrorView(message: state.errorMessage ?? 'Erro');
            case HomeStatus.success:
              return _SuccessView(
                blocks: state.blocks,
                meetings: state.meetings,
              );
          }
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Text(message, textAlign: TextAlign.center),
    ),
  );
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.blocks, required this.meetings});
  final List<CarnivalBlocksEntity> blocks;
  final List<MeetingsEntity> meetings;
  @override
  Widget build(BuildContext context) => ListView(
    children: [
      // carousel for blocks, list for meetings, etc.
    ],
  );
}
```

---

## Routing + DI Hookup

In `lib/routing/router.dart`, the screen is wired:

```dart
GoRoute(
  path: Routes.home,
  pageBuilder: (context, state) => _buildPageWithSlideTransition(
    context: context,
    state: state,
    child: BlocProvider(
      create: (context) =>
          HomeCubit(getHomeDataUseCase: context.read())..loadHomeData(),
      child: const HomeScreen(),
    ),
  ),
),
```

---

## Key Points

1. **One folder per feature** under `lib/ui/`
2. **`cubit/` + `widgets/` subfolders** (not flat)
3. **`BlocBuilder<MyCubit, MyState>`** for state consumption (not `BlocConsumer` unless you need `listener`)
4. **`switch` on `enum Status`** for view selection (exhaustive, compile-safe)
5. **Private widgets** prefixed with `_` (e.g., `_ErrorView`) for screen-internal helpers

---

## When to Use BlocConsumer Instead

Use `BlocConsumer` only when you need BOTH a `builder` AND a `listener` (e.g., show snackbar on `failure` while also rebuilding UI on `success`).

For most screens, `BlocBuilder` is enough.

---

## Reference

- `lookup/cubits.md` — full cubit catalog
- `lookup/routes.md` — all routes
- `examples/router-slide-transition.md` — transition details
- `concepts/architecture.md` — UI layer responsibilities
