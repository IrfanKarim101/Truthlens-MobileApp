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
  })  : _apiService = apiService,
        _secureStorage = secureStorage,
        _sharedPrefs = sharedPrefs;

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _apiService.login(request);
    
    // Save user data locally
    if (response.success && response.data != null) {
      await _saveUserData(response.data!.user);
    }
    
    return response;
  }

  @override
  Future<SignupResponse> signup(SignupRequest request) async {
    final response = await _apiService.signup(request);
    
    // Save user data locally
    if (response.success && response.data != null) {
      await _saveUserData(response.data!.user);
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
    final userJson = await _sharedPrefs.getUserData();
    if (userJson != null) {
      return UserModel.fromJson(userJson);
    }
    return null;
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

  // Helper method to save user data
  Future<void> _saveUserData(dynamic user) async {
    final userModel = user is UserModel ? user : UserModel.fromJson(user.toJson());
    await _sharedPrefs.saveUserData(userModel.toJson());
    await _secureStorage.saveUserId(userModel.id.toString());
    await _secureStorage.saveUserEmail(userModel.email);
  }
}

