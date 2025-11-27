/// 미션 인증 타입
enum VerificationType {
  /// 이미지 업로드
  image('IMAGE'),

  /// 텍스트 리뷰 작성
  textReview('TEXT_REVIEW'),

  /// 퀴즈
  quiz('QUIZ'),

  /// 위치 인증
  location('LOCATION');

  const VerificationType(this.value);

  final String value;

  /// JSON 값에서 VerificationType으로 변환
  static VerificationType fromString(String value) {
    return VerificationType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => throw ArgumentError('Unknown verification type: $value'),
    );
  }
}
