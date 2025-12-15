import 'package:json_annotation/json_annotation.dart';

part 'text_verification_response_dto.g.dart';

@JsonSerializable()
class TextVerificationResponseDto {
  @JsonKey(name: 'is_valid')
  final bool isValid;
  final double confidence;
  final String reason;

  const TextVerificationResponseDto({
    required this.isValid,
    required this.confidence,
    required this.reason,
  });

  factory TextVerificationResponseDto.fromJson(Map<String, dynamic> json) =>
      _$TextVerificationResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TextVerificationResponseDtoToJson(this);
}
