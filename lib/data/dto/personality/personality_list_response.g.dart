// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personality_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalityListResponse _$PersonalityListResponseFromJson(
  Map<String, dynamic> json,
) => PersonalityListResponse(
  personalities: (json['personalities'] as List<dynamic>)
      .map((e) => PersonalityInfo.fromJson(e as Map<String, dynamic>))
      .toList(),
  ownedPersonalities: (json['owned_personalities'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  gachaTickets: (json['gacha_tickets'] as num).toInt(),
);

Map<String, dynamic> _$PersonalityListResponseToJson(
  PersonalityListResponse instance,
) => <String, dynamic>{
  'personalities': instance.personalities,
  'owned_personalities': instance.ownedPersonalities,
  'gacha_tickets': instance.gachaTickets,
};
