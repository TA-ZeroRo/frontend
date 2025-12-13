import 'package:json_annotation/json_annotation.dart';

part 'image_verification_response_dto.g.dart';

@JsonSerializable()
class ImageVerificationResponseDto {
  final ImageVerificationResultDto result;

  const ImageVerificationResponseDto({required this.result});

  factory ImageVerificationResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ImageVerificationResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ImageVerificationResponseDtoToJson(this);
}

@JsonSerializable()
class ImageVerificationResultDto {
  @JsonKey(name: 'is_valid')
  final bool isValid;
  final double confidence;
  final String reason;

  const ImageVerificationResultDto({
    required this.isValid,
    required this.confidence,
    required this.reason,
  });

  factory ImageVerificationResultDto.fromJson(Map<String, dynamic> json) =>
      _$ImageVerificationResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ImageVerificationResultDtoToJson(this);
}
