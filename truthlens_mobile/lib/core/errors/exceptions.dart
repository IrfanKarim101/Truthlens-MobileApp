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
  NoInternetException([String message = 'No internet connection. Please check your network settings.'])
      : super(message);
}

class ServerException extends TruthLensException {
  ServerException([String message = 'Server error. Please try again later.', int? statusCode])
      : super(message, statusCode: statusCode);
}

class BadRequestException extends TruthLensException {
  BadRequestException([String message = 'Bad request. Please check your input.', int? statusCode])
      : super(message, statusCode: statusCode);
}

class UnauthorizedException extends TruthLensException {
  UnauthorizedException([String message = 'Unauthorized access. Please log in again.', int? statusCode])
      : super(message, statusCode: statusCode);
}

class ForbiddenException extends TruthLensException {
  ForbiddenException([String message = 'Access denied. You do not have permission to perform this action.', int? statusCode])
      : super(message, statusCode: statusCode);
}

class NotFoundException extends TruthLensException {
  NotFoundException([String message = 'Resource not found.', int? statusCode])
      : super(message, statusCode: statusCode);
}

class ConflictException extends TruthLensException {
  ConflictException([String message = 'Conflict occurred.', int? statusCode])
      : super(message, statusCode: statusCode);
}

class InternalServerException extends TruthLensException {
  InternalServerException([String message = 'Internal server error. Please try again later.', int? statusCode])
      : super(message, statusCode: statusCode);
}

class FormatException extends TruthLensException {
  FormatException([String message = 'Invalid data format.'])
      : super(message);
}

class CacheException extends TruthLensException {
  CacheException([String message = 'Cache error.'])
      : super(message);
}

class UnknownException extends TruthLensException {
  UnknownException([String message = 'An unknown error occurred.'])
      : super(message);
}

