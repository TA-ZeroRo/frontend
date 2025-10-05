// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Post _$PostFromJson(Map<String, dynamic> json) => _Post(
  id: (json['id'] as num).toInt(),
  userId: json['userId'] as String,
  title: json['title'] as String,
  content: json['content'] as String,
  imageUrl: json['imageUrl'] as String?,
  likesCount: (json['likesCount'] as num).toInt(),
  createdAt: json['createdAt'] as String,
  username: json['username'] as String,
  userImg: json['userImg'] as String?,
);

Map<String, dynamic> _$PostToJson(_Post instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'title': instance.title,
  'content': instance.content,
  'imageUrl': instance.imageUrl,
  'likesCount': instance.likesCount,
  'createdAt': instance.createdAt,
  'username': instance.username,
  'userImg': instance.userImg,
};
