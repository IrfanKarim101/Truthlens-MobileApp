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
    final response = await _dioClient.post(
      ApiConstants.googleLogin,
      data: {'id_token': idToken, 'access_token': accessToken},
    );
    debugPrint('Google Login Response: ${response.data}');

    // 1. Check if the response contains the 'key' (Django success signal)
    if (response.data is Map<String, dynamic> &&
        response.data.containsKey('key')) {
      final token = response.data['key'] as String;

      // 2. Create the internal LoginData structure, mapping 'key' to 'token'.
      //    Note: Since the server only returns the token key, you might need
      //    to fetch the full UserInfo in a separate call or adapt your backend.
      //    For now, we will create a LoginData object containing only the token.

      // WARNING: This assumes your backend only returns the token on success.
      // You will need to pass dummy/empty UserInfo or fetch the user details later.

      // Assuming your UserModel can be partially or fully constructed later:
      final dummyUser = UserInfo(
        id: 0,
        email: 'temp@user.com',
        fullName: 'Google User',
      ); // Replace with actual parsing/fetch

      final loginData = LoginData(
        user: dummyUser, // **FIXME: Must be populated with real user data.**
        token: token,
        refreshToken: null,
      );

      // 3. Manually construct the successful LoginResponse object.
      return LoginResponse(
        success: true, // Manually set to true because we got a 200 and a key.
        message: 'Login successful',
        data: loginData,
      );
    }

    // 4. Fallback for standard or error responses (non-200 or unexpected structure)
    // This line is still needed if your backend ever returns a structured error
    // with success: false. If not, you might need more robust error handling.
    return LoginResponse.fromJson(response.data);
  }
}
