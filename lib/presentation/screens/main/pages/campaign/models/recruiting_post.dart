class RecruitingPost {
  final String id;
  final String hostId; // 주최자 ID
  final String campaignId;
  final String campaignTitle;
  final String campaignImageUrl;
  final String title;
  final String region;
  final String city;
  final int capacity;
  final int currentMembers;
  final DateTime startDate;
  final DateTime endDate;
  final int minAge;
  final int maxAge;
  final bool isRecruiting;
  final bool isParticipating;
  final String? chatRoomId;

  const RecruitingPost({
    required this.id,
    required this.hostId,
    required this.campaignId,
    required this.campaignTitle,
    required this.campaignImageUrl,
    required this.title,
    required this.region,
    required this.city,
    required this.capacity,
    required this.currentMembers,
    required this.startDate,
    required this.endDate,
    required this.minAge,
    required this.maxAge,
    this.isRecruiting = false,
    this.isParticipating = false,
    this.chatRoomId,
  });

  RecruitingPost copyWith({
    String? id,
    String? hostId,
    String? campaignId,
    String? campaignTitle,
    String? campaignImageUrl,
    String? title,
    String? region,
    String? city,
    int? capacity,
    int? currentMembers,
    DateTime? startDate,
    DateTime? endDate,
    int? minAge,
    int? maxAge,
    bool? isRecruiting,
    bool? isParticipating,
    String? chatRoomId,
  }) {
    return RecruitingPost(
      id: id ?? this.id,
      hostId: hostId ?? this.hostId,
      campaignId: campaignId ?? this.campaignId,
      campaignTitle: campaignTitle ?? this.campaignTitle,
      campaignImageUrl: campaignImageUrl ?? this.campaignImageUrl,
      title: title ?? this.title,
      region: region ?? this.region,
      city: city ?? this.city,
      capacity: capacity ?? this.capacity,
      currentMembers: currentMembers ?? this.currentMembers,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      isRecruiting: isRecruiting ?? this.isRecruiting,
      isParticipating: isParticipating ?? this.isParticipating,
      chatRoomId: chatRoomId ?? this.chatRoomId,
    );
  }
}
