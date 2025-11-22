// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaderboardResponseDto _$LeaderboardResponseDtoFromJson(
  Map<String, dynamic> json,
) => LeaderboardResponseDto(
  leaderboard: (json['leaderboard'] as List<dynamic>)
      .map((e) => LeaderboardEntryDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  myRank: json['my_rank'] == null
      ? null
      : LeaderboardEntryDto.fromJson(json['my_rank'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LeaderboardResponseDtoToJson(
  LeaderboardResponseDto instance,
) => <String, dynamic>{
  'leaderboard': instance.leaderboard,
  'my_rank': instance.myRank,
};
