import 'package:truthlens_mobile/core/constants/api_constants.dart';
import 'package:truthlens_mobile/core/errors/exceptions.dart';
import 'package:truthlens_mobile/core/network/dio_client.dart';
import 'package:truthlens_mobile/data/model/auth/login_request.dart';
import 'package:truthlens_mobile/data/model/auth/login_response.dart';
import 'package:truthlens_mobile/data/model/auth/signup_request.dart';
import 'package:truthlens_mobile/data/model/auth/signup_response.dart';

class AuthApiService {
  final DioClient _dioClient;
  
  AuthApiService(this._dioClient);
  
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.login,
        data: request.toJson(),
      );
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  Future<SignupResponse> signup(SignupRequest request) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.signup,
        data: request.toJson(),
      );
      return SignupResponse.fromJson(response.data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}