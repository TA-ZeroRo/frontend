import '../../../../../../domain/model/recruiting/chat_message.dart';

/// 리크루팅 채팅 Mock 데이터
class RecruitingChatMockData {
  /// 채팅방 ID별 메시지 목록
  static Map<String, List<ChatMessage>> getChatMessages() {
    return {
      'chat_room_1': _getChatRoom1Messages(),
      'chat_room_2': _getChatRoom2Messages(),
    };
  }

  /// 채팅방 1 메시지 (한강 플로깅 캠페인)
  static List<ChatMessage> _getChatRoom1Messages() {
    final now = DateTime.now();
    return [
      ChatMessage(
        id: 'msg_1_1',
        chatRoomId: 'chat_room_1',
        userId: 'user_001',
        username: '김환경',
        userImageUrl: 'https://i.pravatar.cc/150?u=user001',
        message: '안녕하세요! 이번 주말 한강 플로깅 같이 해요~',
        timestamp: now.subtract(const Duration(hours: 2)),
      ),
      ChatMessage(
        id: 'msg_1_2',
        chatRoomId: 'chat_room_1',
        userId: 'current_user',
        username: '나',
        userImageUrl: 'https://i.pravatar.cc/150?u=currentuser',
        message: '좋아요! 몇 시에 만나면 될까요?',
        timestamp: now.subtract(const Duration(hours: 1, minutes: 55)),
      ),
      ChatMessage(
        id: 'msg_1_3',
        chatRoomId: 'chat_room_1',
        userId: 'user_002',
        username: '박지구',
        userImageUrl: 'https://i.pravatar.cc/150?u=user002',
        message: '저도 참여합니다! 쓰레기봉투는 제가 준비할게요',
        timestamp: now.subtract(const Duration(hours: 1, minutes: 45)),
      ),
      ChatMessage(
        id: 'msg_1_4',
        chatRoomId: 'chat_room_1',
        userId: 'user_001',
        username: '김환경',
        userImageUrl: 'https://i.pravatar.cc/150?u=user001',
        message: '오전 10시 여의도 한강공원 입구에서 만나요!',
        timestamp: now.subtract(const Duration(hours: 1, minutes: 30)),
      ),
      ChatMessage(
        id: 'msg_1_5',
        chatRoomId: 'chat_room_1',
        userId: 'current_user',
        username: '나',
        userImageUrl: 'https://i.pravatar.cc/150?u=currentuser',
        message: '넵 알겠습니다! 장갑도 챙겨갈게요 😊',
        timestamp: now.subtract(const Duration(hours: 1, minutes: 20)),
      ),
      ChatMessage(
        id: 'msg_1_6',
        chatRoomId: 'chat_room_1',
        userId: 'user_003',
        username: '이클린',
        userImageUrl: 'https://i.pravatar.cc/150?u=user003',
        message: '날씨가 좋다고 하니 기대돼요!',
        timestamp: now.subtract(const Duration(minutes: 45)),
      ),
      ChatMessage(
        id: 'msg_1_7',
        chatRoomId: 'chat_room_1',
        userId: 'user_002',
        username: '박지구',
        userImageUrl: 'https://i.pravatar.cc/150?u=user002',
        message: '다들 편한 복장으로 오세요~ 운동화 추천!',
        timestamp: now.subtract(const Duration(minutes: 30)),
      ),
      ChatMessage(
        id: 'msg_1_8',
        chatRoomId: 'chat_room_1',
        userId: 'current_user',
        username: '나',
        userImageUrl: 'https://i.pravatar.cc/150?u=currentuser',
        message: '혹시 주차는 어디에 하면 좋을까요?',
        timestamp: now.subtract(const Duration(minutes: 15)),
      ),
      ChatMessage(
        id: 'msg_1_9',
        chatRoomId: 'chat_room_1',
        userId: 'user_001',
        username: '김환경',
        userImageUrl: 'https://i.pravatar.cc/150?u=user001',
        message: '한강공원 공영주차장 이용하시면 돼요. 2시간 무료입니다!',
        timestamp: now.subtract(const Duration(minutes: 10)),
      ),
    ];
  }

