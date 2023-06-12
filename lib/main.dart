import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outsightful_quotes/quotes/logic/bloc/quote_bloc.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QuoteBloc>(
      create: (context) =>
          QuoteBloc(httpClient: http.Client())..add(QuotesFetched()),
      child: MaterialApp(
        title: 'Outsightful Quotes',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Main(),
      ),
    );
  }
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuoteBloc, QuoteState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Good Morning')),
          body: Center(
            child: Text('${state.result?.quotes[0].quoteText}'),
          ),
        );
      },
    );
  }
}
