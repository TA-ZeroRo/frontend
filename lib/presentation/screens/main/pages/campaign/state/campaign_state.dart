import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/di/injection.dart';
import '../../../../../../domain/model/campaign/campaign.dart';
import '../../../../../../domain/repository/campaign_repository.dart';
import '../../../../../../domain/repository/mission_repository.dart';
import '../../../../entry/state/auth_controller.dart';
import '../../activity/state/activity_state.dart';
import '../models/campaign_data.dart';

/// 캠페인 필터 상태
class CampaignFilter {
  final String region;
  final String city;
  final String category;
  final DateTime? startDate;
  final DateTime? endDate;

  const CampaignFilter({
    this.region = '전체',
    this.city = '전체',
    this.category = '전체',
    this.startDate,
    this.endDate,
  });

  CampaignFilter copyWith({
    String? region,
    String? city,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
    bool clearDates = false,
  }) {
    return CampaignFilter(
      region: region ?? this.region,
      city: city ?? this.city,
      category: category ?? this.category,
      startDate: clearDates ? null : (startDate ?? this.startDate),
      endDate: clearDates ? null : (endDate ?? this.endDate),
    );
  }
}

/// 캠페인 필터 Notifier
class CampaignFilterNotifier extends Notifier<CampaignFilter> {
  @override
  CampaignFilter build() {
    return const CampaignFilter();
  }

  /// 지역 변경
  void setRegion(String region) {
    state = state.copyWith(region: region);
  }

  /// 시 변경
  void setCity(String city) {
    state = state.copyWith(city: city);
  }

  /// 카테고리 변경
  void setCategory(String category) {
    state = state.copyWith(category: category);
  }

  /// 기간 설정
  void setDateRange(DateTime? startDate, DateTime? endDate) {
    state = state.copyWith(startDate: startDate, endDate: endDate);
  }

  /// 기간 초기화
  void clearDateRange() {
    state = state.copyWith(clearDates: true);
  }

  /// 필터 초기화
  void reset() {
    state = const CampaignFilter();
  }
}

/// 캠페인 필터 Provider
final campaignFilterProvider =
    NotifierProvider<CampaignFilterNotifier, CampaignFilter>(
      CampaignFilterNotifier.new,
    );

/// 캠페인 목록 Notifier
class CampaignListNotifier extends AsyncNotifier<List<CampaignData>> {
  /// 페이지당 로드할 캠페인 개수
  static const int PAGE_SIZE = 20;

  late final CampaignRepository _repository;
  late final MissionRepository _missionRepository;

  /// 참여 중인 캠페인 ID 목록 (로컬 관리)
  final Set<int> _participatingCampaignIds = {};

  /// 현재 로드된 캠페인 목록
  List<Campaign> _allCampaigns = [];

  /// 페이지네이션 offset
  int _offset = 0;

  /// 더 로드할 데이터가 있는지 여부
  bool _hasMore = true;

  /// 무한 스크롤 중복 호출 방지 플래그
  bool _isLoadingMore = false;

  @override
  Future<List<CampaignData>> build() async {
    _repository = getIt<CampaignRepository>();
    _missionRepository = getIt<MissionRepository>();
    return _loadCampaigns(resetOffset: true);
  }

  /// 캠페인 목록 로드
  Future<List<CampaignData>> _loadCampaigns({bool resetOffset = false}) async {
    if (resetOffset) {
      _offset = 0;
      _allCampaigns = [];
      _hasMore = true;
    }

    final filter = ref.read(campaignFilterProvider);

    final campaigns = await _repository.getCampaigns(
      region: filter.region != '전체' ? filter.region : null,
      category: filter.category != '전체' ? filter.category : null,
      status: 'ACTIVE', // 진행 중인 캠페인만 조회
      offset: _offset,
      limit: PAGE_SIZE,
    );

    if (resetOffset) {
      _allCampaigns = campaigns;
    } else {
      _allCampaigns.addAll(campaigns);
    }

    // PAGE_SIZE 미만이면 더 이상 로드할 데이터가 없음
    if (campaigns.length < PAGE_SIZE) {
      _hasMore = false;
    }

    return _applyLocalFilters();
  }

