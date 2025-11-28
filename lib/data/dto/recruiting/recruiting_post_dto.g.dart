// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recruiting_post_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecruitingPostDto _$RecruitingPostDtoFromJson(Map<String, dynamic> json) =>
    RecruitingPostDto(
      id: (json['id'] as num).toInt(),
      userId: json['user_id'] as String,
      campaignId: (json['campaign_id'] as num).toInt(),
      title: json['title'] as String,
      region: json['region'] as String,
      city: json['city'] as String,
      capacity: (json['capacity'] as num).toInt(),
      currentMembers: (json['current_members'] as num).toInt(),
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String?,
      minAge: (json['min_age'] as num).toInt(),
      maxAge: (json['max_age'] as num).toInt(),
      isRecruiting: json['is_recruiting'] as bool,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      profiles: json['profiles'] as Map<String, dynamic>?,
      campaigns: json['campaigns'] as Map<String, dynamic>?,
      chatRoomId: (json['chat_room_id'] as num?)?.toInt(),
      isParticipating: json['is_participating'] as bool? ?? false,
    );

Map<String, dynamic> _$RecruitingPostDtoToJson(RecruitingPostDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'campaign_id': instance.campaignId,
      'title': instance.title,
      'region': instance.region,
      'city': instance.city,
      'capacity': instance.capacity,
      'current_members': instance.currentMembers,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'min_age': instance.minAge,
      'max_age': instance.maxAge,
      'is_recruiting': instance.isRecruiting,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'profiles': instance.profiles,
      'campaigns': instance.campaigns,
      'chat_room_id': instance.chatRoomId,
      'is_participating': instance.isParticipating,
    };
