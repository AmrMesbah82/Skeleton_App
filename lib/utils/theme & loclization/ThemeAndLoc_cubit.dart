import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeAndLocalizationsState {
  final ThemeMode themeMode;
  final Locale locale;

  ThemeAndLocalizationsState({required this.themeMode, required this.locale});

  ThemeAndLocalizationsState copyWith({ThemeMode? themeMode, Locale? locale}) {
    return ThemeAndLocalizationsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }
}

class ThemeAndLocalizationsCubit extends Cubit<ThemeAndLocalizationsState> {
  ThemeAndLocalizationsCubit()
      : super(ThemeAndLocalizationsState(
          themeMode: ThemeMode.light,
          locale: const Locale('en'),
        )) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString('themeMode');
    final themeMode = themeString == ThemeMode.dark.toString()
        ? ThemeMode.dark
        : ThemeMode.light;
    final localeString = prefs.getString('appLocale') ?? 'en';
    emit(state.copyWith(themeMode: themeMode, locale: Locale(localeString)));
  }

  Future<void> toggleTheme() async {
    final newTheme =
        state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', newTheme.toString());
    emit(state.copyWith(themeMode: newTheme));
  }

  Future<void> toggleLanguage() async {
    final newLocale = state.locale.languageCode == 'en'
        ? const Locale('ar')
        : const Locale('en');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('appLocale', newLocale.languageCode);
    emit(state.copyWith(locale: newLocale));
  }
}