  /// 로컬 필터 적용 (city, startDate, endDate)
  List<CampaignData> _applyLocalFilters() {
    final filter = ref.read(campaignFilterProvider);

    var filtered = _allCampaigns.where((campaign) {
      // 기간 필터 (로컬)
      if (filter.startDate != null && filter.endDate != null) {
        final campaignStart =
            DateTime.tryParse(campaign.startDate) ?? DateTime(1900, 1, 1);
        final campaignEnd =
            (campaign.endDate != null
                ? DateTime.tryParse(campaign.endDate!)
                : null) ??
            DateTime(9999, 12, 31);
        final overlaps =
            (campaignStart.isBefore(filter.endDate!) ||
                campaignStart.isAtSameMomentAs(filter.endDate!)) &&
            (campaignEnd.isAfter(filter.startDate!) ||
                campaignEnd.isAtSameMomentAs(filter.startDate!));
        if (!overlaps) return false;
      }

      return true;
    }).toList();

    // Campaign을 CampaignData로 변환
    return filtered
        .map((campaign) => _campaignToCampaignData(campaign))
        .toList();
  }

  /// Campaign을 CampaignData로 변환
  CampaignData _campaignToCampaignData(Campaign campaign) {
    // 임의로 일부 캠페인에 자동 처리 가능 설정 (ID 기반)
    final campaignId = campaign.id;
    final isAutoProcessable = campaignId % 3 == 0; // ID가 3의 배수인 경우 자동 처리 가능

    return CampaignData(
      id: campaign.id.toString(),
      title: campaign.title,
      imageUrl: campaign.imageUrl ?? '',
      url: campaign.campaignUrl,
      startDate: DateTime.tryParse(campaign.startDate) ?? DateTime.now(),
      endDate:
          (campaign.endDate != null
              ? DateTime.tryParse(campaign.endDate!)
              : null) ??
          (DateTime.tryParse(campaign.startDate) ?? DateTime.now()),
      region: campaign.region,
      city: '전체', // API에 city가 없으므로 기본값
      category: campaign.category,
      isParticipating: _participatingCampaignIds.contains(campaign.id),
      isAutoProcessable: isAutoProcessable,
    );
  }

  /// 필터가 변경되었을 때 호출
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return _loadCampaigns(resetOffset: true);
    });
  }

  /// 다음 페이지 로드 (무한 스크롤)
  Future<void> loadMore() async {
    // 이미 로딩 중이거나 더 이상 데이터가 없으면 무시
    if (state.isLoading || !_hasMore || _isLoadingMore) return;

    _isLoadingMore = true;
    _offset += PAGE_SIZE;

    try {
      state = await AsyncValue.guard(() async {
        return _loadCampaigns(resetOffset: false);
      });
    } finally {
      _isLoadingMore = false;
    }
  }

  /// 캠페인 참가 토글
  Future<void> toggleParticipation(String campaignId) async {
    // 현재 상태가 로딩 중이면 무시
    if (state.isLoading) return;

    final currentData = state.value;
    if (currentData == null) return;

    // 사용자 ID 가져오기
    final userId = ref.read(authProvider).currentUser?.id;
    if (userId == null) {
      throw Exception('사용자 정보를 찾을 수 없습니다. 로그인이 필요합니다.');
    }

    final id = int.parse(campaignId);
    final wasParticipating = _participatingCampaignIds.contains(id);

    // 낙관적 업데이트
    if (wasParticipating) {
      _participatingCampaignIds.remove(id);
    } else {
      _participatingCampaignIds.add(id);
    }

    // UI 즉시 업데이트
    state = AsyncValue.data(_applyLocalFilters());

    // 실제 API 호출
    try {
      // 참가만 API 호출 (참가 취소는 추후 구현)
      if (!wasParticipating) {
        await _missionRepository.participateInCampaign(
          campaignId: id,
          userId: userId,
        );
        // 활동하기 페이지 데이터 리프레쉬 트리거
        ref.read(activityRefreshTriggerProvider.notifier).trigger();
      }
      // API 성공 시 상태 유지
    } catch (e) {
      // API 실패 시 롤백
      if (wasParticipating) {
        _participatingCampaignIds.add(id);
      } else {
        _participatingCampaignIds.remove(id);
      }
      state = AsyncValue.data(_applyLocalFilters());
      rethrow;
    }
  }

  /// 더 로드할 데이터가 있는지 여부
  bool get hasMore => _hasMore;
}

/// 캠페인 목록 Provider
final campaignListProvider =
    AsyncNotifierProvider<CampaignListNotifier, List<CampaignData>>(
      CampaignListNotifier.new,
    );
