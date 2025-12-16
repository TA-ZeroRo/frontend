import 'package:json_annotation/json_annotation.dart';

import '../../../domain/model/plogging/plogging_session.dart';
import 'gps_point_dto.dart';

part 'plogging_session_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class PloggingSessionDto {
  final int id;
  @JsonKey(name: 'user_id')
  final String userId;
  final String status;
  @JsonKey(name: 'started_at')
  final String startedAt;
  @JsonKey(name: 'ended_at')
  final String? endedAt;
  @JsonKey(name: 'duration_minutes')
  final int? durationMinutes;
  @JsonKey(name: 'total_distance_meters')
  final double? totalDistanceMeters;
  @JsonKey(name: 'intensity_level')
  final int intensityLevel;
  @JsonKey(name: 'verification_count')
  final int verificationCount;
  @JsonKey(name: 'points_earned')
  final int pointsEarned;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'route_points')
  final List<GpsPointDto>? routePoints;
  @JsonKey(name: 'initial_photo_url')
  final String? initialPhotoUrl;

  const PloggingSessionDto({
    required this.id,
    required this.userId,
    required this.status,
    required this.startedAt,
    this.endedAt,
    this.durationMinutes,
    this.totalDistanceMeters,
    this.intensityLevel = 1,
    this.verificationCount = 0,
    this.pointsEarned = 0,
    required this.createdAt,
    this.routePoints,
    this.initialPhotoUrl,
  });

  factory PloggingSessionDto.fromJson(Map<String, dynamic> json) =>
      _$PloggingSessionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PloggingSessionDtoToJson(this);

  PloggingSession toModel() {
    return PloggingSession(
      id: id,
      userId: userId,
      status: _parseStatus(status),
      startedAt: DateTime.parse(startedAt),
      endedAt: endedAt != null ? DateTime.parse(endedAt!) : null,
      durationMinutes: durationMinutes,
      totalDistanceMeters: totalDistanceMeters,
      intensityLevel: intensityLevel,
      verificationCount: verificationCount,
      pointsEarned: pointsEarned,
      createdAt: DateTime.parse(createdAt),
      initialPhotoUrl: initialPhotoUrl,
    );
  }

  PloggingStatus _parseStatus(String status) {
    switch (status) {
      case 'IN_PROGRESS':
        return PloggingStatus.inProgress;
      case 'COMPLETED':
        return PloggingStatus.completed;
      case 'CANCELLED':
        return PloggingStatus.cancelled;
      default:
        return PloggingStatus.inProgress;
    }
  }
}

@JsonSerializable()
class PloggingSessionCreateRequest {
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'initial_photo_url')
  final String initialPhotoUrl;

  const PloggingSessionCreateRequest({
    required this.userId,
    required this.initialPhotoUrl,
  });

  factory PloggingSessionCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$PloggingSessionCreateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PloggingSessionCreateRequestToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PloggingSessionEndRequest {
  @JsonKey(name: 'route_points')
  final List<GpsPointDto> routePoints;

  const PloggingSessionEndRequest({required this.routePoints});

  factory PloggingSessionEndRequest.fromJson(Map<String, dynamic> json) =>
      _$PloggingSessionEndRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PloggingSessionEndRequestToJson(this);
}
