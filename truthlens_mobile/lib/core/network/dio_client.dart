import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import '../errors/exceptions.dart';
import 'api_intercepter.dart';

class DioClient {
  late final Dio _dio;

  DioClient(ApiInterceptor interceptor) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        validateStatus: (status) => status! < 500, // handle manually
      ),
    );

    _dio.interceptors.add(interceptor);

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          error: true,
        ),
      );
    }
  }

  // Generic GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      _checkHttpError(response);
      return response;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  // Generic POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      _checkHttpError(response);
      return response;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  // POST with FormData (file upload)
  Future<Response> postFormData(
    String path,
    FormData formData, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: options,
        onSendProgress: onSendProgress,
      );
      _checkHttpError(response);
      return response;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  // Generic PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      _checkHttpError(response);
      return response;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  // Generic DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      _checkHttpError(response);
      return response;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  // Download file
  Future<Response> download(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        options: options,
      );
      _checkHttpError(response);
      return response;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  // --------------------
  // ERROR HANDLING
  // --------------------

  Exception _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException();

      case DioExceptionType.connectionError:
        return NetworkException();

      case DioExceptionType.cancel:
        return CancelledException();

      case DioExceptionType.badResponse:
        return _mapHttpStatusToException(error.response);

      default:
        return UnknownException(error.message ?? 'An unknown error occurred');
    }
  }

  // Map HTTP status codes to your exceptions
  TruthLensException _mapHttpStatusToException(Response? response) {
    if (response == null) return ServerException();

    final msg = _extractErrorMessage(response.data);
    switch (response.statusCode) {
      case 400:
        return BadRequestException(msg, 400);
      case 401:
        return UnauthorizedException(msg, 401);
      case 403:
        return ForbiddenException(msg, 403);
      case 404:
        return NotFoundException(msg, 404);
      case 409:
        return ConflictException(msg, 409);
      case 500:
        return InternalServerException(msg, 500);
      default:
        return ServerException(msg, response.statusCode);
    }
  }

  // Extract meaningful error message from response
  String _extractErrorMessage(dynamic data) {
    if (data == null) return 'Unknown error occurred';

    if (data is Map<String, dynamic>) {
      return data['message'] ??
          data['error'] ??
          data['detail'] ??
          'Unknown error occurred';
    }

    return data.toString();
  }

  // Optional: manually check for HTTP errors if validateStatus allows them
  void _checkHttpError(Response response) {
    if (response.statusCode != null && response.statusCode! >= 400) {
      throw _mapHttpStatusToException(response);
    }
  }

  // Expose Dio instance for advanced use
  Dio get dio => _dio;
}
