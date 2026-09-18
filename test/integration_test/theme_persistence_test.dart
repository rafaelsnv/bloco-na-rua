import 'package:bloco_na_rua/ui/core/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Theme Persistence Integration', () {
    testWidgets(
      'set theme via ThemeCubit → verifies SharedPreferences persisted value; '
      're-creates app instance → verifies theme restored on startup',
      (tester) async {
        // ---------- Part 1: Set theme and verify persistence ----------
        SharedPreferences.setMockInitialValues({});

        final themeCubit = ThemeCubit();
        await themeCubit.setMode(ThemeMode.dark);
        await themeCubit.close();

        // Verify persisted value
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getInt('THEME_MODE'), ThemeMode.dark.index);

        // ---------- Part 2: Re-create app and verify theme restored ----------
        SharedPreferences.setMockInitialValues({
          'THEME_MODE': ThemeMode.dark.index,
        });

        // Simulate app restart by creating a new ThemeCubit instance
        // and loading from SharedPreferences
        final restoredCubit = ThemeCubit();
        await restoredCubit.load();

        expect(restoredCubit.state, ThemeMode.dark);
        await restoredCubit.close();

        // ---------- Additional: Verify light theme persistence ----------
        SharedPreferences.setMockInitialValues({});

        final lightCubit = ThemeCubit();
        await lightCubit.setMode(ThemeMode.light);
        await lightCubit.close();

        final lightPrefs = await SharedPreferences.getInstance();
        expect(lightPrefs.getInt('THEME_MODE'), ThemeMode.light.index);

        final restoredLightCubit = ThemeCubit();
        await restoredLightCubit.load();
        expect(restoredLightCubit.state, ThemeMode.light);
        await restoredLightCubit.close();
      },
    );
  });
}
