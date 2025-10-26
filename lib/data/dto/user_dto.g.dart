// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDto _$UserDtoFromJson(Map<String, dynamic> json) => UserDto(
  id: json['id'] as String,
  username: json['username'] as String,
  userImg: json['user_img'] as String?,
  totalPoints: (json['total_points'] as num).toInt(),
  continuousDays: (json['continuous_days'] as num).toInt(),
  region: json['region'] as String,
  characters: (json['characters'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  lastActiveAt: json['last_active_at'] as String,
  createdAt: json['created_at'] as String,
);

Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'user_img': instance.userImg,
  'total_points': instance.totalPoints,
  'continuous_days': instance.continuousDays,
  'region': instance.region,
  'characters': instance.characters,
  'last_active_at': instance.lastActiveAt,
  'created_at': instance.createdAt,
};
