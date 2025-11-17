/// 미션 로그 상태
enum MissionStatus {
  /// 진행 중
  inProgress('IN_PROGRESS'),

  /// 검증 대기 (RPA 제출 후)
  pendingVerification('PENDING_VERIFICATION'),

  /// 완료
  completed('COMPLETED'),

  /// 실패
  failed('FAILED');

  const MissionStatus(this.value);

  final String value;

  /// JSON 값에서 MissionStatus로 변환
  static MissionStatus fromString(String value) {
    return MissionStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => throw ArgumentError('Unknown mission status: $value'),
    );
  }
}
