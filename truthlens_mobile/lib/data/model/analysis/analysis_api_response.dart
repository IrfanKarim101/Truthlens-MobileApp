
import 'package:equatable/equatable.dart';
import 'analysis_result.dart';

class AnalysisApiResponse extends Equatable {
  final bool success;
  final String message;
  final AnalysisResult? data;

  const AnalysisApiResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory AnalysisApiResponse.fromJson(Map<String, dynamic> json) {
    return AnalysisApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null 
          ? AnalysisResult.fromJson(json['data']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }

  @override
  List<Object?> get props => [success, message, data];
}