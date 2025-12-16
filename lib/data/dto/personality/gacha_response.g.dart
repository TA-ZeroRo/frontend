// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gacha_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GachaResponse _$GachaResponseFromJson(Map<String, dynamic> json) =>
    GachaResponse(
      personality: PersonalityResult.fromJson(
          json['personality'] as Map<String, dynamic>),
      isNew: json['is_new'] as bool,
      remainingTickets: (json['remaining_tickets'] as num).toInt(),
    );

Map<String, dynamic> _$GachaResponseToJson(GachaResponse instance) =>
    <String, dynamic>{
      'personality': instance.personality,
      'is_new': instance.isNew,
      'remaining_tickets': instance.remainingTickets,
    };

PersonalityResult _$PersonalityResultFromJson(Map<String, dynamic> json) =>
    PersonalityResult(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$PersonalityResultToJson(PersonalityResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };
