import 'package:injectable/injectable.dart';

import '../../core/logger/logger.dart';
import '../../domain/model/user/user.dart';
import '../../domain/repository/user_repository.dart';
import '../data_source/user/user_remote_data_source.dart';
import '../dto/user/create_user_request.dart';
import '../dto/user/update_user_request.dart';

@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  UserRepositoryImpl(this._remoteDataSource);

  @override
  Future<User> createUser({
    required String userId,
    String? userImg,
    required String username,
    required String region,
  }) async {
    try {
      final request = CreateUserRequest(
        id: userId,
        userImg: userImg,
        username: username,
        region: region,
      );
      final result = await _remoteDataSource.createUser(request);
      return result.toModel();
    } catch (e) {
      CustomLogger.logger.e('createUser - 유저 생성 실패', error: e);
      rethrow;
    }
  }

  @override
  Future<User> getUser(String userId) async {
    try {
      final result = await _remoteDataSource.getUser(userId);
      return result.toModel();
    } catch (e) {
      CustomLogger.logger.e('getUser - 유저 조회 실패 (userId: $userId)', error: e);
      rethrow;
    }
  }

  @override
  Future<User> updateUser({
    required String userId,
    String? username,
    String? userImg,
    String? region,
    List<String>? characters,
  }) async {
    try {
      final request = UpdateUserRequest(
        username: username,
        userImg: userImg,
        region: region,
        characters: characters,
      );
      final result = await _remoteDataSource.updateUser(userId, request);
      return result.toModel();
    } catch (e) {
      CustomLogger.logger.e(
        'updateUser - 유저 업데이트 실패 (userId: $userId)',
        error: e,
      );
      rethrow;
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      await _remoteDataSource.deleteUser(userId);
    } catch (e) {
      CustomLogger.logger.e(
        'deleteUser - 유저 삭제 실패 (userId: $userId)',
        error: e,
      );
      rethrow;
    }
  }
}
