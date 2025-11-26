import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int id;
  final String email;
  final String fullName;
  final String? profilePicture;
  final String? phoneNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLogin;
  
  // Statistics
  final int totalScans;
  final int authenticScans;
  final int deepfakeScans;
  
  // Account Status
  final bool isActive;
  final bool isVerified;

  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.profilePicture,
    this.phoneNumber,
    this.createdAt,
    this.updatedAt,
    this.lastLogin,
    this.totalScans = 0,
    this.authenticScans = 0,
    this.deepfakeScans = 0,
    this.isActive = true,
    this.isVerified = false,
  });

  // Factory constructor to create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
   
    final firstName = json['first_name']?.toString() ?? '';
    final lastName = json['last_name']?.toString() ?? '';

    return UserModel(
      id: json['pk'] ?? 0,
      email: json['email'] ?? '',
      fullName: '$firstName $lastName'.trim(),
      profilePicture: json['profile_image'],
      phoneNumber: json['phone_number'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      lastLogin: json['last_login'] != null
          ? DateTime.parse(json['last_login'])
          : null,
      totalScans: json['total_scans'] ?? 0,
      authenticScans: json['authentic_scans'] ?? 0,
      deepfakeScans: json['deepfake_scans'] ?? 0,
      isActive: json['is_active'] ?? true,
      isVerified: json['is_verified'] ?? false,
    );
  }

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'pk': id,
      'email': email,
      'full_name': fullName,
      'profile_image': profilePicture,
      'phone_number': phoneNumber,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'last_login': lastLogin?.toIso8601String(),
      'total_scans': totalScans,
      'authentic_scans': authenticScans,
      'deepfake_scans': deepfakeScans,
      'is_active': isActive,
      'is_verified': isVerified,
    };
  }

  // Copy with method for immutability
  UserModel copyWith({
    int? id,
    String? email,
    String? fullName,
    String? profilePicture,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLogin,
    int? totalScans,
    int? authenticScans,
    int? deepfakeScans,
    bool? isActive,
    bool? isVerified,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      profilePicture: profilePicture ?? this.profilePicture,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLogin: lastLogin ?? this.lastLogin,
      totalScans: totalScans ?? this.totalScans,
      authenticScans: authenticScans ?? this.authenticScans,
      deepfakeScans: deepfakeScans ?? this.deepfakeScans,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  // Empty user model
  static const UserModel empty = UserModel(
    id: 0,
    email: '',
    fullName: '',
  );

  // Check if user is empty
  bool get isEmpty => this == UserModel.empty;
  bool get isNotEmpty => this != UserModel.empty;

  // Get first name
  String get firstName {
    final names = fullName.split(' ');
    return names.isNotEmpty ? names.first : '';
  }

  // Get last name
  String get lastName {
    final names = fullName.split(' ');
    return names.length > 1 ? names.last : '';
  }

  // Get initials for avatar
  String get initials {
    final names = fullName.split(' ');
    if (names.isEmpty) return '';
    if (names.length == 1) return names[0][0].toUpperCase();
    return '${names[0][0]}${names[1][0]}'.toUpperCase();
  }

  // Calculate accuracy rate
  double get accuracyRate {
    if (totalScans == 0) return 0.0;
    return (authenticScans / totalScans) * 100;
  }

  // Get detection rate
  double get detectionRate {
    if (totalScans == 0) return 0.0;
    return (deepfakeScans / totalScans) * 100;
  }

  // Account age in days
  int get accountAgeDays {
    if (createdAt == null) return 0;
    return DateTime.now().difference(createdAt!).inDays;
  }

  // Days since last login
  int? get daysSinceLastLogin {
    if (lastLogin == null) return null;
    return DateTime.now().difference(lastLogin!).inDays;
  }

  @override
  List<Object?> get props => [
        id,
        email,
        fullName,
        profilePicture,
        phoneNumber,
        createdAt,
        updatedAt,
        lastLogin,
        totalScans,
        authenticScans,
        deepfakeScans,
        isActive,
        isVerified,
      ];

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, fullName: $fullName, totalScans: $totalScans)';
  }
}