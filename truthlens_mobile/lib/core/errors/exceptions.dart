class TruthLensException implements Exception {
  final String message;
  final int? statusCode;

  TruthLensException(this.message, {this.statusCode});

  @override
  String toString() {
    if (statusCode != null) {
      return 'TruthLensException: $message (Status Code: $statusCode)';
    }
    return 'TruthLensException: $message';
  }
}

class NoInternetException extends TruthLensException {
  NoInternetException([
    super.message =
        'No internet connection. Please check your network settings.',
  ]);
}

class ServerException extends TruthLensException {
  ServerException([
    super.message = 'Server error. Please try again later.',
    int? statusCode,
  ]) : super(statusCode: statusCode);
}

class BadRequestException extends TruthLensException {
  BadRequestException([
    super.message = 'Bad request. Please check your input.',
    int? statusCode,
  ]) : super(statusCode: statusCode);
}

class UnauthorizedException extends TruthLensException {
  UnauthorizedException([
    super.message = 'Unauthorized access. Please log in again.',
    int? statusCode,
  ]) : super(statusCode: statusCode);
}

class ForbiddenException extends TruthLensException {
  ForbiddenException([
    super.message =
        'Access denied. You do not have permission to perform this action.',
    int? statusCode,
  ]) : super(statusCode: statusCode);
}

class NotFoundException extends TruthLensException {
  NotFoundException([super.message = 'Resource not found.', int? statusCode])
    : super(statusCode: statusCode);
}

class ConflictException extends TruthLensException {
  ConflictException([super.message = 'Conflict occurred.', int? statusCode])
    : super(statusCode: statusCode);
}

class InternalServerException extends TruthLensException {
  InternalServerException([
    super.message = 'Internal server error. Please try again later.',
    int? statusCode,
  ]) : super(statusCode: statusCode);
}

class FormatException extends TruthLensException {
  FormatException([super.message = 'Invalid data format.']);
}

class CacheException extends TruthLensException {
  CacheException([super.message = 'Cache error.']);
}

class UnknownException extends TruthLensException {
  UnknownException([super.message = 'An unknown error occurred.']);
}

class TimeoutException extends TruthLensException {
  TimeoutException([
    super.message = 'The connection has timed out. Please try again later.',
  ]);
}

class NetworkException extends TruthLensException {
  NetworkException([
    super.message = 'Network error occurred. Please check your connection.',
  ]);
}


class CancelledException extends TruthLensException {
  CancelledException([super.message = 'The request was cancelled.']);
}