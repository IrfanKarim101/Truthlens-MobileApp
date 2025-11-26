
import 'package:equatable/equatable.dart';

class LoginResponse extends Equatable {
  final bool success;
  final String message;
  final LoginData? data;

  const LoginResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? LoginData.fromJson(json['data']) : null,
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

class LoginData extends Equatable {
  final UserInfo user;
  final String token;
  final String? refreshToken;

  const LoginData({
    required this.user,
    required this.token,
    this.refreshToken,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
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

class UserInfo extends Equatable {
  final int id;
  final String email;
  final String fullName;
  final String? profilePicture;
  final DateTime? createdAt;

  const UserInfo({
    required this.id,
    required this.email,
    required this.fullName,
    this.profilePicture,
    this.createdAt,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['pk'] ?? 0,
      email: json['email'] ?? '',
      fullName:'${json['first_name'] as String? ?? ''} ${json['last_name'] as String? ?? ''}'.trim(),
      profilePicture: json['profile_picture'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pk': id,
      'email': email,
      'full_name': fullName,
      'profile_image': profilePicture,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, email, fullName, profilePicture, createdAt];
}