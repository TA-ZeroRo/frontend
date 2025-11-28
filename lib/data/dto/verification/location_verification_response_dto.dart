import 'package:json_annotation/json_annotation.dart';

part 'location_verification_response_dto.g.dart';

/// 위치 인증 응답 DTO
/// POST /api/v1/verification/location 응답
@JsonSerializable()
class LocationVerificationResponseDto {
  /// 검증 성공 여부
  @JsonKey(name: 'is_valid')
  final bool isValid;

  /// 검증 결과 메시지
  final String reason;

  /// 캠페인 장소와의 거리 (미터 단위, 선택)
  final double? distance;

  /// 검증 시간 (ISO 8601 형식, 선택)
  @JsonKey(name: 'verified_at')
  final String? verifiedAt;

  /// 캠페인 장소 주소 (선택)
  @JsonKey(name: 'location_address')
  final String? locationAddress;

  const LocationVerificationResponseDto({
    required this.isValid,
    required this.reason,
    this.distance,
    this.verifiedAt,
    this.locationAddress,
  });

  factory LocationVerificationResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LocationVerificationResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LocationVerificationResponseDtoToJson(this);
}
