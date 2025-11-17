// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_entry_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaderboardEntryDto _$LeaderboardEntryDtoFromJson(Map<String, dynamic> json) =>
    LeaderboardEntryDto(
      id: json['id'] as String,
      username: json['username'] as String?,
      userImg: json['user_img'] as String?,
      totalPoints: (json['total_points'] as num?)?.toInt() ?? 0,
      continuousDays: (json['continuous_days'] as num?)?.toInt() ?? 0,
      rank: (json['rank'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$LeaderboardEntryDtoToJson(
  LeaderboardEntryDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'user_img': instance.userImg,
  'total_points': instance.totalPoints,
  'continuous_days': instance.continuousDays,
  'rank': instance.rank,
};
