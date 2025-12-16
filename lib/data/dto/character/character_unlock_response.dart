import 'package:json_annotation/json_annotation.dart';

part 'character_unlock_response.g.dart';

@JsonSerializable()
class CharacterUnlockResponse {
  final String message;
  @JsonKey(name: 'character_name')
  final String characterName;
  final bool success;

  const CharacterUnlockResponse({
    required this.message,
    required this.characterName,
    required this.success,
  });

  factory CharacterUnlockResponse.fromJson(Map<String, dynamic> json) =>
      _$CharacterUnlockResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterUnlockResponseToJson(this);
}
