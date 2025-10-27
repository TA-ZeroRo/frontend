// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['id'] as String,
  username: json['username'] as String,
  userImg: json['userImg'] as String?,
  totalPoints: (json['totalPoints'] as num).toInt(),
  continuousDays: (json['continuousDays'] as num).toInt(),
  region: json['region'] as String,
  characters: (json['characters'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  lastActiveAt: json['lastActiveAt'] == null
      ? null
      : DateTime.parse(json['lastActiveAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'userImg': instance.userImg,
  'totalPoints': instance.totalPoints,
  'continuousDays': instance.continuousDays,
  'region': instance.region,
  'characters': instance.characters,
  'lastActiveAt': instance.lastActiveAt?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
};
