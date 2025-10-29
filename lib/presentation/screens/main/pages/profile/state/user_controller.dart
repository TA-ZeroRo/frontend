import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/di/injection.dart';
import '../../../../../../core/logger/logger.dart';
import '../../../../../../domain/model/user/user.dart';
import '../../../../../../domain/repository/user_repository.dart';

/// 사용자 정보를 관리하는 AsyncNotifier
///
/// UserRepository를 통해 실제 백엔드 API와 통신하여
/// 사용자 정보를 CRUD 합니다.
class UserNotifier extends AsyncNotifier<User> {
  late final UserRepository _userRepository;

  @override
  Future<User> build() async {
    _userRepository = getIt<UserRepository>();

    // TODO: 실제 로그인된 사용자 ID로 교체 필요
    // 현재는 임시로 하드코딩된 ID 사용
    const tempUserId = 'user_001';

    try {
      // 백엔드에서 사용자 정보 로드
      return await _userRepository.getUser(tempUserId);
    } catch (e) {
      CustomLogger.logger.e('UserNotifier - 사용자 정보 로드 실패', error: e);

      // 에러 시 기본값 반환 (임시)
      return User(
        id: tempUserId,
        username: '게스트',
        totalPoints: 0,
        continuousDays: 0,
        region: '미설정',
        characters: [],
        lastActiveAt: DateTime.now(),
        createdAt: DateTime.now(),
      );
    }
  }

  /// 사용자 정보 새로고침
  Future<void> refreshUser(String userId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _userRepository.getUser(userId));
  }

  /// 현재 사용자 정보 새로고침 (RefreshIndicator용)
  Future<void> refresh() async {
    final currentUser = state.value;
    if (currentUser == null) {
      // 사용자 정보가 없으면 build를 재실행
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() => build());
      return;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _userRepository.getUser(currentUser.id),
    );
  }

  /// 사용자 정보 업데이트 (부분 업데이트)
  ///
  /// null이 아닌 필드만 서버에 전송되어 업데이트됩니다.
  Future<void> updateUserInfo({
    String? username,
    String? userImg,
    String? region,
    List<String>? characters,
  }) async {
    final currentUser = state.value;
    if (currentUser == null) {
      CustomLogger.logger.w('updateUserInfo - 현재 사용자 정보가 없습니다');
      return;
    }

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      return await _userRepository.updateUser(
        userId: currentUser.id,
        username: username,
        userImg: userImg,
        region: region,
        characters: characters,
      );
    });

    if (state.hasError) {
      CustomLogger.logger.e(
        'updateUserInfo - 사용자 정보 업데이트 실패',
        error: state.error,
      );
    } else {
      CustomLogger.logger.d('updateUserInfo - 사용자 정보 업데이트 성공');
    }
  }

  /// 로컬 상태만 업데이트 (서버에 전송하지 않음)
  ///
  /// 다른 작업의 결과로 사용자 정보가 변경되었을 때 사용
  void updateLocalState(User user) {
    state = AsyncValue.data(user);
  }

  /// 포인트 증가 (로컬 상태만)
  ///
  /// 실제 포인트 변경은 별도 API를 통해 이루어지며,
  /// 이 메서드는 UI 반영만 담당합니다.
  void incrementPoints(int points) {
    final currentUser = state.value;
    if (currentUser != null) {
      state = AsyncValue.data(
        currentUser.copyWith(totalPoints: currentUser.totalPoints + points),
      );
    }
  }

  /// 연속 일수 업데이트 (로컬 상태만)
  void updateContinuousDays(int days) {
    final currentUser = state.value;
    if (currentUser != null) {
      state = AsyncValue.data(currentUser.copyWith(continuousDays: days));
    }
  }
}

/// 사용자 정보 Provider
///
/// AsyncNotifier를 사용하여 비동기 데이터를 관리합니다.
final userProvider = AsyncNotifierProvider<UserNotifier, User>(
  UserNotifier.new,
);
