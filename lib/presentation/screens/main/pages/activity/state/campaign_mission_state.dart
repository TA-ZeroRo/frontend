import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/di/injection.dart';
import '../../../../../../data/data_source/location/location_service.dart';
import '../../../../../../domain/model/mission/mission_with_template.dart';
import '../../../../../../domain/model/verification/location_verification_result.dart';
import '../../../../../../domain/repository/mission_repository.dart';
import '../../../../../../domain/repository/verification_repository.dart';
import '../../../../entry/state/auth_controller.dart';
import 'leaderboard_state.dart';

// ========================================
// CAMPAIGN MISSION STATE
// ========================================

/// AsyncNotifier for managing campaign mission state with real server data
/// 캠페인별로 그룹화된 미션 데이터를 Map으로 반환
class CampaignMissionAsyncNotifier
    extends AsyncNotifier<Map<int, List<MissionWithTemplate>>> {
  late final MissionRepository _repository;

  @override
  Future<Map<int, List<MissionWithTemplate>>> build() async {
    _repository = getIt<MissionRepository>();
    // Watch trigger to auto-refresh when needed
    ref.watch(leaderboardRefreshTriggerProvider);
    return await _fetchCampaignMissions();
  }

  Future<Map<int, List<MissionWithTemplate>>> _fetchCampaignMissions() async {
    final userId = ref.read(authProvider).currentUser?.id;
    if (userId == null) {
      return {};
    }

    // 서버에서 사용자의 미션 로그 가져오기
    final missionLogs = await _repository.getUserMissionLogs(userId);

    // 캠페인별로 그룹화 (진행 중인 캠페인만 포함)
    final Map<int, List<MissionWithTemplate>> campaignMap = {};
    for (final missionLog in missionLogs) {
      // 종료된 캠페인은 제외 (ACTIVE 상태가 아닌 경우)
      if (missionLog.campaign.status != 'ACTIVE') {
        continue;
      }
      final campaignId = missionLog.campaign.id;
      if (!campaignMap.containsKey(campaignId)) {
        campaignMap[campaignId] = [];
      }
      campaignMap[campaignId]!.add(missionLog);
    }

    return campaignMap;
  }

  /// 새로고침
  Future<void> refresh() async {
    // 이전 데이터 보존 (에러 시 복구용)
    final previousData = state.value;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _fetchCampaignMissions();
    });

    // 에러 발생 시 이전 데이터로 복구 (UX 개선)
    if (state.hasError && previousData != null) {
      state = AsyncValue.data(previousData);
    }
  }
}

final campaignMissionProvider =
    AsyncNotifierProvider<
      CampaignMissionAsyncNotifier,
      Map<int, List<MissionWithTemplate>>
    >(CampaignMissionAsyncNotifier.new);

