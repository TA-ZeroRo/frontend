import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/logger/logger.dart';

/// 위치 권한 상태
enum LocationPermissionStatus {
  /// 권한 허용됨
  granted,

  /// 권한 거부됨
  denied,

  /// 권한 영구 거부됨 (설정에서 변경 필요)
  permanentlyDenied,

  /// 위치 서비스 비활성화됨
  serviceDisabled,
}

/// 위치 정보 결과
class LocationResult {
  final double latitude;
  final double longitude;
  final double? accuracy;
  final DateTime timestamp;

  const LocationResult({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    required this.timestamp,
  });

  @override
  String toString() =>
      'LocationResult(lat: $latitude, lng: $longitude, accuracy: $accuracy)';
}

/// 위치 서비스
/// geolocator와 permission_handler를 사용하여 현재 위치를 가져옵니다.
@singleton
class LocationService {
  /// 위치 권한 상태 확인
  Future<LocationPermissionStatus> checkPermissionStatus() async {
    try {
      // 위치 서비스 활성화 여부 확인
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        CustomLogger.logger.w('checkPermissionStatus - 위치 서비스 비활성화됨');
        return LocationPermissionStatus.serviceDisabled;
      }

      // 권한 상태 확인
      final status = await Permission.location.status;

      if (status.isGranted) {
        return LocationPermissionStatus.granted;
      } else if (status.isPermanentlyDenied) {
        return LocationPermissionStatus.permanentlyDenied;
      } else {
        return LocationPermissionStatus.denied;
      }
    } catch (e) {
      CustomLogger.logger.e('checkPermissionStatus - 권한 상태 확인 실패', error: e);
      return LocationPermissionStatus.denied;
    }
  }

  /// 위치 권한 요청
  ///
  /// Returns 권한 허용 여부
  Future<LocationPermissionStatus> requestPermission() async {
    try {
      // 위치 서비스 활성화 여부 확인
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        CustomLogger.logger.w('requestPermission - 위치 서비스 비활성화됨');
        return LocationPermissionStatus.serviceDisabled;
      }

      // 권한 요청
      final status = await Permission.location.request();

      CustomLogger.logger.i('requestPermission - 권한 요청 결과: $status');

      if (status.isGranted) {
        return LocationPermissionStatus.granted;
      } else if (status.isPermanentlyDenied) {
        return LocationPermissionStatus.permanentlyDenied;
      } else {
        return LocationPermissionStatus.denied;
      }
    } catch (e) {
      CustomLogger.logger.e('requestPermission - 권한 요청 실패', error: e);
      return LocationPermissionStatus.denied;
    }
  }

  /// 현재 위치 가져오기
  ///
  /// [highAccuracy] true면 GPS 사용 (높은 정확도, 배터리 소모 많음)
  ///
  /// Returns 현재 위치 정보
  /// Throws Exception if 권한이 없거나 위치를 가져올 수 없는 경우
  Future<LocationResult> getCurrentLocation({bool highAccuracy = true}) async {
    try {
      // 권한 확인
      final permissionStatus = await checkPermissionStatus();

      if (permissionStatus != LocationPermissionStatus.granted) {
        throw LocationException(
          '위치 권한이 필요합니다',
          permissionStatus: permissionStatus,
        );
      }

      CustomLogger.logger.d('getCurrentLocation - 위치 가져오기 시작');

      // 위치 가져오기
      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: highAccuracy ? LocationAccuracy.high : LocationAccuracy.medium,
          timeLimit: const Duration(seconds: 15),
        ),
      );

      final result = LocationResult(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        timestamp: position.timestamp,
      );

      CustomLogger.logger.i('getCurrentLocation - 위치 가져오기 성공: $result');

      return result;
    } on LocationException {
      rethrow;
    } catch (e) {
      CustomLogger.logger.e('getCurrentLocation - 위치 가져오기 실패', error: e);
      throw LocationException('위치를 가져올 수 없습니다: $e');
    }
  }

  /// 앱 설정 화면 열기 (권한 영구 거부 시)
  Future<bool> openSettings() async {
    try {
      return await openAppSettings();
    } catch (e) {
      CustomLogger.logger.e('openSettings - 설정 열기 실패', error: e);
      return false;
    }
  }

  /// 위치 서비스 설정 화면 열기
  Future<bool> openLocationSettings() async {
    try {
      return await Geolocator.openLocationSettings();
    } catch (e) {
      CustomLogger.logger.e('openLocationSettings - 위치 설정 열기 실패', error: e);
      return false;
    }
  }
}

/// 위치 관련 예외
class LocationException implements Exception {
  final String message;
  final LocationPermissionStatus? permissionStatus;

  const LocationException(this.message, {this.permissionStatus});

  @override
  String toString() => 'LocationException: $message';
}
