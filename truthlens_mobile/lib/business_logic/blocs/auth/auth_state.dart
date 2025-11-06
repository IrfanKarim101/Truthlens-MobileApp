
import 'package:equatable/equatable.dart';
import 'package:truthlens_mobile/data/model/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// Initial State
class AuthInitial extends AuthState {
  const AuthInitial();
}

// Loading State
class AuthLoading extends AuthState {
  const AuthLoading();
}

// Authenticated State (User logged in)
class Authenticated extends AuthState {
  final UserModel user;
  final String token;

  const Authenticated({
    required this.user,
    required this.token,
  });

  @override
  List<Object?> get props => [user, token];
}

// Unauthenticated State (User logged out)
class Unauthenticated extends AuthState {
  final String? message;

  const Unauthenticated({this.message});

  @override
  List<Object?> get props => [message];
}

// Auth Error State
class AuthError extends AuthState {
  final String message;
  final String? errorCode;

  const AuthError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

// Auth Success State (for signup/login feedback)
class AuthSuccess extends AuthState {
  final String message;
  final UserModel user;

  const AuthSuccess({
    required this.message,
    required this.user,
  });

  @override
  List<Object?> get props => [message, user];
}