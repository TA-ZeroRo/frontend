import 'package:injectable/injectable.dart';

import '../../core/logger/logger.dart';
import '../../domain/model/verification/location_verification_result.dart';
import '../../domain/repository/verification_repository.dart';
import '../data_source/verification/verification_api.dart';
import '../dto/verification/location_verification_request_dto.dart';

@Injectable(as: VerificationRepository)
class VerificationRepositoryImpl implements VerificationRepository {
  final VerificationApi _verificationApi;

  VerificationRepositoryImpl(this._verificationApi);

  @override
  Future<LocationVerificationResult> verifyLocation({
    required int campaignId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final request = LocationVerificationRequestDto(
        campaignId: campaignId,
        latitude: latitude,
        longitude: longitude,
      );

      final response = await _verificationApi.verifyLocation(request);

      CustomLogger.logger.i(
        'verifyLocation - 위치 인증 완료 '
        '(campaignId: $campaignId, isValid: ${response.isValid}, '
        'distance: ${response.distance}m)',
      );

      return LocationVerificationResult(
        isValid: response.isValid,
        reason: response.reason,
        distance: response.distance,
        verifiedAt: response.verifiedAt != null
            ? DateTime.tryParse(response.verifiedAt!)
            : null,
        locationAddress: response.locationAddress,
      );
    } catch (e) {
      CustomLogger.logger.e(
        'verifyLocation - 위치 인증 실패 '
        '(campaignId: $campaignId, lat: $latitude, lng: $longitude)',
        error: e,
      );
      rethrow;
    }
  }
}
