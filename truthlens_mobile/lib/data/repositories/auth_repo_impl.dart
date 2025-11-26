import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:truthlens_mobile/core/utils/secure_storage_helper.dart';
import 'package:truthlens_mobile/data/data_source/remote/auth_api_service.dart';
import 'package:truthlens_mobile/data/model/auth/login_request.dart';
import 'package:truthlens_mobile/data/model/auth/login_response.dart';
import 'package:truthlens_mobile/data/model/auth/signup_request.dart';
import 'package:truthlens_mobile/data/model/auth/signup_response.dart';
import 'package:truthlens_mobile/data/model/user_model.dart';
import 'package:truthlens_mobile/data/repositories/auth_repo.dart';
import 'package:truthlens_mobile/core/utils/shared_prefs_helper.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _apiService;
  final SecureStorageHelper _secureStorage;
  final SharedPrefsHelper _sharedPrefs;

  AuthRepositoryImpl({
    required AuthApiService apiService,
    required SecureStorageHelper secureStorage,
    required SharedPrefsHelper sharedPrefs,
  }) : _apiService = apiService,
       _secureStorage = secureStorage,
       _sharedPrefs = sharedPrefs;

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _apiService.login(request);

    // Save user data locally
    if (response.success && response.data != null) {
      await saveUserData(response.data!.user);
    }

    return response;
  }

  @override
  Future<SignupResponse> signup(SignupRequest request) async {
    final response = await _apiService.signup(request);

    // Save user data locally
    if (response.success && response.data != null) {
      await saveUserData(response.data!.user);
    }

    return response;
  }

  @override
  Future<void> logout() async {
    // Optional: Call logout API
    // await _apiService.logout();

    // Clear all local data
    await clearLocalData();
  }

  @override
  Future<bool> isLoggedIn() async {
    return await _secureStorage.isLoggedIn();
  }

  @override
  Future<String?> getToken() async {
    return await _secureStorage.getToken();
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _secureStorage.getRefreshToken();
  }

  @override
  Future<void> saveToken(String token) async {
    await _secureStorage.saveToken(token);
  }

  @override
  Future<void> saveRefreshToken(String refreshToken) async {
    await _secureStorage.saveRefreshToken(refreshToken);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final userJson = _sharedPrefs.getUserData();

    if (userJson != null) {
      try {
        // CRITICAL: Safely attempt to deserialize the UserModel.
        return UserModel.fromJson(userJson);
      } catch (e, st) {
        //FAIL ED DESERIALIZATION: This is your repeated login cause.
        debugPrintStack(stackTrace: st);

        // CRITICAL STEP: Clear the corrupted user data and token to force a clean login.
        await clearLocalData(); // Assuming this clears both secure token and user data

        return null; // Force failure of the auto-login check.
      }
    }
    return null;
  }

  // Helper method to save user data
  @override
  Future<void> saveUserData(dynamic user) async {
    final userModel = user;
    await _sharedPrefs.saveUserData(userModel.toJson());
    await _secureStorage.saveUserId(userModel.id.toString());
    await _secureStorage.saveUserEmail(userModel.email);
  }

  @override
  Future<void> clearLocalData() async {
    await _secureStorage.clearAll();
    await _sharedPrefs.clearAll();
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    // TODO: Implement refresh token API call
    throw UnimplementedError();
  }

  // Google Sign-In implementation
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId:
        '168723626833-ft8g77c7a9m1ktakqumdlie5jb6t37oi.apps.googleusercontent.com',
  );

  @override
  Future<LoginResponse> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception("User canceled Google Sign-In");
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;

      // Check if idToken exists
      if (idToken == null) {
        throw Exception("Failed to retrieve idToken from Google Sign-In");
      }

      // Step 3: Send tokens to your backend via ApiService (assuming your API service takes idToken and accessToken)
      final response = await _apiService.loginWithGoogle(
        idToken: idToken,
        accessToken: accessToken,
      );

      //   Step 4: Save user data locally if login is successful
      if (response.success && response.data != null) {
        await saveUserData(response.data!.user);
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
