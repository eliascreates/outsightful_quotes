import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../models/quote.dart';
import 'package:stream_transform/stream_transform.dart';

part 'quote_event.dart';
part 'quote_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (event, mapper) {
    return droppable<E>().call(event.throttle(duration), mapper);
  };
}

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  final http.Client httpClient;

  QuoteBloc({required this.httpClient})
      : super(const QuoteState(result: null)) {
    on<QuotesFetched>(_onQuotesFetched,
        transformer: throttleDroppable(throttleDuration));
  }

  Future<void> _onQuotesFetched(
    QuotesFetched event,
    Emitter<QuoteState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == QuoteStatus.initial) {
        final results = await _fetchResults();
        print('xxxxxxxxxxxxx: $results');
        emit(state.copyWith(
          status: QuoteStatus.success,
          result: results,
          hasReachedMax: false,
        ));
      }
      final results =
          await _fetchResults(state.result?.pagination.nextPage as int);

      emit(
        results.quotes.isEmpty
            ? state.copyWith(hasReachedMax: true)
            : state.copyWith(status: QuoteStatus.success, result: results),
      );
    } catch (_) {
      print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
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
    print('noooo');
    throw Exception('Failed to fetch Results');
  }
}
