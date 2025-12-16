import 'package:json_annotation/json_annotation.dart';

part 'personality_info.g.dart';

/// 성격 정보
@JsonSerializable()
class PersonalityInfo {
  final String id;
  final String name;
  final String description;
  @JsonKey(name: 'is_owned')
  final bool isOwned;

  const PersonalityInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.isOwned,
  });

  factory PersonalityInfo.fromJson(Map<String, dynamic> json) =>
      _$PersonalityInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PersonalityInfoToJson(this);
}
