
import 'package:equatable/equatable.dart';

class SignupRequest extends Equatable {
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;

  const SignupRequest({
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email': email,
      'password': password,
      'confirm_password': confirmPassword,
    };
  }

  // Validation method
  bool isValid() {
    return fullName.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        password == confirmPassword &&
        password.length >= 8;
  }

  @override
  List<Object?> get props => [fullName, email, password, confirmPassword];
}