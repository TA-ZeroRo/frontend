import 'package:dio/dio.dart';

import '../../core/utils/dio_error_handler.dart';

/// Interceptor that converts all DioExceptions to user-friendly exceptions
class ErrorHandlerInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Convert DioException to user-friendly exception
    final handledException = DioErrorHandler.handle(err);

    // Reject with new DioException containing the converted error
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: handledException,
        response: err.response,
        type: err.type,
      ),
    );
  }
}
