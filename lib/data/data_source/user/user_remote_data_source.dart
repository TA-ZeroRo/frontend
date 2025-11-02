import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../dto/user/create_user_request.dart';
import '../../dto/user/update_user_request.dart';
import '../../dto/user/user_dto.dart';

@injectable
class UserRemoteDataSource {
  final Dio _dio;

  UserRemoteDataSource(this._dio);

  /// Create a new user
  /// POST /users
  Future<UserDto> createUser(CreateUserRequest request) async {
    try {
      final response = await _dio.post('/users/', data: request.toJson());
      return UserDto.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get user by ID
  /// GET /users/{user_id}
  Future<UserDto> getUser(String userId) async {
    try {
      final response = await _dio.get('/users/$userId');
      return UserDto.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update user information
  /// PUT /users/{user_id}
  Future<UserDto> updateUser(String userId, UpdateUserRequest request) async {
    try {
      final response = await _dio.put('/users/$userId', data: request.toJson());
      return UserDto.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete user
  /// DELETE /users/{user_id}
  Future<void> deleteUser(String userId) async {
    try {
      await _dio.delete('/users/$userId');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception(
          'Connection timeout. Please check your internet connection.',
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;

        // response.data가 Map인지 String인지 확인
        String message = 'Unknown error occurred';
        final responseData = error.response?.data;

        if (responseData is Map<String, dynamic>) {
          message = responseData['message'] ?? message;
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
