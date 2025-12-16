// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterListResponse _$CharacterListResponseFromJson(
  Map<String, dynamic> json,
) => CharacterListResponse(
  characters: (json['characters'] as List<dynamic>)
      .map((e) => CharacterInfo.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalPoints: (json['total_points'] as num).toInt(),
  gachaTickets: (json['gacha_tickets'] as num).toInt(),
);

Map<String, dynamic> _$CharacterListResponseToJson(
  CharacterListResponse instance,
) => <String, dynamic>{
  'characters': instance.characters,
  'total_points': instance.totalPoints,
  'gacha_tickets': instance.gachaTickets,
};
