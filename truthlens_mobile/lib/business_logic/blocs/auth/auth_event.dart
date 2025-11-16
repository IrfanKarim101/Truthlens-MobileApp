import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// Login Event
class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

// Signup Event
class SignupRequested extends AuthEvent {
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;

  const SignupRequested({
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [fullName, email, password, confirmPassword];
}

// Logout Event
class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

// Check Auth Status Event
class CheckAuthStatus extends AuthEvent {
  const CheckAuthStatus();
}

// Auto Login Event (from stored token)
class AutoLoginRequested extends AuthEvent {
  const AutoLoginRequested();
}

// Refresh Token Event
class RefreshTokenRequested extends AuthEvent {
  const RefreshTokenRequested();
}

// Google Login Event
class GoogleLoginRequested extends AuthEvent {
  const GoogleLoginRequested();
}

// Google auto login Event
class GoogleAutoLoginRequested extends AuthEvent {
  const GoogleAutoLoginRequested();
}
