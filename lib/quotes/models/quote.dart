import 'dart:convert';

class Quote {
  final String id;
  final String quoteText;
  final String quoteAuthor;
  final String quoteGenre;
  const Quote({
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
