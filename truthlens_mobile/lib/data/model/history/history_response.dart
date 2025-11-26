import 'package:equatable/equatable.dart';
import 'history_item.dart';

class HistoryResponse extends Equatable {
  final bool success;
  final String message;
  final List<HistoryItem> items;
  final int totalCount;
  final int currentPage;
  final int totalPages;

  const HistoryResponse({
    required this.success,
    required this.message,
    required this.items,
    this.totalCount = 0,
    this.currentPage = 1,
    this.totalPages = 1,
  });

  factory HistoryResponse.fromJson(Map<String, dynamic> json) {
    // Parse the 'results' list
    final itemsList = (json['results'] as List<dynamic>?)
            ?.map((item) => HistoryItem.fromJson(item))
            .toList() ??
        [];

    final totalCount = json['total_results'] ?? itemsList.length;
    final pageSize = itemsList.isNotEmpty ? itemsList.length : 10;

    return HistoryResponse(
      success: true, // API returned 200
      message: '',
      items: itemsList,
      totalCount: totalCount,
      currentPage: 1, // API does not provide page, default to 1
      totalPages: (totalCount / pageSize).ceil(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'results': items.map((item) => item.toJson()).toList(),
      'total_results': totalCount,
    };
  }

  bool get hasMore => currentPage < totalPages;
  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  @override
  List<Object?> get props => [
        success,
        message,
        items,
        totalCount,
        currentPage,
        totalPages,
      ];
}
