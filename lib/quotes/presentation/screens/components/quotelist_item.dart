import 'package:flutter/material.dart';
import 'package:outsightful_quotes/quotes/models/quote.dart';

class QuoteListItem extends StatelessWidget {
  const QuoteListItem({super.key, required this.quote});

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5).copyWith(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade300, blurRadius: 4.0, spreadRadius: 5)
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            quote.quoteText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(width: 15),
          Text(
            quote.quoteAuthor,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
