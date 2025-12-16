import 'package:json_annotation/json_annotation.dart';

part 'gacha_response.g.dart';

/// 성격 뽑기 결과
@JsonSerializable()
class GachaResponse {
  final PersonalityResult personality;
  @JsonKey(name: 'is_new')
  final bool isNew;
  @JsonKey(name: 'remaining_tickets')
  final int remainingTickets;

  const GachaResponse({
    required this.personality,
    required this.isNew,
    required this.remainingTickets,
  });

  factory GachaResponse.fromJson(Map<String, dynamic> json) =>
      _$GachaResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GachaResponseToJson(this);
}

@JsonSerializable()
class PersonalityResult {
  final String id;
  final String name;
  final String description;

  const PersonalityResult({
    required this.id,
    required this.name,
    required this.description,
  });

  factory PersonalityResult.fromJson(Map<String, dynamic> json) =>
      _$PersonalityResultFromJson(json);

  Map<String, dynamic> toJson() => _$PersonalityResultToJson(this);
}
