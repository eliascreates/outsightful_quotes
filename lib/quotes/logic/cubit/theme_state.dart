part of 'theme_cubit.dart';

enum ThemeType { light, dark }

class ThemeState {
  final ThemeMode themeMode;
  bool get isDarkTheme => themeMode == ThemeMode.dark;

  const ThemeState({required this.themeMode});
}
