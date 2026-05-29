import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/providers/shared_preferences_provider.dart';
import '../domain/settings_state.dart';

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final themeModeStr = prefs.getString(AppConstants.prefTheme) ?? 'system';
    final languageStr = prefs.getString(AppConstants.prefLanguage) ?? 'en';
    return SettingsState(
      themeMode: _parseThemeMode(themeModeStr),
      locale: Locale(languageStr),
    );
  }

  ThemeMode _parseThemeMode(String value) => switch (value) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final modeStr = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      _ => 'system',
    };
    await prefs.setString(AppConstants.prefTheme, modeStr);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(AppConstants.prefLanguage, locale.languageCode);
    state = state.copyWith(locale: locale);
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);
