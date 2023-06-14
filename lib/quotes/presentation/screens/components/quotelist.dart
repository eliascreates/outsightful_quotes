import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outsightful_quotes/core/strings.dart';
import 'package:outsightful_quotes/core/values.dart';
import 'package:outsightful_quotes/quotes/logic/bloc/quote_bloc.dart';
import '../../../quotes.dart';
import 'quotelist_item.dart';

class QuoteList extends StatefulWidget {
  const QuoteList({super.key});

  @override
  State<QuoteList> createState() => _QuoteListState();
}
//TODO: Add an Animation in Sliver App Bar
class _QuoteListState extends State<QuoteList> {
  final _scrollController = ScrollController();
  // late RiveAnimationController _bookController;
  @override
  void initState() {
    super.initState();
    // _bookController = OneShotAnimation(
    //   'bounce',
    //   autoplay: false,
    //   onStop: () => {},
    //   onStart: () => {},
    // );
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        if (context.watch<QuoteBloc>().state.status != QuoteStatus.initial)
          SliverAppBar(
            title: const Text(Strings.homeTitle),
            expandedHeight: 200,
            actions: [
              Padding(
                padding:
                    const EdgeInsets.only(right: Values.defaultPadding / 2),
                child: BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, state) {
                    return Switch(
                      value: state.isDarkTheme,
                      onChanged: (_) =>
                          context.read<ThemeCubit>().updateAppTheme(),
                    );
                  },
                ),
              ),
            ],
            flexibleSpace: const FlexibleSpaceBar(
              background: SizedBox()/* RiveAnimation.asset(
                'assets/bookdrop.riv',
                
                fit: BoxFit.cover,
              ) */,
            ),
          ),
        BlocBuilder<QuoteBloc, QuoteState>(
          builder: (context, state) {
            switch (state.status) {
              case QuoteStatus.failure:
                return SliverToBoxAdapter(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.network_check,
                            color: Theme.of(context).hintColor),
                        const SizedBox(height: Values.defaultPadding),
                        const Text('Unable to Load Quotes'),
                        const SizedBox(height: Values.defaultPadding),
                        ElevatedButton(
                          onPressed: () => context.read<QuoteBloc>()
                            ..add(QuotesRestared())
                            ..add(QuotesFetched()),
                          child: const Text('Try Again!'),
                        )
                      ],
                    ),
                  ),
                );
              case QuoteStatus.success:
                final quotes = state.result.quotes;
                if (quotes.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Text('No Quotes at the moment!'),
                    ),
                  );
                }
                return SliverList.builder(
                  itemCount:
                      state.hasReachedMax ? quotes.length : quotes.length + 1,
                  itemBuilder: (context, index) {
                    return index >= quotes.length
                        ? const Center(child: CircularProgressIndicator())
                        : index == 0
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    top: Values.defaultPadding),
                                child: QuoteListItem(quote: quotes[index]),
                              )
                            : QuoteListItem(quote: quotes[index]);
                  },
                );
              case QuoteStatus.initial:
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
            }
          },
        ),
      ],
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
