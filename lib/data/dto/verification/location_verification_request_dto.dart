import 'package:json_annotation/json_annotation.dart';

part 'location_verification_request_dto.g.dart';

/// 위치 인증 요청 DTO
/// POST /api/v1/verification/location
@JsonSerializable()
class LocationVerificationRequestDto {
  @JsonKey(name: 'campaign_id')
  final int campaignId;

  final double latitude;

  final double longitude;

  const LocationVerificationRequestDto({
    required this.campaignId,
    required this.latitude,
    required this.longitude,
  });

  factory LocationVerificationRequestDto.fromJson(Map<String, dynamic> json) =>
      _$LocationVerificationRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LocationVerificationRequestDtoToJson(this);
}
