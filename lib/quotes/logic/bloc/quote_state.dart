// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'quote_bloc.dart';

enum QuoteStatus { initial, success, failure }

class QuoteState extends Equatable {
  const QuoteState({
    this.status = QuoteStatus.initial,
    required this.result,
    this.hasReachedMax = false,
  });

  final QuoteStatus status;
  final Result? result;
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
}
