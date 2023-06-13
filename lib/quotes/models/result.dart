import 'dart:convert';

import 'pagination.dart';
import 'quote.dart';

class Result {
  const Result({required this.pagination, required this.quotes});

  final Pagination pagination;
  final List<Quote> quotes;

  Result copyWith({
    Pagination? pagination,
    List<Quote>? quotes,
  }) {
    return Result(
      pagination: pagination ?? this.pagination,
      quotes: quotes ?? this.quotes,
    );
  }

  factory Result.empty() {
    return const Result(
        pagination: Pagination(currentPage: 1, nextPage: 2, totalPages: 10),
        quotes: <Quote>[]);
  }

  factory Result.fromMap(Map<String, dynamic> map) {
    return Result(
      pagination: Pagination.fromMap(map['pagination'] as Map<String, dynamic>),
      quotes: List<Quote>.from(
        (map['data'] as List<dynamic>).map<Quote>(
          (x) => Quote.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  factory Result.fromJson(String source) =>
      Result.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Quote(pagination: $pagination, data: ${quotes.length})';
  }
}