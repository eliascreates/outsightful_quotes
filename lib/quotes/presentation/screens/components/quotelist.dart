import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outsightful_quotes/quotes/logic/bloc/quote_bloc.dart';
import 'package:outsightful_quotes/quotes/presentation/screens/components/quotelist_item.dart';

class QuoteList extends StatefulWidget {
  const QuoteList({super.key});

  @override
  State<QuoteList> createState() => _QuoteListState();
}

class _QuoteListState extends State<QuoteList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuoteBloc, QuoteState>(
      builder: (context, state) {
        switch (state.status) {
          case QuoteStatus.failure:
            return const Center(
              child: Text('Unable to Load Quotes'),
            );
          case QuoteStatus.success:
            final quotes = state.result!.quotes;
            if (quotes.isEmpty) {
              return const Center(
                child: Text('No Quotes at the moment!'),
              );
            }
            return ListView.builder(
              itemCount:
                  state.hasReachedMax ? quotes.length : quotes.length + 1,
                  controller: _scrollController,
              itemBuilder: (context, index) {
                return index >= quotes.length
                    ? const Center(child: CircularProgressIndicator())
                    : index == 0
                        ? Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: QuoteListItem(quote: quotes[index]),
                          )
                        : QuoteListItem(quote: quotes[index]);
              },
            );
          case QuoteStatus.initial:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void _onScroll() {
    if (_isBottom) context.read<QuoteBloc>().add(QuotesFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;


    final maxScrollPos = _scrollController.position.maxScrollExtent;
    final currentScrollPos = _scrollController.offset;

    return currentScrollPos >= (maxScrollPos * 0.9);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }
}