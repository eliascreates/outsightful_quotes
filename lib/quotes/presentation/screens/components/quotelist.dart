import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';

import 'package:outsightful_quotes/core/strings.dart';
import 'package:outsightful_quotes/core/values.dart';
import 'package:outsightful_quotes/quotes/logic/bloc/quote_bloc.dart';

import '../../../quotes.dart';
import 'display_message.dart';
import 'quotelist_item.dart';

class QuoteList extends StatefulWidget {
  const QuoteList({super.key});

  @override
  State<QuoteList> createState() => _QuoteListState();
}

class _QuoteListState extends State<QuoteList> {
  final _scrollController = ScrollController();

  SMIInput<bool>? _isDropped;
  Artboard? _bookArtboard;

  @override
  void initState() {
    super.initState();
    loadBookAnimation();
    _scrollController.addListener(_onScroll);
    _scrollController.addListener(_runAnimation);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        if (context.watch<QuoteBloc>().state.status != QuoteStatus.initial &&
            context.watch<QuoteBloc>().state.status != QuoteStatus.failure)
          SliverAppBar(
            title: const Text(Strings.homeTitle),
            expandedHeight: 200,
            floating: true,
            pinned: true,
            snap: true,
            stretch: true,
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
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.none,
              background: _bookArtboard == null
                  ? const SizedBox()
                  : Rive(
                      artboard: _bookArtboard!,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        BlocBuilder<QuoteBloc, QuoteState>(
          builder: (context, state) {
            switch (state.status) {
              case QuoteStatus.failure:
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.network_check,
                            color: Theme.of(context).hintColor),
                        const SizedBox(height: Values.defaultPadding),
                        const Text(Strings.quotesLoadError),
                        const SizedBox(height: Values.defaultPadding),
                        ElevatedButton(
                          onPressed: () => context.read<QuoteBloc>()
                            ..add(QuotesRestared())
                            ..add(QuotesFetched()),
                          child: const Text(Strings.networkInitialError),
                        )
                      ],
                    ),
                  ),
                );
              case QuoteStatus.success:
                final quotes = state.result.quotes;
                if (quotes.isEmpty) {
                  return const DisplayMessage(
                    child: Text(Strings.emptyQuotesLoad),
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
                return const DisplayMessage(
                  child: CircularProgressIndicator(),
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

  void _bookDropAnimation() {
    if (_isDropped?.value == false &&
        _isDropped?.controller.isActive == false) {
      _isDropped?.value = true;
    } else if (_isDropped?.value == true &&
        _isDropped?.controller.isActive == false) {
      _isDropped?.value = false;
    }
  }

  void _runAnimation() {
    if (_scrollController.offset < _scrollController.initialScrollOffset) {
      _bookDropAnimation();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;

    final maxScrollPos = _scrollController.position.maxScrollExtent;
    final currentScrollPos = _scrollController.offset;

    return currentScrollPos >= (maxScrollPos * 0.9);
  }

  void loadBookAnimation() {
    rootBundle.load(Strings.bookdropAnimation).then((data) {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;

      var controller =
          StateMachineController.fromArtboard(artboard, 'bookdrop');
      if (controller != null) {
        artboard.addController(controller);
        _isDropped = controller.findInput('isDropped');
      }

      setState(() => _bookArtboard = artboard);
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }
}
