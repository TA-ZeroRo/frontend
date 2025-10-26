import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../domain/model/user/user.dart';
import '../../../../../../domain/model/post/post.dart';
import '../../community/state/community_controller.dart';

class UserNotifier extends Notifier<User> {
  @override
  User build() {
    return User(
      id: 'user_001',
      username: '제로로로',
      totalPoints: 1250,
      continuousDays: 7,
      region: '서울',
      characters: [],
      lastActiveAt: DateTime.now(),
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );
  }

  void updateUsername(String username) {
    state = state.copyWith(username: username);
  }

  void updateUserImage(String? imageUrl) {
    state = state.copyWith(userImg: imageUrl);
  }

  void updatePoints(int points) {
    state = state.copyWith(totalPoints: points);
  }

  void updateContinuousDays(int days) {
    state = state.copyWith(continuousDays: days);
  }

  void updateRegion(String region) {
    state = state.copyWith(region: region);
  }

  void updateCharacters(List<String> characters) {
    state = state.copyWith(characters: characters);
  }

  void updateUser({
    String? username,
    String? userImg,
    String? region,
    List<String>? characters,
  }) {
    User updatedUser = state;

    if (username != null) {
      updatedUser = updatedUser.copyWith(username: username);
    }
    if (userImg != null) {
      updatedUser = updatedUser.copyWith(userImg: userImg);
    }
    if (region != null) {
      updatedUser = updatedUser.copyWith(region: region);
    }
    if (characters != null) {
      updatedUser = updatedUser.copyWith(characters: characters);
    }

    state = updatedUser;
  }
}

final userProvider = NotifierProvider<UserNotifier, User>(
  UserNotifier.new,
);

/// 사용자가 작성한 게시글 필터링 Provider
///
/// 커뮤니티의 전체 게시글에서 현재 프로필 사용자의 게시글만 필터링
/// - postsProvider: 커뮤니티 전체 게시글 데이터 소스
/// - userId: 필터링할 사용자 ID
///
/// 백엔드에서 필터링 API가 구현되면 이 Provider를 제거하고
/// 백엔드 API 호출로 대체 예정
final userPostsProvider = FutureProvider.family<List<Post>, String>((
  ref,
  userId,
) async {
  final postsAsync = await ref.watch(postsProvider.future);
  return postsAsync.where((post) => post.userId == userId).toList();
});
