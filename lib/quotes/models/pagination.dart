import 'dart:convert';

class Pagination {
  final int currentPage;
  final int nextPage;
  final int totalPages;
  const Pagination({
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

  factory Pagination.fromJson(String source) =>
      Pagination.fromMap(json.decode(source) as Map<String, dynamic>);
}