import 'package:json_annotation/json_annotation.dart';
import '../../../presentation/screens/main/pages/campaign/models/recruiting_post.dart';

part 'recruiting_post_dto.g.dart';

@JsonSerializable()
class RecruitingPostDto {
  final int id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'campaign_id')
  final int campaignId;
  final String title;
  final String region;
  final String city;
  final int capacity;
  @JsonKey(name: 'current_members')
  final int currentMembers;
  @JsonKey(name: 'start_date')
  final String startDate;
  @JsonKey(name: 'end_date')
  final String? endDate;
  @JsonKey(name: 'min_age')
  final int minAge;
  @JsonKey(name: 'max_age')
  final int maxAge;
  @JsonKey(name: 'is_recruiting')
  final bool isRecruiting;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  final Map<String, dynamic>? profiles;
  @JsonKey(name: 'chat_room_id')
  final int? chatRoomId;
  @JsonKey(name: 'is_participating')
  final bool isParticipating;

  const RecruitingPostDto({
    required this.id,
    required this.userId,
    required this.campaignId,
    required this.title,
    required this.region,
    required this.city,
    required this.capacity,
    required this.currentMembers,
    required this.startDate,
    this.endDate,
    required this.minAge,
    required this.maxAge,
    required this.isRecruiting,
    required this.createdAt,
    required this.updatedAt,
    this.profiles,
    this.chatRoomId,
    this.isParticipating = false,
  });

  factory RecruitingPostDto.fromJson(Map<String, dynamic> json) =>
      _$RecruitingPostDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RecruitingPostDtoToJson(this);

  RecruitingPost toModel({
    String? campaignTitle,
    String? campaignImageUrl,
  }) {
    return RecruitingPost(
      id: id.toString(),
      hostId: userId,
      campaignId: campaignId.toString(),
      campaignTitle: campaignTitle ?? '',
      campaignImageUrl: campaignImageUrl ?? '',
      title: title,
      region: region,
      city: city,
      capacity: capacity,
      currentMembers: currentMembers,
      startDate: DateTime.parse(startDate),
      endDate: endDate != null ? DateTime.parse(endDate!) : DateTime.now(),
      minAge: minAge,
      maxAge: maxAge,
      isRecruiting: isRecruiting,
      isParticipating: isParticipating,
      chatRoomId: chatRoomId?.toString(),
    );
  }
}
