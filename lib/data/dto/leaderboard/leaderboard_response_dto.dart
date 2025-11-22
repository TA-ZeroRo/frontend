import 'package:json_annotation/json_annotation.dart';

import 'leaderboard_entry_dto.dart';

part 'leaderboard_response_dto.g.dart';

/// 리더보드 응답 DTO (상위 랭킹 + 내 순위)
@JsonSerializable()
class LeaderboardResponseDto {
  /// 상위 랭킹 리스트
  final List<LeaderboardEntryDto> leaderboard;

  /// 내 순위 정보 (nullable)
  @JsonKey(name: 'my_rank')
  final LeaderboardEntryDto? myRank;

  const LeaderboardResponseDto({
    required this.leaderboard,
    this.myRank,
  });

  factory LeaderboardResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LeaderboardResponseDtoToJson(this);
}
