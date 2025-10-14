// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Comment _$CommentFromJson(Map<String, dynamic> json) => _Comment(
  id: (json['id'] as num).toInt(),
  postId: (json['postId'] as num).toInt(),
  userId: json['userId'] as String,
  content: json['content'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  username: json['username'] as String,
  userImg: json['userImg'] as String?,
);

Map<String, dynamic> _$CommentToJson(_Comment instance) => <String, dynamic>{
  'id': instance.id,
  'postId': instance.postId,
  'userId': instance.userId,
  'content': instance.content,
  'createdAt': instance.createdAt.toIso8601String(),
  'username': instance.username,
  'userImg': instance.userImg,
};
