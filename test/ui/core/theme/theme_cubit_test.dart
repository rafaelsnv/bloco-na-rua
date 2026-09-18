import "package:bloc_test/bloc_test.dart";
import "package:bloco_na_rua/ui/core/theme/theme_cubit.dart";
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:test/test.dart";

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() {
    // No need to close SharedPreferences mock
  });

  group("ThemeCubit", () {
    test("initial state is ThemeMode.system", () {
      final cubit = ThemeCubit();
      expect(cubit.state, ThemeMode.system);
      cubit.close();
    });

    blocTest<ThemeCubit, ThemeMode>(
      "load() loads ThemeMode.light when saved in SharedPreferences",
      setUp: () {
        SharedPreferences.setMockInitialValues({"THEME_MODE": ThemeMode.light.index});
      },
      build: () => ThemeCubit(),
      act: (cubit) => cubit.load(),
      expect: () => [ThemeMode.light],
    );

    blocTest<ThemeCubit, ThemeMode>(
      "load() loads ThemeMode.dark when saved in SharedPreferences",
      setUp: () {
        SharedPreferences.setMockInitialValues({"THEME_MODE": ThemeMode.dark.index});
      },
      build: () => ThemeCubit(),
      act: (cubit) => cubit.load(),
      expect: () => [ThemeMode.dark],
    );

    blocTest<ThemeCubit, ThemeMode>(
      "load() does not emit when key not found (already system)",
      setUp: () {
        SharedPreferences.setMockInitialValues({});
      },
      build: () => ThemeCubit(),
      act: (cubit) => cubit.load(),
      expect: () => [],
    );

    blocTest<ThemeCubit, ThemeMode>(
      "load() does not emit when saved index is invalid",
      setUp: () {
        SharedPreferences.setMockInitialValues({"THEME_MODE": 999});
      },
      build: () => ThemeCubit(),
      act: (cubit) => cubit.load(),
      expect: () => [],
    );

    blocTest<ThemeCubit, ThemeMode>(
      "setMode() emits new theme and persists to SharedPreferences",
      setUp: () {
        SharedPreferences.setMockInitialValues({});
      },
      build: () => ThemeCubit(),
      act: (cubit) => cubit.setMode(ThemeMode.dark),
      expect: () => [ThemeMode.dark],
      verify: (_) async {
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getInt("THEME_MODE"), ThemeMode.dark.index);
      },
    );

    blocTest<ThemeCubit, ThemeMode>(
      "setMode() does not emit when setting same mode",
      setUp: () {
        SharedPreferences.setMockInitialValues({"THEME_MODE": ThemeMode.dark.index});
      },
      build: () => ThemeCubit(),
      act: (cubit) async {
        await cubit.load(); // Load dark from prefs first
        await cubit.setMode(ThemeMode.dark); // Then try to set dark again
      },
      expect: () => [ThemeMode.dark], // Only load() emits, setMode(dark) is no-op
    );

    blocTest<ThemeCubit, ThemeMode>(
      "setMode() persists light theme correctly",
      setUp: () {
        SharedPreferences.setMockInitialValues({});
      },
      build: () => ThemeCubit(),
      act: (cubit) => cubit.setMode(ThemeMode.light),
      expect: () => [ThemeMode.light],
      verify: (_) async {
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getInt("THEME_MODE"), ThemeMode.light.index);
      },
    );
  });
}
