// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personality_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalityInfo _$PersonalityInfoFromJson(Map<String, dynamic> json) =>
    PersonalityInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      isOwned: json['is_owned'] as bool,
    );

Map<String, dynamic> _$PersonalityInfoToJson(PersonalityInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'is_owned': instance.isOwned,
    };
