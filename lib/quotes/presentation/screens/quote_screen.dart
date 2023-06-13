import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:outsightful_quotes/core/strings.dart';
import 'package:outsightful_quotes/core/values.dart';
import 'package:outsightful_quotes/quotes/logic/bloc/quote_bloc.dart';
import 'package:outsightful_quotes/quotes/logic/cubit/theme_cubit.dart';

import 'components/quotelist.dart';

class QuoteScreen extends StatelessWidget {
  const QuoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QuoteBloc>(
      create: (context) =>
          QuoteBloc(httpClient: http.Client())..add(QuotesFetched()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.homeTitle),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: Values.defaultPadding / 2),
              child: BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, state) {
                  return Switch(
                    value: state.isDarkTheme,
                    onChanged: (_) =>
                        context.read<ThemeCubit>().updateAppTheme(),
                  );
                },
              ),
            )
          ],
        ),
        body: const QuoteList(),
      ),
    );
  }
}
