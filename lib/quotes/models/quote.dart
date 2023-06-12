import 'dart:convert';

class Result {
  Result({required this.pagination, required this.quotes});
  
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

class Pagination {
  final int currentPage;
  final int nextPage;
  final int totalPages;
  Pagination({
    required this.currentPage,
    required this.nextPage,
    required this.totalPages,
  });

  factory Pagination.fromMap(Map<String, dynamic> map) {
    return Pagination(
      currentPage: map['currentPage'] as int,
      nextPage: map['nextPage'] as int,
      totalPages: map['totalPages'] as int,
    );
  }

  factory Pagination.fromJson(String source) => Pagination.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Quote {
  final String id;
  final String quoteText;
  final String quoteAuthor;
  final String quoteGenre;
  Quote({
    required this.id,
    required this.quoteText,
    required this.quoteAuthor,
    required this.quoteGenre,
  });

  Quote copyWith({
    String? id,
    String? quoteText,
    String? quoteAuthor,
    String? quoteGenre,
  }) {
    return Quote(
    id: id ?? this.id,
      quoteText: quoteText ?? this.quoteText,
      quoteAuthor: quoteAuthor ?? this.quoteAuthor,
      quoteGenre: quoteGenre ?? this.quoteGenre,
    );
  }

  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(
      id: map['_id'] as String,
      quoteText: map['quoteText'] as String,
      quoteAuthor: map['quoteAuthor'] as String,
      quoteGenre: map['quoteGenre'] as String,
    );
  }

  factory Quote.fromJson(String source) =>
      Quote.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Data(_id: $id, quoteText: $quoteText, quoteAuthor: $quoteAuthor, quoteGenre: $quoteGenre)';
  }

}
