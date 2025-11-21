import 'package:equatable/equatable.dart';
import 'analysis_metrics.dart';
import 'file_info.dart';

class AnalysisResult extends Equatable {
  final int id;
  final bool isAuthentic;
  final int confidence;
  final AnalysisMetrics metrics;
  final FileInfo fileInfo;
  final double analysisTime;
  final DateTime timestamp;
  final String? recommendation;

  const AnalysisResult({
    required this.id,
    required this.isAuthentic,
    required this.confidence,
    required this.metrics,
    required this.fileInfo,
    required this.analysisTime,
    required this.timestamp,
    this.recommendation,
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      id: json['id'] ?? 0,
      isAuthentic: json['prediction'] ?? false,
      confidence: json['score'] ?? 0,
      metrics: AnalysisMetrics.fromJson(json['metrics'] ?? {}),
      fileInfo: FileInfo.fromJson(json['file_info'] ?? {}),
      analysisTime: (json['time_taken'] ?? 0).toDouble(),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      recommendation: json['recommendation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prediction': isAuthentic,
      'score': confidence,
      'metrics': metrics.toJson(),
      'file_info': fileInfo.toJson(),
      'time_taken': analysisTime,
      'timestamp': timestamp.toIso8601String(),
      'recommendation': recommendation,
    };
  }

  // Get status text
  String get statusText => isAuthentic ? 'Authentic' : 'Deepfake Detected';

  // Get confidence text
  String get confidenceText => '$confidence% confidence';

  // Get analysis time formatted
  String get analysisTimeFormatted => '${analysisTime.toStringAsFixed(1)}s';

  // Get time ago
  String get timeAgo {
    final difference = DateTime.now().difference(timestamp);
    
    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${(difference.inDays / 7).floor()} weeks ago';
    }
  }

  // Get recommendation or default text
  String get recommendationText {
    if (recommendation != null && recommendation!.isNotEmpty) {
      return recommendation!;
    }
    
    return isAuthentic
        ? 'This image appears to be authentic. All indicators suggest natural photographic characteristics with no signs of manipulation.'
        : 'This content shows signs of manipulation. We recommend verifying the source and treating this media with caution. Consider additional verification methods.';
  }

  @override
  List<Object?> get props => [
        id,
        isAuthentic,
        confidence,
        metrics,
        fileInfo,
        analysisTime,
        timestamp,
        recommendation,
      ];
}