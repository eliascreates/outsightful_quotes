part of 'quote_bloc.dart';

sealed class QuoteEvent {
  const QuoteEvent();
}

class QuotesFetched extends QuoteEvent {}

class QuotesRestared extends QuoteEvent {}
