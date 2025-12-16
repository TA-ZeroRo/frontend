// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterInfo _$CharacterInfoFromJson(Map<String, dynamic> json) =>
    CharacterInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      greeting: json['greeting'] as String,
      isUnlocked: json['is_unlocked'] as bool,
      requiredPoints: (json['required_points'] as num).toInt(),
      canUnlock: json['can_unlock'] as bool,
    );

Map<String, dynamic> _$CharacterInfoToJson(CharacterInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'greeting': instance.greeting,
      'is_unlocked': instance.isUnlocked,
      'required_points': instance.requiredPoints,
      'can_unlock': instance.canUnlock,
    };
