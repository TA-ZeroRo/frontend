import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../dto/verification/location_verification_request_dto.dart';
import '../../dto/verification/location_verification_response_dto.dart';

@injectable
class VerificationApi {
  final Dio _dio;

  VerificationApi(this._dio);

  /// 위치 인증 요청
  /// POST /verification/location
  Future<LocationVerificationResponseDto> verifyLocation(
    LocationVerificationRequestDto request,
  ) async {
    final response = await _dio.post(
      '/verification/location',
      data: request.toJson(),
    );

    return LocationVerificationResponseDto.fromJson(response.data);
  }
}
