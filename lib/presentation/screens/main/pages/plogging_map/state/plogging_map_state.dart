import 'dart:async';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../../core/di/injection.dart';
import '../../../../../../domain/model/plogging/plogging_route.dart';
import '../../../../../../domain/model/plogging/plogging_stats.dart';
import '../../../../../../domain/repository/plogging_repository.dart';
import '../../../../entry/state/auth_controller.dart';
import 'plogging_session_state.dart';

// ========================================
// MAP VIEW STATE
// ========================================

/// 지도 뷰 상태
class MapViewState {
  final LatLng center;
  final double zoom;
  final LatLngBounds? bounds;

  const MapViewState({
    this.center = const LatLng(37.5665, 126.9780), // 서울시청 기본값
    this.zoom = 15.0,
    this.bounds,
  });

  MapViewState copyWith({
    LatLng? center,
    double? zoom,
    LatLngBounds? bounds,
  }) {
    return MapViewState(
      center: center ?? this.center,
      zoom: zoom ?? this.zoom,
      bounds: bounds ?? this.bounds,
    );
  }
}

/// 지도 뷰 Notifier
class MapViewNotifier extends Notifier<MapViewState> {
  @override
  MapViewState build() {
    return const MapViewState();
  }

  void updateCenter(LatLng center) {
    state = state.copyWith(center: center);
  }

  void updateZoom(double zoom) {
    state = state.copyWith(zoom: zoom);
  }

  void updateBounds(LatLngBounds bounds) {
    state = state.copyWith(bounds: bounds);
  }
}

final mapViewProvider = NotifierProvider<MapViewNotifier, MapViewState>(
  MapViewNotifier.new,
);

// ========================================
// COMMUNITY ROUTES STATE
// ========================================

/// 커뮤니티 경로 (다른 사용자들의 플로깅 경로)
class CommunityRoutesNotifier extends AsyncNotifier<List<PloggingRoute>> {
  late final PloggingRepository _repository;
  Timer? _debounceTimer;
  LatLngBounds? _pendingBounds;

  @override
  Future<List<PloggingRoute>> build() async {
    _repository = getIt<PloggingRepository>();

    // 지도 리프레시 트리거 감시
    ref.watch(ploggingMapRefreshTriggerProvider);

    // dispose 시 타이머 정리
    ref.onDispose(() {
      _debounceTimer?.cancel();
    });

    // 초기 영역의 경로 로드
    final mapView = ref.watch(mapViewProvider);
    if (mapView.bounds != null) {
      return _fetchRoutes(mapView.bounds!);
    }
    return [];
  }

  Future<List<PloggingRoute>> _fetchRoutes(LatLngBounds bounds) async {
    final result = await _repository.getMapRoutes(
      minLat: bounds.south,
      maxLat: bounds.north,
      minLng: bounds.west,
      maxLng: bounds.east,
    );
    return result.routes;
  }

  /// 현재 지도 영역의 경로 로드 (debounce 적용)
  void loadRoutesForBounds(LatLngBounds bounds) {
    _pendingBounds = bounds;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () async {
      if (_pendingBounds != null) {
        // 이전 데이터 유지하면서 백그라운드 로딩 (깜빡임 방지)
        final newRoutes = await AsyncValue.guard(() => _fetchRoutes(_pendingBounds!));
        state = newRoutes;
      }
    });
  }
}

final communityRoutesProvider =
    AsyncNotifierProvider<CommunityRoutesNotifier, List<PloggingRoute>>(
      CommunityRoutesNotifier.new,
    );

// ========================================
// USER PLOGGING STATS
// ========================================

/// 사용자 플로깅 통계
class UserPloggingStatsNotifier extends AsyncNotifier<PloggingStats> {
  late final PloggingRepository _repository;

  @override
  Future<PloggingStats> build() async {
    _repository = getIt<PloggingRepository>();

    final userId = ref.watch(authProvider).currentUser?.id;
    if (userId == null) {
      return const PloggingStats();
    }

    return _repository.getUserStats(userId);
  }

  Future<void> refresh() async {
    final userId = ref.read(authProvider).currentUser?.id;
    if (userId == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getUserStats(userId));
  }
}

final userPloggingStatsProvider =
    AsyncNotifierProvider<UserPloggingStatsNotifier, PloggingStats>(
      UserPloggingStatsNotifier.new,
    );

// ========================================
// INTENSITY COLOR HELPER
// ========================================

/// 강도 레벨에 따른 색상 반환
/// 1: 연두색 (0-20분)
/// 2: 녹색 (20-40분)
/// 3: 진녹색 (40-60분)
/// 4: 깊은 녹색 (60분+)
int getIntensityColor(int level) {
  switch (level) {
    case 1:
      return 0xFF90EE90; // Light Green
    case 2:
      return 0xFF32CD32; // Lime Green
    case 3:
      return 0xFF228B22; // Forest Green
    case 4:
      return 0xFF006400; // Dark Green
    default:
      return 0xFF90EE90;
  }
}

/// 강도 레벨에 따른 투명도 반환
double getIntensityOpacity(int level) {
  switch (level) {
    case 1:
      return 0.4;
    case 2:
      return 0.6;
    case 3:
      return 0.8;
    case 4:
      return 1.0;
    default:
      return 0.4;
  }
}
