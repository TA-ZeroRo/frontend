import 'package:json_annotation/json_annotation.dart';

import '../../../domain/model/leaderboard/leaderboard_entry.dart';

part 'leaderboard_entry_dto.g.dart';

/// 리더보드 엔트리 DTO
@JsonSerializable()
class LeaderboardEntryDto {
  /// 사용자 ID
  final String id;

  /// 사용자명 (nullable)
  final String? username;

  /// 프로필 이미지 URL (nullable)
  @JsonKey(name: 'user_img')
  final String? userImg;

  /// 총 포인트
  @JsonKey(name: 'total_points', defaultValue: 0)
  final int totalPoints;

  /// 연속 일수
  @JsonKey(name: 'continuous_days', defaultValue: 0)
  final int continuousDays;

  /// 순위 (API에서 Optional로 반환될 수 있음)
  @JsonKey(defaultValue: 0)
  final int? rank;

  const LeaderboardEntryDto({
    required this.id,
    this.username,
    this.userImg,
    required this.totalPoints,
    required this.continuousDays,
    this.rank,
  });

  factory LeaderboardEntryDto.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardEntryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LeaderboardEntryDtoToJson(this);

  /// DTO를 Domain 모델로 변환
  LeaderboardEntry toModel() {
    return LeaderboardEntry(
      id: id,
      username: username,
      userImg: userImg,
      totalPoints: totalPoints,
      rank: rank ?? 0, // null일 경우 0으로 처리
    );
  }
}
