import 'package:frontend/domain/model/chat_message.dart';
import 'package:frontend/domain/model/conversation.dart';
import 'package:frontend/domain/model/chat_summary.dart';

class MockChatData {
  MockChatData._();

  // Mock AI responses
  static const List<String> aiResponses = [
    '안녕하세요! 환경 보호에 대해 무엇이든 물어보세요 🌱',
    '좋은 질문이에요! 플라스틱 재활용은 환경 보호에 매우 중요합니다.',
    '재사용 가능한 제품을 사용하는 것은 환경을 지키는 좋은 방법이에요!',
    '탄소 발자국을 줄이는 방법에는 대중교통 이용, 에너지 절약 등이 있습니다.',
    '친환경 제품 사용은 지구를 지키는 첫 걸음입니다 🌍',
    '분리수거는 재활용을 위한 필수 과정이에요. 올바른 분리가 중요합니다!',
    '전기 자동차는 탄소 배출을 줄이는 데 도움을 줍니다.',
    '나무 심기는 공기 정화와 탄소 흡수에 효과적입니다 🌳',
    '일회용품 사용을 줄이면 환경 오염을 크게 줄일 수 있어요.',
    '에너지 효율 등급이 높은 제품을 선택하는 것도 중요합니다!',
  ];

  // Mock conversations
  static final List<Conversation> mockConversations = [
    Conversation(
      id: 'conv_1',
      title: '플라스틱 재활용에 대해',
      messages: [
        ChatMessage(
          id: 'msg_1',
          text: '플라스틱 재활용은 어떻게 하나요?',
          sender: 'user',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          isUser: true,
        ),
        ChatMessage(
          id: 'msg_2',
          text: '플라스틱 재활용은 먼저 깨끗이 씻어서 분리수거함에 넣어야 해요. 투명 페트병은 라벨을 제거하고 압착해서 배출하면 재활용률이 높아집니다!',
          sender: 'ai',
          timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 1)),
          isUser: false,
        ),
        ChatMessage(
          id: 'msg_3',
          text: '투명 페트병만 따로 모아야 하나요?',
          sender: 'user',
          timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
          isUser: true,
        ),
        ChatMessage(
          id: 'msg_4',
          text: '네! 투명 페트병은 고품질 재활용이 가능해서 별도로 분리하면 좋아요. 다른 색상의 페트병은 일반 플라스틱으로 분류됩니다.',
          sender: 'ai',
          timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 49)),
          isUser: false,
        ),
      ],
      lastUpdated: DateTime.now().subtract(const Duration(hours: 1, minutes: 49)),
    ),
    Conversation(
      id: 'conv_2',
      title: '탄소 배출 줄이기',
      messages: [
        ChatMessage(
          id: 'msg_5',
          text: '탄소 배출을 줄이는 방법이 궁금해요',
          sender: 'user',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          isUser: true,
        ),
        ChatMessage(
          id: 'msg_6',
          text: '탄소 배출을 줄이는 방법은 여러 가지가 있어요!\n\n1. 대중교통 이용하기\n2. 에너지 절약 (LED 전구 사용)\n3. 재생 가능 에너지 사용\n4. 음식물 쓰레기 줄이기\n5. 친환경 제품 구매하기\n\n작은 실천이 큰 변화를 만들어요! 🌍',
          sender: 'ai',
          timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 23, minutes: 58)),
          isUser: false,
        ),
      ],
      lastUpdated: DateTime.now().subtract(const Duration(days: 1, hours: 23, minutes: 58)),
    ),
    Conversation(
      id: 'conv_3',
      title: '친환경 생활 시작하기',
      messages: [
        ChatMessage(
          id: 'msg_7',
          text: '환경 보호를 위해 뭐부터 시작하면 좋을까요?',
          sender: 'user',
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
          isUser: true,
        ),
        ChatMessage(
          id: 'msg_8',
          text: '좋은 질문이에요! 시작은 간단한 것부터:\n\n✅ 텀블러 사용하기\n✅ 장바구니 들고 다니기\n✅ 분리수거 철저히 하기\n✅ 불필요한 전기 끄기\n\n이런 작은 습관들이 모여 큰 변화를 만듭니다!',
          sender: 'ai',
          timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 23, minutes: 55)),
          isUser: false,
        ),
        ChatMessage(
          id: 'msg_9',
          text: '텀블러는 어떤 종류가 좋나요?',
          sender: 'user',
          timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 23, minutes: 50)),
          isUser: true,
        ),
        ChatMessage(
          id: 'msg_10',
          text: '스테인리스 텀블러가 가장 좋아요! 보온/보냉 기능이 있고, 오래 사용할 수 있어 환경에도 좋답니다. 유리 텀블러도 좋은 선택이에요!',
          sender: 'ai',
          timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 23, minutes: 48)),
          isUser: false,
        ),
      ],
      lastUpdated: DateTime.now().subtract(const Duration(days: 3, hours: 23, minutes: 48)),
    ),
  ];

  // Mock chat summaries for history
  static final List<ChatSummary> mockChatSummaries = [
    ChatSummary(
      id: 'conv_1',
      title: '플라스틱 재활용에 대해',
      preview: '네! 투명 페트병은 고품질 재활용이 가능해서...',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 1, minutes: 49)),
    ),
    ChatSummary(
      id: 'conv_2',
      title: '탄소 배출 줄이기',
      preview: '탄소 배출을 줄이는 방법은 여러 가지가 있어요!',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1, hours: 23, minutes: 58)),
    ),
    ChatSummary(
      id: 'conv_3',
      title: '친환경 생활 시작하기',
      preview: '스테인리스 텀블러가 가장 좋아요!',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 3, hours: 23, minutes: 48)),
    ),
  ];

  // Get random AI response
  static String getRandomResponse() {
    return aiResponses[(DateTime.now().millisecondsSinceEpoch % aiResponses.length)];
  }

  // Get conversation by ID
  static Conversation? getConversationById(String id) {
    try {
      return mockConversations.firstWhere((conv) => conv.id == id);
    } catch (e) {
      return null;
    }
  }
}
