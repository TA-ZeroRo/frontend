import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../../domain/model/plogging/gps_point.dart';
import '../../../../../../domain/model/plogging/plogging_route.dart';
import '../state/plogging_map_state.dart';
import '../state/plogging_session_state.dart';

class PloggingMapView extends ConsumerStatefulWidget {
  const PloggingMapView({super.key});

  @override
  ConsumerState<PloggingMapView> createState() => _PloggingMapViewState();
}

class _PloggingMapViewState extends ConsumerState<PloggingMapView> {
  final MapController _mapController = MapController();

  // 줌 레벨을 ValueNotifier로 관리 (setState 대신)
  final ValueNotifier<double> _zoomNotifier = ValueNotifier(15.0);

  @override
  void initState() {
    super.initState();
    // 빌드 완료 후 위치 로딩 (UI 블로킹 방지)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialLocation();
    });
  }

  Future<void> _loadInitialLocation() async {
    // 1. 캐시된 위치 먼저 시도 (빠름)
    try {
      final cached = await Geolocator.getLastKnownPosition();
      if (cached != null && mounted) {
        _mapController.move(LatLng(cached.latitude, cached.longitude), 15.0);
        return;
      }
    } catch (_) {
      // 캐시 실패 시 계속 진행
    }

    // 2. 캐시 없으면 현재 위치 요청
    final position = await ref
        .read(ploggingSessionProvider.notifier)
        .getCurrentLocation();
    if (position != null && mounted) {
      _mapController.move(LatLng(position.latitude, position.longitude), 15.0);
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    _zoomNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(ploggingSessionProvider);
    final communityRoutes = ref.watch(communityRoutesProvider);

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: sessionState.currentPosition != null
                ? LatLng(
                    sessionState.currentPosition!.latitude,
                    sessionState.currentPosition!.longitude,
                  )
                : const LatLng(37.5665, 126.9780),
            initialZoom: 15.0,
            interactionOptions: InteractionOptions(
              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
            onPositionChanged: (position, hasGesture) {
              // 줌 레벨 업데이트 (ValueNotifier 사용 - setState 제거)
              if (position.zoom != null) {
                _zoomNotifier.value = position.zoom!;
              }

              if (hasGesture && position.bounds != null) {
                ref
                    .read(mapViewProvider.notifier)
                    .updateBounds(position.bounds!);
                ref
                    .read(communityRoutesProvider.notifier)
                    .loadRoutesForBounds(position.bounds!);
              }
            },
          ),
          children: [
            // 회색조 타일 레이어 (CartoDB Positron)
            TileLayer(
              urlTemplate:
                  'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
              userAgentPackageName: 'com.zeroro.app',
            ),

            // 커뮤니티 경로 (다른 사용자들의 플로깅 경로)
            communityRoutes.when(
              data: (routes) => PolylineLayer(
                polylines: routes
                    .map((route) => _buildCommunityPolyline(route))
                    .toList(),
              ),
              loading: () => const PolylineLayer(polylines: []),
              error: (_, __) => const PolylineLayer(polylines: []),
            ),

            // 현재 사용자의 플로깅 경로
            if (sessionState.isSessionActive &&
                sessionState.routePoints.isNotEmpty)
              PolylineLayer(
                polylines: [
                  _buildCurrentRoutePolyline(sessionState.routePoints),
                ],
              ),

            // 현재 위치 마커 (줌 변경 시에만 리빌드)
            if (sessionState.currentPosition != null)
              ValueListenableBuilder<double>(
                valueListenable: _zoomNotifier,
                builder: (context, zoom, _) => MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(
                        sessionState.currentPosition!.latitude,
                        sessionState.currentPosition!.longitude,
                      ),
                      width: _getResponsiveSize(50, zoom),
                      height: _getResponsiveSize(50, zoom),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: _getResponsiveSize(3, zoom),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.navigation,
                          color: Colors.white,
                          size: _getResponsiveSize(25, zoom),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // 인증 위치 마커들
            if (sessionState.verifications.isNotEmpty)
              MarkerLayer(
                markers: sessionState.verifications
                    .map((v) => _buildVerificationMarker(v))
                    .toList(),
              ),
          ],
        ),
        // 줌 컨트롤 버튼
        Positioned(
          left: 16,
          bottom: 80,
          child: Column(
            children: [
              FloatingActionButton.small(
                heroTag: 'zoomIn',
                backgroundColor: Colors.white,
                onPressed: () {
                  _mapController.move(
                    _mapController.camera.center,
                    _mapController.camera.zoom + 1,
                  );
                },
                child: const Icon(Icons.add, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              FloatingActionButton.small(
                heroTag: 'zoomOut',
                backgroundColor: Colors.white,
                onPressed: () {
                  _mapController.move(
                    _mapController.camera.center,
                    _mapController.camera.zoom - 1,
                  );
                },
                child: const Icon(Icons.remove, color: Colors.black87),
              ),
            ],
          ),
        ),
        // 내 위치로 이동 버튼
        Positioned(
          left: 16,
          bottom: 16,
          child: FloatingActionButton.small(
            heroTag: 'myLocation',
            backgroundColor: Colors.white,
            onPressed: moveToCurrentLocation,
            child: const Icon(Icons.my_location, color: Colors.blue),
          ),
        ),
      ],
    );
  }

  /// 커뮤니티 경로 폴리라인 생성
  Polyline _buildCommunityPolyline(PloggingRoute route) {
    final color = Color(getIntensityColor(route.intensityLevel));
    final opacity = getIntensityOpacity(route.intensityLevel);

    return Polyline(
      points: route.routePoints.map((p) => LatLng(p.lat, p.lng)).toList(),
      strokeWidth: _getResponsiveSize(6.0),
      color: color.withValues(alpha: opacity),
    );
  }

  /// 현재 사용자 경로 폴리라인 생성
  Polyline _buildCurrentRoutePolyline(List<GpsPoint> points) {
    return Polyline(
      points: points.map((p) => LatLng(p.lat, p.lng)).toList(),
      strokeWidth: _getResponsiveSize(8.0),
      color: Colors.blue,
    );
  }

  /// 줌 레벨에 따른 반응형 크기 계산
  /// [zoom]을 전달하지 않으면 현재 _zoomNotifier 값 사용
  double _getResponsiveSize(double baseSize, [double? zoom]) {
    // 기본 줌 레벨(15.0)을 기준으로 크기 조정
    // 줌이 커질수록(더 자세히 볼수록) 크기가 커짐
    // 줌이 작아질수록(더 넓게 볼수록) 크기가 작아짐 (최소 크기 제한)
    final currentZoom = zoom ?? _zoomNotifier.value;
    final scaleFactor = currentZoom / 15.0;
    final size = baseSize * scaleFactor;

    // 너무 작아지거나 커지지 않도록 제한
    // 최소 50% ~ 최대 200%
    return size.clamp(baseSize * 0.5, baseSize * 2.0);
  }

  /// 인증 위치 마커 생성
  Marker _buildVerificationMarker(dynamic verification) {
    // verification에서 위치 정보를 가져와야 하지만,
    // 현재 모델에는 위치 정보가 없으므로 임시로 표시하지 않음
    return Marker(
      point: const LatLng(0, 0),
      width: 0,
      height: 0,
      child: const SizedBox.shrink(),
    );
  }

  /// 현재 위치로 지도 이동
  Future<void> moveToCurrentLocation() async {
    var position = ref.read(ploggingSessionProvider).currentPosition;

    // 위치가 없으면 새로 가져오기
    if (position == null) {
      position = await ref
          .read(ploggingSessionProvider.notifier)
          .getCurrentLocation();
    }

    if (position != null && mounted) {
      _mapController.move(LatLng(position.latitude, position.longitude), 15.0);
    }
  }
}
