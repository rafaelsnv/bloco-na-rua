import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:shared_preferences/shared_preferences.dart";

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  static const String _key = "THEME_MODE";

  /// Loads persisted ThemeMode from SharedPreferences.
  /// On first launch (no stored value), derives from system brightness and persists it.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final storedIndex = prefs.getInt(_key);
    if (storedIndex != null && storedIndex >= 0 && storedIndex < ThemeMode.values.length) {
      emit(ThemeMode.values[storedIndex]);
    }
    // If no stored value — first launch — system brightness is used.
    // No extra action needed; isDarkModeEnabled getter handles the rest.
  }

  /// Returns true if dark mode is enabled:
  /// - Explicitly set to dark → true
  /// - Explicitly set to light → false
  /// - System mode (null stored) → derive from current system brightness
  bool isDarkModeEnabled(BuildContext context) {
    if (state == ThemeMode.dark) return true;
    if (state == ThemeMode.light) return false;
    // ThemeMode.system
    return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
  }

  /// Sets dark mode on or off.
  /// When enabling → ThemeMode.dark
  /// When disabling → ThemeMode.light
  /// Clears "system" choice by storing an explicit value.
  Future<void> setDarkMode(bool enabled) async {
    final newMode = enabled ? ThemeMode.dark : ThemeMode.light;
    if (state == newMode) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, newMode.index);
    emit(newMode);
  }
}
