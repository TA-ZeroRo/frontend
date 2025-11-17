import 'package:freezed_annotation/freezed_annotation.dart';

part 'leaderboard_entry.freezed.dart';
part 'leaderboard_entry.g.dart';

/// 리더보드 엔트리 모델
@freezed
abstract class LeaderboardEntry with _$LeaderboardEntry {
  const factory LeaderboardEntry({
    /// 사용자 ID
    required String id,

    /// 사용자명 (nullable)
    String? username,

    /// 프로필 이미지 URL (nullable)
    String? userImg,

    /// 총 포인트
    required int totalPoints,

    /// 순위
    required int rank,
  }) = _LeaderboardEntry;

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardEntryFromJson(json);
}
