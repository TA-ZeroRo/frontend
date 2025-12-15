import 'package:json_annotation/json_annotation.dart';
import 'personality_info.dart';

part 'personality_list_response.g.dart';

/// 보유 성격 목록 조회 응답
@JsonSerializable()
class PersonalityListResponse {
  final List<PersonalityInfo> personalities;
  @JsonKey(name: 'owned_personalities')
  final List<String> ownedPersonalities;
  @JsonKey(name: 'gacha_tickets')
  final int gachaTickets;

  const PersonalityListResponse({
    required this.personalities,
    required this.ownedPersonalities,
    required this.gachaTickets,
  });

  factory PersonalityListResponse.fromJson(Map<String, dynamic> json) =>
      _$PersonalityListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PersonalityListResponseToJson(this);
}
