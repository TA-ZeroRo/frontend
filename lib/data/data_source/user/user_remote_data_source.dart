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
    final response = await _dio.post('/users/', data: request.toJson());
    return UserDto.fromJson(response.data);
  }

  /// Get user by ID
  /// GET /users/{user_id}
  Future<UserDto> getUser(String userId) async {
    final response = await _dio.get('/users/$userId');
    return UserDto.fromJson(response.data);
  }

  /// Update user information
  /// PUT /users/{user_id}
  Future<UserDto> updateUser(String userId, UpdateUserRequest request) async {
    final response = await _dio.put('/users/$userId', data: request.toJson());
    return UserDto.fromJson(response.data);
  }

  /// Delete user
  /// DELETE /users/{user_id}
  Future<void> deleteUser(String userId) async {
    await _dio.delete('/users/$userId');
  }
}
