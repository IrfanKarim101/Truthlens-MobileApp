
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:truthlens_mobile/core/utils/secure_storage_helper.dart';
import 'package:truthlens_mobile/presentation/routes/app_router.dart';


class ApiInterceptor extends Interceptor {
  final SecureStorageHelper _secureStorage;

  ApiInterceptor(this._secureStorage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add authorization token to headers
    final token = await _secureStorage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Add content type
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';

    // Log request in debug mode
    if (kDebugMode) {
      print('┌── REQUEST ────────────────────────────────────────');
      print('│ ${options.method} ${options.uri}');
      print('│ Headers: ${options.headers}');
      if (options.data != null) {
        print('│ Body: ${options.data}');
      }
      if (options.queryParameters.isNotEmpty) {
        print('│ Query: ${options.queryParameters}');
      }
      print('└───────────────────────────────────────────────────');
    }

    return handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    // Log response in debug mode
    if (kDebugMode) {
      print('┌── RESPONSE ───────────────────────────────────────');
      print('│ ${response.statusCode} ${response.requestOptions.uri}');
      print('│ Data: ${response.data}');
      print('└───────────────────────────────────────────────────');
    }

    return handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Log error in debug mode
    if (kDebugMode) {
      print('┌── ERROR ──────────────────────────────────────────');
      print('│ ${err.requestOptions.method} ${err.requestOptions.uri}');
      print('│ Status Code: ${err.response?.statusCode}');
      print('│ Error Type: ${err.type}');
      print('│ Message: ${err.message}');
      print('│ Response: ${err.response?.data}');
      print('└───────────────────────────────────────────────────');
    }

    // Handle 401 Unauthorized - Token expired
    if (err.response?.statusCode == 401) {
      // Try to refresh token
      final refreshed = await _refreshToken();
      
      if (refreshed) {
        // Retry the original request
        try {
          final opts = err.requestOptions;
          final token = await _secureStorage.getToken();
          opts.headers['Authorization'] = 'Bearer $token';
          
          final response = await Dio().request(
            opts.path,
            options: Options(
              method: opts.method,
              headers: opts.headers,
            ),
            data: opts.data,
            queryParameters: opts.queryParameters,
          );
          
          return handler.resolve(response);
        } catch (e) {
          // If retry fails, proceed with original error
          return handler.next(err);
        }
      } else {
        // Refresh failed - logout user
        await _secureStorage.clearAll();
        // TODO: Navigate to login screen
        // Navigator.of(AppRouter.navigatorKey.currentContext!)
        //     .pushNamedAndRemoveUntil('/login', (route) => false);
        
      }
    }

    return handler.next(err);
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _secureStorage.getRefreshToken();
      if (refreshToken == null) return false;

      // TODO: Call refresh token API
      // final response = await Dio().post(
      //   '${ApiConstants.baseUrl}/auth/refresh/',
      //   data: {'refresh_token': refreshToken},
      // );
      
      // if (response.statusCode == 200) {
      //   final newToken = response.data['token'];
      //   await _secureStorage.saveToken(newToken);
      //   return true;
      // }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Token refresh failed: $e');
      }
      return false;
    }
  }
}