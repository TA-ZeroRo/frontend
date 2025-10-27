import 'package:json_annotation/json_annotation.dart';
import '../../../domain/model/user/user.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDto {
  final String id;
  final String username;
  @JsonKey(name: 'user_img')
  final String? userImg;
  @JsonKey(name: 'total_points')
  final int totalPoints;
  @JsonKey(name: 'continuous_days')
  final int continuousDays;
  final String region;
  final List<String> characters;
  @JsonKey(name: 'last_active_at')
  final String? lastActiveAt;
  @JsonKey(name: 'created_at')
  final String createdAt;

  const UserDto({
    required this.id,
    required this.username,
    this.userImg,
    required this.totalPoints,
    required this.continuousDays,
    required this.region,
    required this.characters,
    this.lastActiveAt,
    required this.createdAt,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);

  User toModel() {
    return User(
      id: id,
      username: username,
      userImg: userImg,
      totalPoints: totalPoints,
      continuousDays: continuousDays,
      region: region,
      characters: characters,
      lastActiveAt: lastActiveAt != null ? DateTime.parse(lastActiveAt!) : null,
      createdAt: DateTime.parse(createdAt),
    );
  }
}
