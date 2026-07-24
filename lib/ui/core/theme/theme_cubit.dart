import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:shared_preferences/shared_preferences.dart";

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  static const String _key = "THEME_MODE";

  /// Loads persisted ThemeMode from SharedPreferences.
  /// Defaults to ThemeMode.system when no value is stored.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_key);
    if (index != null && index >= 0 && index < ThemeMode.values.length) {
      emit(ThemeMode.values[index]);
    }
  }

  /// Sets new ThemeMode, persists to SharedPreferences, and emits.
  Future<void> setMode(ThemeMode mode) async {
    if (state == mode) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, mode.index);
    emit(mode);
  }
}
