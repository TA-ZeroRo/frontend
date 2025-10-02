import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../domain/model/profile.dart';

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
}

final profileProvider = NotifierProvider<ProfileNotifier, Profile>(
  ProfileNotifier.new,
);
