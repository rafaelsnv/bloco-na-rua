<!-- Context: project-intelligence/examples/theme-cubit-pattern | Priority: high | Version: 1.0 | Updated: 2026-07-08 -->

# ThemeCubit Pattern — SharedPreferences-Backed ThemeMode

**Core Concept**: A single `Cubit<ThemeMode>` (`ThemeCubit`) persists the active theme mode across reboots via `SharedPreferences` key `"THEME_MODE"` (int = `ThemeMode.index`). `MaterialApp.themeMode` is driven by `BlocBuilder<ThemeCubit, ThemeMode>`, so toggling in Settings updates the UI **instantly** without restart.

> Adopted during design-system migration (Phase 5b-extended finalization, 2026-07-08). Source: `.tmp/.archive/2026-07-08/sessions/2026-07-08-design-system-extended/HANDOFF.md §11` and `2026-07-03-design-system/HANDOFF.md §11`.

---

## The Cubit

**File**: `lib/ui/core/theme/theme_cubit.dart`

```dart
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  static const String prefsKey = "THEME_MODE"; // index 0=system, 1=light, 2=dark

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(prefsKey) ?? ThemeMode.system.index;
    emit(ThemeMode.values[index.clamp(0, ThemeMode.values.length - 1)]);
  }

  Future<void> setMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(prefsKey, mode.index);
    emit(mode);
  }
}
```

---

## Wiring in `main_app.dart`

```dart
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()..load()),
        // ...other providers
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) => MaterialApp.router(
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeMode,
          // ...rest of config
        ),
      ),
    );
  }
}
```

---

## Settings Screen Usage

```dart
// lib/ui/settings/widgets/settings_screen.dart
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();
    return Scaffold(
      appBar: const AppAppBar(title: "Configurações"),
      body: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) => AppCard(
          child: Column(
            children: [
              for (final m in ThemeMode.values)
                RadioListTile<ThemeMode>(
                  value: m,
                  groupValue: mode,
                  onChanged: (selected) async {
                    if (selected == null) return;
                    await themeCubit.setMode(selected);
                    if (context.mounted) {
                      AppSnackbar.info(context: context, message: "Tema atualizado");
                    }
                  },
                  title: Text(_label(m)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _label(ThemeMode m) => switch (m) {
        ThemeMode.system => "Seguir sistema",
        ThemeMode.light  => "Claro",
        ThemeMode.dark   => "Escuro",
      };
}
```

---

## Key Points

1. **`SharedPreferences` key `"THEME_MODE"`** stores `ThemeMode.index` (int: 0=system, 1=light, 2=dark) — **NOT** the enum name (safer against renames).
2. **`load()` on app boot** (called via `..load()` in the `BlocProvider` create callback) — guarantees persisted mode is honored on cold start.
3. **`setMode(...)` writes + emits** — single source of truth (the cubit) for both persistence and state.
4. **`BlocBuilder<ThemeCubit, ThemeMode>` wraps `MaterialApp.router`** — toggling from Settings triggers an instant rebuild, no app restart.
5. **`ThemeMode.system` is the default** — respects OS-level dark mode out of the box.
6. **`clamp(...)` the loaded index** — guards against corrupt prefs (defensive).
7. **No `WidgetsBindingObserver` needed** — the cubit + `BlocBuilder` handle reactivity.

---

## Pattern Variants

- **Locale persistence** — same shape (`LocaleCubit` + `SharedPreferences` key `"LOCALE"`). Deferred per `living-notes.md` (Q3 follow-up).
- **Theme accent override** — would require a separate `accentCubit` (e.g., user picks from a preset palette). Not needed for v1.

---

## Reference

- `lookup/widgets-api.md` — `AppAppBar` / `AppSnackbar` constructors
- `lookup/token-discipline.md` — `AppTheme` uses tokens, no hardcoded colors
- `concepts/bloc-state-pattern.md` — `Cubit` state shape
- `examples/widget-pattern.md` — `BlocBuilder` / `context.read()` patterns
- `.tmp/.archive/2026-07-08/sessions/2026-07-08-design-system-extended/HANDOFF.md` §11 — implementation details