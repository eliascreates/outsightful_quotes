import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outsightful_quotes/core/values.dart';
import 'package:outsightful_quotes/quotes/logic/cubit/theme_cubit.dart';
import 'package:outsightful_quotes/quotes/models/quote.dart';

class QuoteListItem extends StatelessWidget {
  const QuoteListItem({super.key, required this.quote});

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.symmetric(horizontal: Values.defaultPadding * 0.75)
              .copyWith(bottom: Values.defaultPadding),
      padding: const EdgeInsets.all(Values.defaultPadding),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: context.watch<ThemeCubit>().state.isDarkTheme
              ? BorderRadius.circular(10)
              : null,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.2),
              blurRadius: 3,
              spreadRadius: 0.5,
              offset: const Offset(-1, 1),
            )
          ],
          border: Border.fromBorderSide(BorderSide(
              color: Theme.of(context).primaryColor.withOpacity(0.1)))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            quote.quoteText,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 2),
          ),
          const SizedBox(height: Values.defaultPadding * 0.75),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(child: Divider(thickness: 1)),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Values.defaultPadding / 2),
                child: Text(
                  quote.quoteAuthor,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const Expanded(child: Divider(thickness: 1)),
            ],
          ),
        ],
      ),
    );
  }
}
