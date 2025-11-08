import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'mock/user_mock_data.dart';

/// 사용자 정보를 관리하는 Notifier (Mock 데이터 사용)
///
/// Mock 데이터를 사용하여 UI 개발 및 테스트를 위한
/// 프로필 페이지 전용 사용자 정보를 관리합니다.
class UserNotifier extends Notifier<ProfileUser> {
  @override
  ProfileUser build() {
    // Mock 데이터 반환
    return ProfileUser.getMockUser();
  }

  /// 사용자 정보 새로고침 (Mock)
  void refreshUser(String userId) {
    // Mock 데이터 다시 로드
    state = ProfileUser.getMockUser();
  }

  /// 현재 사용자 정보 새로고침 (RefreshIndicator용, Mock)
  void refresh() {
    // Mock 데이터 다시 로드
    state = ProfileUser.getMockUser();
  }

  /// 사용자 정보 업데이트 (부분 업데이트, Mock)
  ///
  /// null이 아닌 필드만 업데이트됩니다.
  void updateUserInfo({
    String? username,
    String? userImg,
    String? region,
    List<String>? characters,
  }) {
    state = state.copyWith(
      username: username,
      userImg: userImg,
      region: region,
      characters: characters,
    );
  }

  /// 로컬 상태만 업데이트
  ///
  /// 다른 작업의 결과로 사용자 정보가 변경되었을 때 사용
  void updateLocalState(ProfileUser user) {
    state = user;
  }

  /// 포인트 증가 (로컬 상태만)
  ///
  /// 실제 포인트 변경은 별도 API를 통해 이루어지며,
  /// 이 메서드는 UI 반영만 담당합니다.
  void incrementPoints(int points) {
    state = state.copyWith(totalPoints: state.totalPoints + points);
  }

  /// 연속 일수 업데이트 (로컬 상태만)
  void updateContinuousDays(int days) {
    state = state.copyWith(continuousDays: days);
  }
}

/// 사용자 정보 Provider (Mock 데이터 사용)
final userProvider = NotifierProvider<UserNotifier, ProfileUser>(
  UserNotifier.new,
);
