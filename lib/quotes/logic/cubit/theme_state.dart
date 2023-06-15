part of 'theme_cubit.dart';

enum ThemeType { light, dark }

class ThemeState {
  const ThemeState({required this.themeMode});

  final ThemeMode themeMode;
  bool get isDarkTheme => themeMode == ThemeMode.dark;

  @override
  String toString() =>
      'ThemeState { themeMode: $themeMode, isDarkTheme: $isDarkTheme}';
}
