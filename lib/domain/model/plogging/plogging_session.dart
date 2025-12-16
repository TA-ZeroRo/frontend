import 'package:freezed_annotation/freezed_annotation.dart';

part 'plogging_session.freezed.dart';
part 'plogging_session.g.dart';

enum PloggingStatus {
  @JsonValue('IN_PROGRESS')
  inProgress,
  @JsonValue('COMPLETED')
  completed,
  @JsonValue('CANCELLED')
  cancelled,
}

@freezed
abstract class PloggingSession with _$PloggingSession {
  const factory PloggingSession({
    required int id,
    required String userId,
    required PloggingStatus status,
    required DateTime startedAt,
    DateTime? endedAt,
    int? durationMinutes,
    double? totalDistanceMeters,
    @Default(1) int intensityLevel,
    @Default(0) int verificationCount,
    @Default(0) int pointsEarned,
    required DateTime createdAt,
    String? initialPhotoUrl,
  }) = _PloggingSession;

  factory PloggingSession.fromJson(Map<String, dynamic> json) =>
      _$PloggingSessionFromJson(json);
}
