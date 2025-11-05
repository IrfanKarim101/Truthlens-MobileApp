import 'package:equatable/equatable.dart';
import 'package:truthlens_mobile/data/model/auth/login_response.dart';

class SignupResponse extends Equatable {
  final bool success;
  final String message;
  final SignupData? data;

  const SignupResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? SignupData.fromJson(json['data']) : null,
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

class SignupData extends Equatable {
  final UserInfo user;
  final String token;
  final String? refreshToken;

  const SignupData({
    required this.user,
    required this.token,
    this.refreshToken,
  });

  factory SignupData.fromJson(Map<String, dynamic> json) {
    return SignupData(
      user: UserInfo.fromJson(json['user']),
      token: json['token'] ?? '',
      refreshToken: json['refresh_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
      'refresh_token': refreshToken,
    };
  }

  @override
  List<Object?> get props => [user, token, refreshToken];
}

// Reusing UserInfo class from login_response.dart
// You can move UserInfo to a separate file like user_model.dart
// and import it in both login_response.dart and signup_response.dart

// ==================== USER MODEL (SHARED) ====================
// File: lib/data/models/user_model.dart
// This is the shared UserInfo that can be used across the app

// class UserModel extends Equatable {
//   final int id;
//   final String email;
//   final String fullName;
//   final String? profilePicture;
//   final DateTime? createdAt;
//   final int totalScans;
//   final int authenticScans;
//   final int deepfakeScans;

//   const UserModel({
//     required this.id,
//     required this.email,
//     required this.fullName,
//     this.profilePicture,
//     this.createdAt,
//     this.totalScans = 0,
//     this.authenticScans = 0,
//     this.deepfakeScans = 0,
//   });

//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       id: json['id'] ?? 0,
//       email: json['email'] ?? '',
//       fullName: json['full_name'] ?? '',
//       profilePicture: json['profile_picture'],
//       createdAt: json['created_at'] != null
//           ? DateTime.parse(json['created_at'])
//           : null,
//       totalScans: json['total_scans'] ?? 0,
//       authenticScans: json['authentic_scans'] ?? 0,
//       deepfakeScans: json['deepfake_scans'] ?? 0,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'email': email,
//       'full_name': fullName,
//       'profile_picture': profilePicture,
//       'created_at': createdAt?.toIso8601String(),
//       'total_scans': totalScans,
//       'authentic_scans': authenticScans,
//       'deepfake_scans': deepfakeScans,
//     };
//   }

//   UserModel copyWith({
//     int? id,
//     String? email,
//     String? fullName,
//     String? profilePicture,
//     DateTime? createdAt,
//     int? totalScans,
//     int? authenticScans,
//     int? deepfakeScans,
//   }) {
//     return UserModel(
//       id: id ?? this.id,
//       email: email ?? this.email,
//       fullName: fullName ?? this.fullName,
//       profilePicture: profilePicture ?? this.profilePicture,
//       createdAt: createdAt ?? this.createdAt,
//       totalScans: totalScans ?? this.totalScans,
//       authenticScans: authenticScans ?? this.authenticScans,
//       deepfakeScans: deepfakeScans ?? this.deepfakeScans,
//     );
//   }

//   @override
//   List<Object?> get props => [
//         id,
//         email,
//         fullName,
//         profilePicture,
//         createdAt,
//         totalScans,
//         authenticScans,
//         deepfakeScans,
//       ];
// }

// ==================== ERROR RESPONSE ====================
// File: lib/data/models/auth/auth_error_response.dart

class AuthErrorResponse extends Equatable {
  final bool success;
  final String message;
  final Map<String, dynamic>? errors;

  const AuthErrorResponse({
    required this.success,
    required this.message,
    this.errors,
  });

  factory AuthErrorResponse.fromJson(Map<String, dynamic> json) {
    return AuthErrorResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? 'An error occurred',
      errors: json['errors'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'errors': errors,
    };
  }

  @override
  List<Object?> get props => [success, message, errors];
}