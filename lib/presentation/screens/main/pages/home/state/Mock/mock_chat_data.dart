/// Mock 채팅 응답 데이터
class MockChatData {
  static final List<String> responses = [
    '안녕하세요! 저는 제로로예요. 무엇을 도와드릴까요?',
    '좋은 질문이네요! 제가 도와드릴게요.',
    '흥미로운 주제네요. 함께 알아볼까요?',
    '그것에 대해 자세히 설명해드릴게요!',
    '제가 분석한 결과를 말씀드리면...',
    '더 궁금하신 점이 있으시면 언제든 물어보세요!',
    '제로로가 도와드릴 수 있어서 기쁩니다!',
    '좋은 생각이에요! 이렇게 해보시는 건 어떨까요?',
  ];

  static int _currentIndex = 0;

  /// 순차적으로 응답 반환
  static String getNextResponse() {
    final response = responses[_currentIndex];
    _currentIndex = (_currentIndex + 1) % responses.length;
    return response;
  }

  /// 랜덤 응답 반환
  static String getRandomResponse() {
    responses.shuffle();
    return responses.first;
  }

  /// 인덱스 초기화
  static void reset() {
    _currentIndex = 0;
  }
}
