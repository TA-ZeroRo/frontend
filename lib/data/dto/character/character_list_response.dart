import 'package:json_annotation/json_annotation.dart';
import 'character_info.dart';

part 'character_list_response.g.dart';

@JsonSerializable()
class CharacterListResponse {
  final List<CharacterInfo> characters;
  @JsonKey(name: 'total_points')
  final int totalPoints;
  @JsonKey(name: 'gacha_tickets')
  final int gachaTickets;

  const CharacterListResponse({
    required this.characters,
    required this.totalPoints,
    required this.gachaTickets,
  });

  factory CharacterListResponse.fromJson(Map<String, dynamic> json) =>
      _$CharacterListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterListResponseToJson(this);
}
