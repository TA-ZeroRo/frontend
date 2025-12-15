import 'package:json_annotation/json_annotation.dart';

part 'character_info.g.dart';

@JsonSerializable()
class CharacterInfo {
  final String id;
  final String name;
  final String description;
  final String greeting;
  @JsonKey(name: 'is_unlocked')
  final bool isUnlocked;
  @JsonKey(name: 'required_points')
  final int requiredPoints;
  @JsonKey(name: 'can_unlock')
  final bool canUnlock;

  const CharacterInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.greeting,
    required this.isUnlocked,
    required this.requiredPoints,
    required this.canUnlock,
  });

  factory CharacterInfo.fromJson(Map<String, dynamic> json) =>
      _$CharacterInfoFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterInfoToJson(this);
}
