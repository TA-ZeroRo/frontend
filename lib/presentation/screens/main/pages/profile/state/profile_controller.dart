import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../domain/model/profile/profile.dart';
import '../../../../../../domain/model/post/post.dart';
import '../../community/state/community_controller.dart';

class ProfileNotifier extends Notifier<Profile> {
  @override
  Profile build() {
    return const Profile(
      userId: 'user_001',
      username: '제로로로',
      totalPoints: 1250,
      continuousDays: 7,
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

  void updateBirthDate(DateTime? birthDate) {
    state = state.copyWith(birthDate: birthDate);
  }

  void updateRegion(String? region) {
    state = state.copyWith(region: region);
  }

  void updateProfile({
    String? username,
    String? userImg,
    DateTime? birthDate,
    String? region,
  }) {
    Profile updatedProfile = state;

    if (username != null) {
      updatedProfile = updatedProfile.copyWith(username: username);
    }
    if (userImg != null) {
      updatedProfile = updatedProfile.copyWith(userImg: userImg);
    }
    if (birthDate != null) {
      updatedProfile = updatedProfile.copyWith(birthDate: birthDate);
    }
    if (region != null) {
      updatedProfile = updatedProfile.copyWith(region: region);
    }

    state = updatedProfile;
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, Profile>(
  ProfileNotifier.new,
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
