// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeaderboardEntry _$LeaderboardEntryFromJson(Map<String, dynamic> json) =>
    _LeaderboardEntry(
      id: json['id'] as String,
      username: json['username'] as String?,
      userImg: json['userImg'] as String?,
      totalPoints: (json['totalPoints'] as num).toInt(),
      rank: (json['rank'] as num).toInt(),
    );

Map<String, dynamic> _$LeaderboardEntryToJson(_LeaderboardEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'userImg': instance.userImg,
      'totalPoints': instance.totalPoints,
      'rank': instance.rank,
    };
