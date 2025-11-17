/// Campaign Presentation Model
/// Presentation Layer에서 사용하는 캠페인 데이터 클래스
class CampaignData {
  final String id;
  final String title;
  final String imageUrl;
  final String url; // 캠페인 상세 페이지 URL
  final DateTime startDate;
  final DateTime endDate;
  final String region; // 지역(도)
  final String city; // 시
  final String category; // 카테고리
  final bool isParticipating; // 참가 여부
  final bool isAutoProcessable; // 자동 처리 가능 여부

  const CampaignData({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.url,
    required this.startDate,
    required this.endDate,
    required this.region,
    required this.city,
    required this.category,
    this.isParticipating = false,
    this.isAutoProcessable = false,
  });

  /// 캠페인 기간 문자열 반환 (예: "2025.01.15 - 2025.02.15")
  String get periodText {
    final start =
        '${startDate.year}.${startDate.month.toString().padLeft(2, '0')}.${startDate.day.toString().padLeft(2, '0')}';
    final end =
        '${endDate.year}.${endDate.month.toString().padLeft(2, '0')}.${endDate.day.toString().padLeft(2, '0')}';
    return '$start - $end';
  }

  /// 캠페인이 진행중인지 확인
  bool get isOngoing {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }

  /// 캠페인이 곧 종료되는지 확인 (7일 이내)
  bool get isEndingSoon {
    final now = DateTime.now();
    final daysUntilEnd = endDate.difference(now).inDays;
    return isOngoing && daysUntilEnd <= 7;
  }

  CampaignData copyWith({
    String? id,
    String? title,
    String? imageUrl,
    String? url,
    DateTime? startDate,
    DateTime? endDate,
    String? region,
    String? city,
    String? category,
    bool? isParticipating,
    bool? isAutoProcessable,
  }) {
    return CampaignData(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      url: url ?? this.url,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      region: region ?? this.region,
      city: city ?? this.city,
      category: category ?? this.category,
      isParticipating: isParticipating ?? this.isParticipating,
      isAutoProcessable: isAutoProcessable ?? this.isAutoProcessable,
    );
  }
}

/// 지역 목록 (도)
const regions = [
  '전체',
  '서울',
  '경기',
  '인천',
  '부산',
  '대구',
  '광주',
  '대전',
  '울산',
  '세종',
  '강원',
  '충북',
  '충남',
  '전북',
  '전남',
  '경북',
  '경남',
  '제주',
];

/// 시/군/구 목록 (지역에 따라 동적으로 변경)
const citiesByRegion = {
  '서울': ['전체', '강남구', '서초구', '마포구', '송파구', '용산구', '종로구', '중구'],
  '경기': ['전체', '성남시', '수원시', '고양시', '용인시', '부천시'],
  '인천': ['전체', '연수구', '남동구', '부평구', '서구'],
  '부산': ['전체', '해운대구', '수영구', '사하구', '중구'],
  '대구': ['전체', '중구', '동구', '서구', '남구'],
};

/// 카테고리 목록
const categories = [
  '전체',
  '재활용',
  '대중교통',
  '에너지절약',
  '제로웨이스트',
  '자연보호',
  '교육',
  '기타',
];
