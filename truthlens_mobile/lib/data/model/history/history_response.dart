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
    final itemsList = json['data'] != null
        ? (json['data'] is List
            ? (json['data'] as List)
                .map((item) => HistoryItem.fromJson(item))
                .toList()
            : json['data']['items'] != null
                ? (json['data']['items'] as List)
                    .map((item) => HistoryItem.fromJson(item))
                    .toList()
                : <HistoryItem>[])
        : <HistoryItem>[];

    return HistoryResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      items: itemsList,
      totalCount: json['data']?['total_count'] ?? itemsList.length,
      currentPage: json['data']?['current_page'] ?? 1,
      totalPages: json['data']?['total_pages'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': {
        'items': items.map((item) => item.toJson()).toList(),
        'total_count': totalCount,
        'current_page': currentPage,
        'total_pages': totalPages,
      },
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
