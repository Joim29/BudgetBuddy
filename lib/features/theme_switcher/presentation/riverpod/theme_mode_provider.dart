import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Key for storing theme mode preference in SharedPreferences.
const String _themeModeKey = 'themeMode';

/// A [StateNotifierProvider] that manages the application's [ThemeMode].
/// It persists the selected theme mode using [SharedPreferences].
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadThemeMode();
  }

  /// Loads the saved theme mode preference from SharedPreferences.
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedThemeMode = prefs.getString(_themeModeKey);

    if (savedThemeMode != null) {
      state = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == savedThemeMode,
        orElse: () => ThemeMode.system, // Fallback to system if invalid value
      );
    }
  }

  /// Sets the new theme mode and saves it to SharedPreferences.
  Future<void> setThemeMode(ThemeMode newMode) async {
    if (state == newMode) return; // No change needed

    state = newMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, newMode.toString());
  }

  /// Toggles between light and dark mode. If current is system, it goes to light.
  Future<void> toggleThemeMode() async {
    if (state == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else if (state == ThemeMode.dark) {
      await setThemeMode(ThemeMode.light); // Toggle back to light
    } else {
      await setThemeMode(ThemeMode.light); // If system, default to light
    }
  }
}
