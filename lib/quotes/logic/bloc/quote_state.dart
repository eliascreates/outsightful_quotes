part of 'quote_bloc.dart';

enum QuoteStatus { initial, success, failure }

class QuoteState extends Equatable {
  const QuoteState({
    this.status = QuoteStatus.initial,
    this.result = const Result(pagination: Pagination(currentPage: 0, nextPage: 1, totalPages: 1), quotes: <Quote>[]),
    this.hasReachedMax = false,
  });

  final QuoteStatus status;
  final Result result;
  final bool hasReachedMax;
  @override
  List<Object?> get props => [status, result, hasReachedMax];

  QuoteState copyWith({
    QuoteStatus? status,
    Result? result,
    bool? hasReachedMax,
  }) {
    return QuoteState(
      status: status ?? this.status,
      result: result ?? this.result,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() =>
      'QuoteState {status: $status, result: ${result.quotes.length}, hasReachedMax: $hasReachedMax';
}
