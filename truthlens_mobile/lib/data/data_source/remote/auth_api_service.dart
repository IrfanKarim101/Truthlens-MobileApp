import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
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

  //logout
  Future<void> logout() async {
    try {
      await _dioClient.post(
        ApiConstants.logout,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // authenticate with google
  Future<LoginResponse> loginWithGoogle({
  required String? idToken,
  required String? accessToken,
}) async {
  final response = await _dioClient.post(
    ApiConstants.googleLogin,
    data: {
      'id_token': idToken,
      'access_token': accessToken,
    },
  );
  debugPrint('Google Login Response: ${response.data}');
  return LoginResponse.fromJson(response.data);
}

  

}
