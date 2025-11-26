import 'package:truthlens_mobile/data/model/auth/login_request.dart';
import 'package:truthlens_mobile/data/model/auth/login_response.dart';
import 'package:truthlens_mobile/data/model/auth/signup_request.dart';
import 'package:truthlens_mobile/data/model/auth/signup_response.dart';
import 'package:truthlens_mobile/data/model/user_model.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(LoginRequest request);
  Future<SignupResponse> signup(SignupRequest request);
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<String?> getToken();
  Future<String?> getRefreshToken();
  Future<void> saveToken(String token);
  Future<void> saveRefreshToken(String refreshToken);
  Future<UserModel?> getCurrentUser();
  Future<void> clearLocalData();
  Future<void> saveUserData(dynamic user);
  Future<String> refreshToken(String refreshToken);
  // authenticate with google
  Future<LoginResponse> loginWithGoogle();
}
