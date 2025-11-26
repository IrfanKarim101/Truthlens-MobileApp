import 'package:equatable/equatable.dart';
import '../analysis/analysis_result.dart';

class HistoryDetailResponse extends Equatable {
  final bool success;
  final String message;
  final AnalysisResult? data;

  const HistoryDetailResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory HistoryDetailResponse.fromJson(Map<String, dynamic> json) {
    return HistoryDetailResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? AnalysisResult.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data?.toJson()};
  }

  @override
  List<Object?> get props => [success, message, data];
}
