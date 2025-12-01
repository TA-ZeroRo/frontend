import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  bool _initialLocationLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadInitialLocation();
  }

  Future<void> _loadInitialLocation() async {
    final position = await ref.read(ploggingSessionProvider.notifier).getCurrentLocation();
    if (position != null && mounted) {
      _mapController.move(
        LatLng(position.latitude, position.longitude),
        15.0,
      );
      setState(() {
        _initialLocationLoaded = true;
      });
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
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
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
            onPositionChanged: (position, hasGesture) {
              if (hasGesture && position.bounds != null) {
                ref.read(mapViewProvider.notifier).updateBounds(position.bounds!);
                ref.read(communityRoutesProvider.notifier).loadRoutesForBounds(
                  position.bounds!,
                );
              }
            },
          ),
          children: [
            // OpenStreetMap 타일 레이어
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
            if (sessionState.isSessionActive && sessionState.routePoints.isNotEmpty)
              PolylineLayer(
                polylines: [_buildCurrentRoutePolyline(sessionState.routePoints)],
              ),

            // 현재 위치 마커
            if (sessionState.currentPosition != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(
                      sessionState.currentPosition!.latitude,
                      sessionState.currentPosition!.longitude,
                    ),
                    width: 40,
                    height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.navigation,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
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
            child: const Icon(
              Icons.my_location,
              color: Colors.blue,
            ),
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
      points: route.routePoints
          .map((p) => LatLng(p.lat, p.lng))
          .toList(),
      strokeWidth: 4.0,
      color: color.withValues(alpha: opacity),
    );
  }

  /// 현재 사용자 경로 폴리라인 생성
  Polyline _buildCurrentRoutePolyline(List<GpsPoint> points) {
    return Polyline(
      points: points.map((p) => LatLng(p.lat, p.lng)).toList(),
      strokeWidth: 5.0,
      color: Colors.blue,
    );
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
      position = await ref.read(ploggingSessionProvider.notifier).getCurrentLocation();
    }

    if (position != null && mounted) {
      _mapController.move(
        LatLng(position.latitude, position.longitude),
        15.0,
      );
    }
  }
}
