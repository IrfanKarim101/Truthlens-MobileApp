import 'package:equatable/equatable.dart';

class DeleteHistoryResponse extends Equatable {
  final bool success;
  final String message;

  const DeleteHistoryResponse({
    required this.success,
    required this.message,
  });

  factory DeleteHistoryResponse.fromJson(Map<String, dynamic> json) {
    return DeleteHistoryResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }

  @override
  List<Object?> get props => [success, message];
}
