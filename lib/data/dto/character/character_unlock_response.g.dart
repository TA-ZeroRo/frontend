// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_unlock_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterUnlockResponse _$CharacterUnlockResponseFromJson(
  Map<String, dynamic> json,
) => CharacterUnlockResponse(
  message: json['message'] as String,
  characterName: json['character_name'] as String,
  success: json['success'] as bool,
);

Map<String, dynamic> _$CharacterUnlockResponseToJson(
  CharacterUnlockResponse instance,
) => <String, dynamic>{
  'message': instance.message,
  'character_name': instance.characterName,
  'success': instance.success,
};