/// Derived provider for completed mission count
final completedMissionCountProvider = Provider<int>((ref) {
  final asyncState = ref.watch(campaignMissionProvider);
  return asyncState.when(
    data: (campaignMap) => campaignMap.values
        .expand((missions) => missions)
        .where((m) => m.missionLog.status.value == 'COMPLETED')
        .length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

/// Derived provider for total points earned
final totalPointsEarnedProvider = Provider<int>((ref) {
  final asyncState = ref.watch(campaignMissionProvider);
  return asyncState.when(
    data: (campaignMap) => campaignMap.values
        .expand((missions) => missions)
        .where((m) => m.missionLog.status.value == 'COMPLETED')
        .fold(0, (sum, m) => sum + m.missionTemplate.rewardPoints),
    loading: () => 0,
    error: (_, __) => 0,
  );
});

// ========================================
// LOCATION VERIFICATION STATE (위치 인증 상태)
// ========================================

/// 위치 인증 진행 상태
enum LocationVerificationStatus {
  /// 초기 상태 (권한 확인 전)
  initial,

  /// 권한 요청 중
  requestingPermission,

  /// 위치 가져오는 중
  fetchingLocation,

  /// 서버에 인증 요청 중
  verifying,

  /// 인증 성공
  success,

  /// 인증 실패 (위치가 맞지 않음)
  failed,

  /// 에러 발생
  error,
}

/// 위치 인증 상태 데이터
class LocationVerificationState {
  final LocationVerificationStatus status;
  final LocationPermissionStatus? permissionStatus;
  final LocationVerificationResult? result;
  final String? errorMessage;

  const LocationVerificationState({
    this.status = LocationVerificationStatus.initial,
    this.permissionStatus,
    this.result,
    this.errorMessage,
  });

  LocationVerificationState copyWith({
    LocationVerificationStatus? status,
    LocationPermissionStatus? permissionStatus,
    LocationVerificationResult? result,
    String? errorMessage,
    bool clearResult = false,
    bool clearError = false,
  }) {
    return LocationVerificationState(
      status: status ?? this.status,
      permissionStatus: permissionStatus ?? this.permissionStatus,
      result: clearResult ? null : (result ?? this.result),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  /// 인증 버튼 활성화 여부
  bool get canVerify =>
      permissionStatus != LocationPermissionStatus.serviceDisabled &&
      permissionStatus != LocationPermissionStatus.permanentlyDenied;

  /// 로딩 중 여부
  bool get isLoading =>
      status == LocationVerificationStatus.requestingPermission ||
      status == LocationVerificationStatus.fetchingLocation ||
      status == LocationVerificationStatus.verifying;
}

/// 위치 인증 상태 Notifier
/// 현재 진행 중인 위치 인증의 상태를 관리합니다.
class LocationVerificationNotifier extends Notifier<LocationVerificationState> {
  late final LocationService _locationService;
  late final VerificationRepository _verificationRepository;
  int? _currentCampaignId;

  @override
  LocationVerificationState build() {
    _locationService = getIt<LocationService>();
    _verificationRepository = getIt<VerificationRepository>();
    return const LocationVerificationState();
  }

  /// 특정 캠페인에 대한 위치 인증 초기화
  Future<void> initialize(int campaignId) async {
    _currentCampaignId = campaignId;
    state = const LocationVerificationState();
    await _checkPermissionStatus();
  }

  /// 권한 상태 확인
  Future<void> _checkPermissionStatus() async {
    final status = await _locationService.checkPermissionStatus();
    state = state.copyWith(permissionStatus: status);
  }

  /// 권한 상태 재확인 (외부에서 호출 가능)
  Future<void> checkPermissionStatus() async {
    await _checkPermissionStatus();
  }

  /// 위치 인증 시작
  Future<void> startVerification() async {
    if (_currentCampaignId == null) {
      state = state.copyWith(
        status: LocationVerificationStatus.error,
        errorMessage: '캠페인 정보가 없습니다.',
      );
      return;
    }

    try {
      // 1. 권한 요청
      state = state.copyWith(
        status: LocationVerificationStatus.requestingPermission,
        clearError: true,
        clearResult: true,
      );

      final permissionStatus = await _locationService.requestPermission();

      if (permissionStatus != LocationPermissionStatus.granted) {
        state = state.copyWith(
          status: LocationVerificationStatus.initial,
          permissionStatus: permissionStatus,
        );
        return;
      }

      // 2. 위치 가져오기
      state = state.copyWith(
        status: LocationVerificationStatus.fetchingLocation,
        permissionStatus: permissionStatus,
      );

      final location = await _locationService.getCurrentLocation();

      // 3. 서버에 인증 요청
      state = state.copyWith(status: LocationVerificationStatus.verifying);

      final result = await _verificationRepository.verifyLocation(
        campaignId: _currentCampaignId!,
        latitude: location.latitude,
        longitude: location.longitude,
      );

      // 4. 결과 처리
      if (result.isValid) {
        state = state.copyWith(
          status: LocationVerificationStatus.success,
          result: result,
        );
        // 리더보드/미션 데이터 리프레쉬 트리거
        ref.read(leaderboardRefreshTriggerProvider.notifier).trigger();
      } else {
        state = state.copyWith(
          status: LocationVerificationStatus.failed,
          result: result,
        );
      }
    } on LocationException catch (e) {
      state = state.copyWith(
        status: LocationVerificationStatus.error,
        errorMessage: e.message,
        permissionStatus: e.permissionStatus,
      );
    } catch (e) {
      state = state.copyWith(
        status: LocationVerificationStatus.error,
        errorMessage: '위치 인증 중 오류가 발생했습니다.',
      );
    }
  }

  /// 재시도
  void retry() {
    state = const LocationVerificationState();
    _checkPermissionStatus();
  }

  /// 설정 화면 열기 후 권한 상태 재확인
  Future<void> openSettingsAndRefresh() async {
    await _locationService.openSettings();
    await _checkPermissionStatus();
  }

  /// 위치 설정 화면 열기 후 권한 상태 재확인
  Future<void> openLocationSettingsAndRefresh() async {
    await _locationService.openLocationSettings();
    await _checkPermissionStatus();
  }

  /// 상태 초기화
  void reset() {
    _currentCampaignId = null;
    state = const LocationVerificationState();
  }
}

/// 위치 인증 Provider
final locationVerificationProvider =
    NotifierProvider<LocationVerificationNotifier, LocationVerificationState>(
  LocationVerificationNotifier.new,
);
