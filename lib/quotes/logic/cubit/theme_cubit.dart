import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(themeMode: ThemeMode.light));

  void updateAppTheme() {
    emit(
      ThemeState(
        themeMode: state.isDarkTheme ? ThemeMode.light : ThemeMode.dark,
      ),
    );
  }
}
