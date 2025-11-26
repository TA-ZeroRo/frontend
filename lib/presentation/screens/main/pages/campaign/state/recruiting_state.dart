import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/recruiting_post.dart';
import '../../../../../../core/di/injection.dart';
import '../../../../../../domain/repository/recruiting_repository.dart';

// 참여 상태 필터 타입
enum ParticipationStatus {
  all, // 전체
  participating, // 참여중
  recruiting, // 모집중
}

// 필터 상태 모델
class RecruitingFilter {
  final String region;
  final String city;
  final int? minCapacity;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? minAge;
  final int? maxAge;
  final ParticipationStatus participationStatus;

  const RecruitingFilter({
    this.region = '전체',
    this.city = '전체',
    this.minCapacity,
    this.startDate,
    this.endDate,
    this.minAge,
    this.maxAge,
    this.participationStatus = ParticipationStatus.all,
  });

  RecruitingFilter copyWith({
    String? region,
    String? city,
    int? minCapacity,
    DateTime? startDate,
    DateTime? endDate,
    int? minAge,
    int? maxAge,
    ParticipationStatus? participationStatus,
  }) {
    return RecruitingFilter(
      region: region ?? this.region,
      city: city ?? this.city,
      minCapacity: minCapacity ?? this.minCapacity,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      participationStatus: participationStatus ?? this.participationStatus,
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

  void setParticipationStatus(ParticipationStatus status) {
    state = state.copyWith(participationStatus: status);
  }

  void reset() {
    state = const RecruitingFilter();
  }
}

// 리크루팅 목록 프로바이더 (API 연동)
final recruitingListProvider = FutureProvider<List<RecruitingPost>>((
  ref,
) async {
  final filter = ref.watch(recruitingFilterProvider);
  final repository = getIt<RecruitingRepository>();

  // 현재 사용자 ID 가져오기
  final userId = Supabase.instance.client.auth.currentSession?.user.id;

  // 참여 상태에 따른 필터 값 변환
  String? participationStatus;
  if (filter.participationStatus == ParticipationStatus.participating) {
    participationStatus = 'participating';
  } else if (filter.participationStatus == ParticipationStatus.recruiting) {
    participationStatus = 'recruiting';
  }

  try {
    // 백엔드 API 호출
    final posts = await repository.getRecruitingPosts(
      offset: 0,
      region: filter.region != '전체' ? filter.region : null,
      participationStatus: participationStatus,
      userId: userId,
    );

    // 추가 클라이언트 필터링 (API에서 지원하지 않는 필터)
    return posts.where((post) {
      // 도시 필터
      if (filter.city != '전체' && post.city != filter.city) return false;

      // 인원 필터
      if (filter.minCapacity != null && post.capacity < filter.minCapacity!) {
        return false;
      }

      return true;
    }).toList();
  } catch (e) {
    // API 오류 시 빈 리스트 반환 (또는 에러 처리)
    print('리크루팅 목록 조회 오류: $e');
    return [];
  }
});

// 리크루팅 참여하기 함수
Future<RecruitingPost> joinRecruiting(int postId) async {
  final repository = getIt<RecruitingRepository>();
  final userId = Supabase.instance.client.auth.currentSession?.user.id;

  if (userId == null) {
    throw Exception('로그인이 필요합니다');
  }

  return await repository.joinRecruiting(
    postId: postId,
    userId: userId,
  );
}
