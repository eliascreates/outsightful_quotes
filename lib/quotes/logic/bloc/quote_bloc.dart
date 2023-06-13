import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:outsightful_quotes/quotes/models/pagination.dart';
import 'package:stream_transform/stream_transform.dart';

import 'package:outsightful_quotes/core/values.dart';
import 'package:outsightful_quotes/quotes/models/result.dart';

import '../../models/quote.dart';

part 'quote_event.dart';
part 'quote_state.dart';

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (event, mapper) {
    return droppable<E>().call(event.throttle(duration), mapper);
  };
}

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  final http.Client httpClient;

  QuoteBloc({required this.httpClient}) : super(const QuoteState()) {
    on<QuotesFetched>(_onQuotesFetched,
        transformer: throttleDroppable(Values.throttleDuration));

    on<QuotesRestared>((event, emit) => emit(const QuoteState()));
  }

  Future<void> _onQuotesFetched(
    QuotesFetched event,
    Emitter<QuoteState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == QuoteStatus.initial) {
        final results = await _fetchResults();
        emit(state.copyWith(
          status: QuoteStatus.success,
          result: results,
          hasReachedMax: false,
        ));
      }
      final results =
          await _fetchResults(state.result.pagination.nextPage);

      emit(
        results.quotes.isEmpty
            ? state.copyWith(hasReachedMax: true)
            : state.copyWith(
                status: QuoteStatus.success,
                result: state.result.copyWith(
                  quotes: List.of(state.result.quotes)..addAll(results.quotes),
                ),
              ),
      );
    } catch (_) {
      emit(state.copyWith(status: QuoteStatus.failure));
    }
  }

  Future<Result> _fetchResults([int pageNum = 1]) async {
    final response = await httpClient.get(
      Uri.parse(
          'https://quote-garden.onrender.com/api/v3/quotes?page=$pageNum'),
    );

    if (response.statusCode == 200) {
      return Result.fromJson(response.body);
    }
    throw Exception('Failed to fetch Results');
  }
}
