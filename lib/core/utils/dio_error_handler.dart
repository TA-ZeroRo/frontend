import 'package:dio/dio.dart';

/// Common DioException handler for all data sources
class DioErrorHandler {
  /// Converts DioException to user-friendly Exception
  static Exception handle(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception(
          'Connection timeout. Please check your internet connection.',
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;

        // Check if response.data is Map or String
        String message = 'Unknown error occurred';
        final responseData = error.response?.data;

        if (responseData is Map<String, dynamic>) {
          // FastAPI uses 'detail', others may use 'message'
          message = responseData['detail'] ?? responseData['message'] ?? message;
        } else if (responseData is String) {
          message = responseData;
        }

        return Exception('Server error ($statusCode): $message');
      case DioExceptionType.cancel:
        return Exception('Request was cancelled');
      default:
        return Exception('Network error: ${error.message}');
    }
  }
}
