import '../model/user/user.dart';

abstract class UserRepository {
  Future<User> createUser({
    required String userId,
    required String username,
    required String region,
  });

  Future<User> getUser(String userId);

  //TODO: total_points, continuous_days 이런건 어떻게 할까요?
  Future<User> updateUser({
    required String userId,
    String? username,
    String? userImg,
    String? region,
    List<String>? characters,
  });

  Future<void> deleteUser(String userId);
}
