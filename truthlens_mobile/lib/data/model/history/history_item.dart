import 'package:equatable/equatable.dart';
import '../analysis/analysis_result.dart';

class HistoryItem extends Equatable {
  final String id;
  final String fileName;
  final String fileType; // 'image' or 'video'
  final bool isAuthentic;
  final int confidence;
  final String thumbnailUrl;
  final DateTime createdAt;
  final String status; // 'completed', 'processing', 'failed'

  const HistoryItem({
    required this.id,
    required this.fileName,
    required this.fileType,
    required this.isAuthentic,
    required this.confidence,
    required this.thumbnailUrl,
    required this.createdAt,
    this.status = 'completed',
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id']?.toString() ?? '',
      fileName: json['file_name'] ?? '',
      fileType: json['file_type'] ?? 'image',
      isAuthentic: json['is_authentic'] ?? false,
      confidence: json['confidence'] ?? 0,
      thumbnailUrl: json['thumbnail_url'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      status: json['status'] ?? 'completed',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'file_name': fileName,
      'file_type': fileType,
      'is_authentic': isAuthentic,
      'confidence': confidence,
      'thumbnail_url': thumbnailUrl,
      'created_at': createdAt.toIso8601String(),
      'status': status,
    };
  }

  // Helper getters
  bool get isImage => fileType.toLowerCase() == 'image';
  bool get isVideo => fileType.toLowerCase() == 'video';
  bool get isCompleted => status == 'completed';
  bool get isProcessing => status == 'processing';
  bool get isFailed => status == 'failed';

  // Get status text
  String get statusText {
    if (isAuthentic) return 'Authentic';
    return 'Deepfake Detected';
  }

  // Get confidence text
  String get confidenceText => '$confidence% confidence';

  // Get time ago
  String get timeAgo {
    final difference = DateTime.now().difference(createdAt);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  // Get formatted date
  String get formattedDate {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[createdAt.month - 1]} ${createdAt.day}, ${createdAt.year}';
  }

  // Get formatted time
  String get formattedTime {
    final hour = createdAt.hour > 12 ? createdAt.hour - 12 : createdAt.hour;
    final period = createdAt.hour >= 12 ? 'PM' : 'AM';
    final minute = createdAt.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  @override
  List<Object?> get props => [
        id,
        fileName,
        fileType,
        isAuthentic,
        confidence,
        thumbnailUrl,
        createdAt,
        status,
      ];
}