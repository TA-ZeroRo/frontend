import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/recruiting_post.dart';

// 필터 상태 모델
class RecruitingFilter {
  final String region;
  final String city;
  final int? minCapacity;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? minAge;
  final int? maxAge;

  const RecruitingFilter({
    this.region = '전체',
    this.city = '전체',
    this.minCapacity,
    this.startDate,
    this.endDate,
    this.minAge,
    this.maxAge,
  });

  RecruitingFilter copyWith({
    String? region,
    String? city,
    int? minCapacity,
    DateTime? startDate,
    DateTime? endDate,
    int? minAge,
    int? maxAge,
  }) {
    return RecruitingFilter(
      region: region ?? this.region,
      city: city ?? this.city,
      minCapacity: minCapacity ?? this.minCapacity,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
    );
  }
}

// 필터 프로바이더
final recruitingFilterProvider =
    StateNotifierProvider<RecruitingFilterNotifier, RecruitingFilter>((ref) {
      return RecruitingFilterNotifier();
    });

class RecruitingFilterNotifier extends StateNotifier<RecruitingFilter> {
  RecruitingFilterNotifier() : super(const RecruitingFilter());

  void setRegion(String region) {
    state = state.copyWith(region: region, city: '전체');
  }

  void setCity(String city) {
    state = state.copyWith(city: city);
  }

  void setCapacity(int? capacity) {
    state = state.copyWith(minCapacity: capacity);
  }

  void setDateRange(DateTime start, DateTime end) {
    state = state.copyWith(startDate: start, endDate: end);
  }

  void clearDateRange() {
    state = state.copyWith(
      startDate: null,
      endDate: null,
    ); // null을 직접 전달할 수 없으므로 copyWith 수정 필요 혹은 로직 변경
    // copyWith 구현상 null 전달이 무시되므로, 새로운 객체로 초기화하거나 copyWith를 개선해야 함.
    // 여기서는 간단히 새로운 객체 생성 시 기존 값 유지하되 날짜만 초기화
    state = RecruitingFilter(
      region: state.region,
      city: state.city,
      minCapacity: state.minCapacity,
      minAge: state.minAge,
      maxAge: state.maxAge,
    );
  }

  void setAgeRange(int? min, int? max) {
    state = state.copyWith(minAge: min, maxAge: max);
  }

  void reset() {
    state = const RecruitingFilter();
  }
}

// 리크루팅 목록 프로바이더 (Mock Data)
final recruitingListProvider = FutureProvider<List<RecruitingPost>>((
  ref,
) async {
  final filter = ref.watch(recruitingFilterProvider);

  // API 호출 시뮬레이션
  await Future.delayed(const Duration(milliseconds: 500));

  // Mock Data
  final allPosts = [
    RecruitingPost(
      id: '1',
      campaignId: 'c1',
      campaignTitle: '한강 플로깅 캠페인',
      campaignImageUrl: 'https://picsum.photos/id/10/400/300',
      title: '이번 주말 한강에서 같이 쓰레기 주우실 분!',
      region: '서울',
      city: '영등포구',
      capacity: 4,
      currentMembers: 2,
      startDate: DateTime.now().add(const Duration(days: 2)),
      endDate: DateTime.now().add(const Duration(days: 2)),
      minAge: 20,
      maxAge: 30,
      isRecruiting: true,
    ),
    RecruitingPost(
      id: '2',
      campaignId: 'c2',
      campaignTitle: '유기견 봉사활동',
      campaignImageUrl: 'https://picsum.photos/id/237/400/300',
      title: '강아지 산책 봉사 같이 가요',
      region: '경기',
      city: '수원시',
      capacity: 6,
      currentMembers: 5,
      startDate: DateTime.now().add(const Duration(days: 5)),
      endDate: DateTime.now().add(const Duration(days: 5)),
      minAge: 20,
      maxAge: 40,
      isRecruiting: true,
    ),
    RecruitingPost(
      id: '3',
      campaignId: 'c3',
      campaignTitle: '연탄 나눔 봉사',
      campaignImageUrl: 'https://picsum.photos/id/106/400/300',
      title: '따뜻한 겨울 만들기 연탄 봉사 모집합니다',
      region: '서울',
      city: '노원구',
      capacity: 10,
      currentMembers: 3,
      startDate: DateTime.now().add(const Duration(days: 10)),
      endDate: DateTime.now().add(const Duration(days: 10)),
      minAge: 0, // 제한 없음
      maxAge: 0,
      isRecruiting: true,
    ),
    RecruitingPost(
      id: '4',
      campaignId: 'c4',
      campaignTitle: '해변 정화 활동',
      campaignImageUrl: 'https://picsum.photos/id/1040/400/300',
      title: '부산 해운대 비치코밍 함께해요',
      region: '부산',
      city: '해운대구',
      capacity: 8,
      currentMembers: 1,
      startDate: DateTime.now().add(const Duration(days: 7)),
      endDate: DateTime.now().add(const Duration(days: 7)),
      minAge: 25,
      maxAge: 35,
      isRecruiting: true,
    ),
  ];

  // 필터링 로직 적용
  return allPosts.where((post) {
    if (filter.region != '전체' && post.region != filter.region) return false;
    if (filter.city != '전체' && post.city != filter.city) return false;
    if (filter.minCapacity != null && post.capacity < filter.minCapacity!) {
      return false;
    }
    // 날짜, 나이 등 추가 필터링 로직은 필요에 따라 구현
    return true;
  }).toList();
});
