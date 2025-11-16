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
        options: Options(headers: {'Content-Type': 'application/json'}),
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
      await _dioClient.post(ApiConstants.logout);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // authenticate with google
  Future<LoginResponse> loginWithGoogle({
    required String? idToken,
    required String? accessToken,
}) async {
    // --- Step 1: Send Google Tokens to Django Backend for Authentication ---
    final loginResponse = await _dioClient.post(
        ApiConstants.googleLogin,
        data: {'id_token': idToken, 'access_token': accessToken},
    );
    debugPrint('Google Login Response: ${loginResponse.data}');

    // 1. Check if the response contains the 'key' (Django success signal)
    if (loginResponse.data is Map<String, dynamic> &&
        loginResponse.data.containsKey('key')) {
        
        final token = loginResponse.data['key'] as String;

        // --- Step 2: Configure Dio for the Profile Fetch ---
        // Your API requires the token (key) to be in the Authorization header.
        // Assuming your Dio client handles setting the Authorization header globally.
        // If not, you must manually set it before the GET request: 
       _dioClient.dio.options.headers['Authorization'] = 'Token $token';
        
        // --- Step 3: Fetch User Profile using the new Django Token ---
        // *Correction:* Do NOT use idToken or accessToken as query parameters here. 
        // The endpoint needs the Django token set in the header (Step 2).
        final userResponse = await _dioClient.get(
            ApiConstants.getProfile,
           queryParameters: {},
        );
        debugPrint('Google Profile Response: ${userResponse.data}');
        
        // --- Step 4: Parse the Profile Data ---
        final apiUserJson = userResponse.data;
        
        // Assuming the response data directly maps to your UserInfo model
        final userInfo = UserInfo.fromJson(apiUserJson);

        // --- Step 5: Construct the Final Success Response ---
        final loginData = LoginData(
            user: userInfo, // Now populated with real data!
            token: token,
            refreshToken: null, // Assuming refresh token isn't returned here
        );

        return LoginResponse(
            success: true,
            message: 'Login successful',
            data: loginData,
        );
    }

    // 4. Fallback for standard or error responses (non-200 or unexpected structure)
    return LoginResponse.fromJson(loginResponse.data);
}
}
