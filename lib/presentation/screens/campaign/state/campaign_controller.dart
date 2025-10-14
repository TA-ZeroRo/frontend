import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/model/campaign_recruiting/campaign_recruiting.dart';

// Mock data for campaign recruitings
final List<CampaignRecruiting> _mockCampaignRecruitings = [
  CampaignRecruiting(
    id: 1,
    userId: 'user1',
    username: '환경지킴이',
    userImg: null,
    title: '플로깅 크루원 모집',
    recruitmentCount: 5,
    campaignName: '한강 플로깅 챌린지',
    requirements: '매주 주말에 함께 플로깅할 수 있는 분을 찾습니다. 초보자도 환영합니다!',
    url: 'https://example.com/campaign1',
    createdAt: DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
  ),
  CampaignRecruiting(
    id: 2,
    userId: 'user2',
    username: '그린라이프',
    userImg: null,
    title: '제로웨이스트 챌린지 참여자 모집',
    recruitmentCount: 3,
    campaignName: '30일 제로웨이스트 챌린지',
    requirements: '한 달 동안 일회용품 사용을 줄이고 기록을 공유할 수 있는 분을 찾습니다.',
    url: null,
    createdAt: DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
  ),
  CampaignRecruiting(
    id: 3,
    userId: 'user3',
    username: '에코워리어',
    userImg: null,
    title: '비건 챌린지 크루 모집',
    recruitmentCount: 4,
    campaignName: '일주일 비건 챌린지',
    requirements: '일주일 동안 비건 식단을 실천하고 레시피를 공유할 수 있는 분을 모집합니다.',
    url: 'https://example.com/vegan-challenge',
    createdAt: DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
  ),
];

// Campaign Recruitings state
class CampaignRecruitingsNotifier extends AsyncNotifier<List<CampaignRecruiting>> {
  @override
  Future<List<CampaignRecruiting>> build() async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockCampaignRecruitings;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      return _mockCampaignRecruitings;
    });
  }

  Future<void> createCampaignRecruiting({
    required String title,
    required int recruitmentCount,
    required String campaignName,
    required String requirements,
    String? url,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      final currentRecruitings = state.value ?? [];
      final newRecruiting = CampaignRecruiting(
        id: DateTime.now().millisecondsSinceEpoch,
        userId: 'current_user',
        username: 'Current User',
        userImg: null,
        title: title,
        recruitmentCount: recruitmentCount,
        campaignName: campaignName,
        requirements: requirements,
        url: url,
        createdAt: DateTime.now().toIso8601String(),
      );
      return [newRecruiting, ...currentRecruitings];
    });
  }

  Future<void> updateCampaignRecruiting({
    required int id,
    required String title,
    required int recruitmentCount,
    required String campaignName,
    required String requirements,
    String? url,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      final currentRecruitings = state.value ?? [];
      return currentRecruitings.map((recruiting) {
        if (recruiting.id == id) {
          return recruiting.copyWith(
            title: title,
            recruitmentCount: recruitmentCount,
            campaignName: campaignName,
            requirements: requirements,
            url: url,
          );
        }
        return recruiting;
      }).toList();
    });
  }

  Future<void> deleteCampaignRecruiting(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      final currentRecruitings = state.value ?? [];
      return currentRecruitings.where((recruiting) => recruiting.id != id).toList();
    });
  }
}

final campaignRecruitingsProvider =
    AsyncNotifierProvider<CampaignRecruitingsNotifier, List<CampaignRecruiting>>(
  CampaignRecruitingsNotifier.new,
);
