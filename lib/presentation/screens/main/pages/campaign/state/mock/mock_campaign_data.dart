/// Mock 캠페인 데이터
/// Presentation Layer 내에서 사용하는 데이터 클래스
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
    );
  }
}

/// Mock 캠페인 데이터 리스트
final mockCampaigns = [
  CampaignData(
    id: '1',
    title: '신제품 뷰티 크림 체험단 모집',
    imageUrl: 'https://picsum.photos/seed/campaign1/800/450',
    url: 'https://flutter.dev',
    startDate: DateTime(2025, 1, 15),
    endDate: DateTime(2025, 2, 28),
    region: '서울',
    city: '강남구',
    category: '뷰티',
  ),
  CampaignData(
    id: '2',
    title: '프리미엄 레스토랑 방문 리뷰 캠페인',
    imageUrl: 'https://picsum.photos/seed/campaign2/800/450',
    url: 'https://pub.dev',
    startDate: DateTime(2025, 1, 10),
    endDate: DateTime(2025, 2, 10),
    region: '서울',
    city: '서초구',
    category: '식품',
  ),
  CampaignData(
    id: '3',
    title: '최신 스마트워치 사용 후기 이벤트',
    imageUrl: 'https://picsum.photos/seed/campaign3/800/450',
    url: 'https://dart.dev',
    startDate: DateTime(2025, 1, 20),
    endDate: DateTime(2025, 3, 20),
    region: '경기',
    city: '성남시',
    category: '전자기기',
  ),
  CampaignData(
    id: '4',
    title: '친환경 생활용품 체험 캠페인',
    imageUrl: 'https://picsum.photos/seed/campaign4/800/450',
    url: 'https://github.com',
    startDate: DateTime(2025, 1, 5),
    endDate: DateTime(2025, 2, 5),
    region: '서울',
    city: '마포구',
    category: '생활용품',
  ),
  CampaignData(
    id: '5',
    title: '프리미엄 커피 원두 시음 이벤트',
    imageUrl: 'https://picsum.photos/seed/campaign5/800/450',
    url: 'https://stackoverflow.com',
    startDate: DateTime(2025, 1, 25),
    endDate: DateTime(2025, 3, 10),
    region: '부산',
    city: '해운대구',
    category: '식품',
  ),
  CampaignData(
    id: '6',
    title: '키즈 장난감 체험단 모집',
    imageUrl: 'https://picsum.photos/seed/campaign6/800/450',
    url: 'https://medium.com',
    startDate: DateTime(2025, 2, 1),
    endDate: DateTime(2025, 3, 15),
    region: '인천',
    city: '연수구',
    category: '완구',
  ),
  CampaignData(
    id: '7',
    title: '헬스케어 앱 베타 테스터 모집',
    imageUrl: 'https://picsum.photos/seed/campaign7/800/450',
    url: 'https://news.ycombinator.com',
    startDate: DateTime(2025, 1, 12),
    endDate: DateTime(2025, 2, 20),
    region: '서울',
    city: '송파구',
    category: '헬스',
  ),
  CampaignData(
    id: '8',
    title: '인기 만화책 선행 리뷰 이벤트',
    imageUrl: 'https://picsum.photos/seed/campaign8/800/450',
    url: 'https://reddit.com',
    startDate: DateTime(2025, 1, 18),
    endDate: DateTime(2025, 2, 25),
    region: '경기',
    city: '수원시',
    category: '도서',
  ),
  CampaignData(
    id: '9',
    title: '신상 운동화 착용 후기 캠페인',
    imageUrl: 'https://picsum.photos/seed/campaign9/800/450',
    url: 'https://wikipedia.org',
    startDate: DateTime(2025, 1, 8),
    endDate: DateTime(2025, 2, 15),
    region: '대구',
    city: '중구',
    category: '패션',
  ),
  CampaignData(
    id: '10',
    title: '반려동물 간식 시식 이벤트',
    imageUrl: 'https://picsum.photos/seed/campaign10/800/450',
    url: 'https://google.com',
    startDate: DateTime(2025, 1, 22),
    endDate: DateTime(2025, 3, 5),
    region: '서울',
    city: '용산구',
    category: '펫',
  ),
];

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
  '뷰티',
  '식품',
  '전자기기',
  '생활용품',
  '완구',
  '헬스',
  '도서',
  '패션',
  '펫',
];
