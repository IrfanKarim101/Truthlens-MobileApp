
import 'package:equatable/equatable.dart';

class UploadResponse extends Equatable {
  final bool success;
  final String message;
  final String? analysisId;
  final String? status; // 'processing', 'completed', 'failed'

  const UploadResponse({
    required this.success,
    required this.message,
    this.analysisId,
    this.status,
  });

  factory UploadResponse.fromJson(Map<String, dynamic> json) {
    return UploadResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      analysisId: json['analysis_id'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'analysis_id': analysisId,
      'status': status,
    };
  }

  @override
  List<Object?> get props => [success, message, analysisId, status];
}
