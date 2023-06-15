import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:outsightful_quotes/quotes/logic/bloc/quote_bloc.dart';
import 'components/quotelist.dart';

class QuoteScreen extends StatelessWidget {
  const QuoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QuoteBloc>(
      create: (context) =>
          QuoteBloc(httpClient: http.Client())..add(QuotesFetched()),
      child: const Scaffold(
        body: QuoteList(),
      ),
    );
  }
}