  /// 채팅방 2 메시지 (유기견 봉사활동)
  static List<ChatMessage> _getChatRoom2Messages() {
    final now = DateTime.now();
    return [
      ChatMessage(
        id: 'msg_2_1',
        chatRoomId: 'chat_room_2',
        userId: 'user_004',
        username: '최사랑',
        userImageUrl: 'https://i.pravatar.cc/150?u=user004',
        message: '안녕하세요! 강아지들 산책 봉사 참여하고 싶어요',
        timestamp: now.subtract(const Duration(days: 1, hours: 3)),
      ),
      ChatMessage(
        id: 'msg_2_2',
        chatRoomId: 'chat_room_2',
        userId: 'current_user',
        username: '나',
        userImageUrl: 'https://i.pravatar.cc/150?u=currentuser',
        message: '저도요! 처음인데 괜찮을까요?',
        timestamp: now.subtract(const Duration(days: 1, hours: 2, minutes: 50)),
      ),
      ChatMessage(
        id: 'msg_2_3',
        chatRoomId: 'chat_room_2',
        userId: 'user_005',
        username: '정댕댕',
        userImageUrl: 'https://i.pravatar.cc/150?u=user005',
        message: '처음이신 분들도 환영합니다! 간단한 교육 후 진행해요 🐶',
        timestamp: now.subtract(const Duration(days: 1, hours: 2, minutes: 30)),
      ),
      ChatMessage(
        id: 'msg_2_4',
        chatRoomId: 'chat_room_2',
        userId: 'user_006',
        username: '송멍멍',
        userImageUrl: 'https://i.pravatar.cc/150?u=user006',
        message: '저는 3번째 참여인데 정말 보람차요!',
        timestamp: now.subtract(const Duration(days: 1, hours: 2)),
      ),
      ChatMessage(
        id: 'msg_2_5',
        chatRoomId: 'chat_room_2',
        userId: 'current_user',
        username: '나',
        userImageUrl: 'https://i.pravatar.cc/150?u=currentuser',
        message: '준비물이 따로 필요한가요?',
        timestamp: now.subtract(const Duration(days: 1, hours: 1, minutes: 45)),
      ),
      ChatMessage(
        id: 'msg_2_6',
        chatRoomId: 'chat_room_2',
        userId: 'user_005',
        username: '정댕댕',
        userImageUrl: 'https://i.pravatar.cc/150?u=user005',
        message: '목줄이랑 간식은 센터에서 제공하고, 편한 옷만 입고 오시면 돼요!',
        timestamp: now.subtract(const Duration(hours: 5)),
      ),
      ChatMessage(
        id: 'msg_2_7',
        chatRoomId: 'chat_room_2',
        userId: 'user_004',
        username: '최사랑',
        userImageUrl: 'https://i.pravatar.cc/150?u=user004',
        message: '혹시 대형견도 있나요? 조금 무서워서요 ㅠㅠ',
        timestamp: now.subtract(const Duration(hours: 4, minutes: 30)),
      ),
      ChatMessage(
        id: 'msg_2_8',
        chatRoomId: 'chat_room_2',
        userId: 'user_005',
        username: '정댕댕',
        userImageUrl: 'https://i.pravatar.cc/150?u=user005',
        message: '대부분 소형견이고, 처음 오시는 분들은 온순한 아이들과 매칭해드려요 😊',
        timestamp: now.subtract(const Duration(hours: 4)),
      ),
      ChatMessage(
        id: 'msg_2_9',
        chatRoomId: 'chat_room_2',
        userId: 'user_006',
        username: '송멍멍',
        userImageUrl: 'https://i.pravatar.cc/150?u=user006',
        message: '다들 토요일 오후 2시에 수원 보호소 앞에서 만나요!',
        timestamp: now.subtract(const Duration(hours: 2)),
      ),
      ChatMessage(
        id: 'msg_2_10',
        chatRoomId: 'chat_room_2',
        userId: 'current_user',
        username: '나',
        userImageUrl: 'https://i.pravatar.cc/150?u=currentuser',
        message: '기대됩니다! 토요일에 뵐게요 👋',
        timestamp: now.subtract(const Duration(hours: 1)),
      ),
    ];
  }
}
