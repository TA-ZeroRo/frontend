import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'mock/mock_campaign_data.dart';

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
  /// 내부 캠페인 데이터 (참가 상태 변경을 위해)
  List<CampaignData> _campaigns = [];

  @override
  Future<List<CampaignData>> build() async {
    // Mock 데이터로 초기화
    _campaigns = List.from(mockCampaigns);

    // 필터 적용
    return _applyFilters();
  }

  /// 필터 적용하여 캠페인 목록 반환
  List<CampaignData> _applyFilters() {
    final filter = ref.read(campaignFilterProvider);

    return _campaigns.where((campaign) {
      // 지역 필터
      if (filter.region != '전체' && campaign.region != filter.region) {
        return false;
      }

      // 시 필터
      if (filter.city != '전체' && campaign.city != filter.city) {
        return false;
      }

      // 카테고리 필터
      if (filter.category != '전체' && campaign.category != filter.category) {
        return false;
      }

      // 기간 필터
      if (filter.startDate != null && filter.endDate != null) {
        // 캠페인 기간과 검색 기간이 겹치는지 확인
        // 캠페인 시작일이 검색 종료일 이전이고, 캠페인 종료일이 검색 시작일 이후면 겹침
        final overlaps =
            (campaign.startDate.isBefore(filter.endDate!) ||
                campaign.startDate.isAtSameMomentAs(filter.endDate!)) &&
            (campaign.endDate.isAfter(filter.startDate!) ||
                campaign.endDate.isAtSameMomentAs(filter.startDate!));
        if (!overlaps) return false;
      }

      return true;
    }).toList();
  }

  /// 필터가 변경되었을 때 호출
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // 짧은 딜레이로 로딩 효과 연출
      await Future.delayed(const Duration(milliseconds: 300));
      return _applyFilters();
    });
  }

  /// 캠페인 참가 토글
  Future<void> toggleParticipation(String campaignId) async {
    // 현재 상태가 로딩 중이면 무시
    if (state.isLoading) return;

    // 낙관적 업데이트 (Optimistic Update)
    final currentData = state.value;
    if (currentData == null) return;

    // 내부 데이터 업데이트
    final index = _campaigns.indexWhere((c) => c.id == campaignId);
    if (index != -1) {
      _campaigns[index] = _campaigns[index].copyWith(
        isParticipating: !_campaigns[index].isParticipating,
      );
    }

    // UI 즉시 업데이트
    state = AsyncValue.data(_applyFilters());

    // 실제 API 호출 시뮬레이션 (추후 실제 API로 대체)
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      // API 성공 시 상태 유지
    } catch (e) {
      // API 실패 시 롤백
      if (index != -1) {
        _campaigns[index] = _campaigns[index].copyWith(
          isParticipating: !_campaigns[index].isParticipating,
        );
        state = AsyncValue.data(_applyFilters());
      }
    }
  }
}

/// 캠페인 목록 Provider
final campaignListProvider =
    AsyncNotifierProvider<CampaignListNotifier, List<CampaignData>>(
  CampaignListNotifier.new,
);
