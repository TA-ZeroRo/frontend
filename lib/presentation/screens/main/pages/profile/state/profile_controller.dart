import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../domain/model/profile_model.dart';

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
    state = state.copyWith(
      username: username,
      userImg: userImg,
      birthDate: birthDate,
      region: region,
    );
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, Profile>(
  ProfileNotifier.new,
);
