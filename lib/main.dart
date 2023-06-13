import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outsightful_quotes/quotes/logic/cubit/theme_cubit.dart';
import 'package:outsightful_quotes/quotes/logic/utils/quote_observer.dart';
import 'package:outsightful_quotes/quotes/presentation/screens/quote_screen.dart';

void main() {
  Bloc.observer = QuoteObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: const QuoteApp(),
    );
  }
}

class QuoteApp extends StatelessWidget {
  const QuoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Outsightful Quotes',
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(
          scheme: FlexScheme.damask,
          useMaterial3: false,
          textTheme: GoogleFonts.figtreeTextTheme()),
      darkTheme: FlexThemeData.dark(
          scheme: FlexScheme.damask,
          useMaterial3: false,
          textTheme: GoogleFonts.figtreeTextTheme()),
      themeMode: context.select((ThemeCubit cubit) => cubit.state.themeMode),
      home: const QuoteScreen(),
    );
  }
}
