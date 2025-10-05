// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Profile _$ProfileFromJson(Map<String, dynamic> json) => _Profile(
  userId: json['userId'] as String,
  username: json['username'] as String,
  userImg: json['userImg'] as String?,
  totalPoints: (json['totalPoints'] as num?)?.toInt() ?? 0,
  continuousDays: (json['continuousDays'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ProfileToJson(_Profile instance) => <String, dynamic>{
  'userId': instance.userId,
  'username': instance.username,
  'userImg': instance.userImg,
  'totalPoints': instance.totalPoints,
  'continuousDays': instance.continuousDays,
};
