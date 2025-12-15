/// 캠페인 출처
enum CampaignSource {
  /// 제로로 자체 캠페인 (앱 내 미션 참여 가능)
  zeroro('ZERORO'),

  /// 외부 캠페인 (웹뷰 연결만 제공)
  external('EXTERNAL');

  const CampaignSource(this.value);

  final String value;

  /// JSON 값에서 CampaignSource로 변환
  static CampaignSource fromString(String? value) {
    if (value == null) return CampaignSource.external;
    return CampaignSource.values.firstWhere(
      (source) => source.value == value,
      orElse: () => CampaignSource.external,
    );
  }
}
