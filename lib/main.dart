import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return MaterialApp(
      title: 'Outsightful Quotes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const QuoteScreen(),
    );
  }
}
