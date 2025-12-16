import '../../presentation/screens/main/pages/campaign/models/recruiting_post.dart';
import '../model/recruiting/chat_message.dart';

abstract class RecruitingRepository {
  /// 리크루팅 게시글 목록 조회
  Future<List<RecruitingPost>> getRecruitingPosts({
    required int offset,
    int? campaignId,
    String? region,
    String? participationStatus,
    String? userId,
  });

  /// 리크루팅 게시글 상세 조회
  Future<RecruitingPost> getRecruitingPost({
    required int postId,
    String? userId,
  });

  /// 리크루팅 게시글 생성
  Future<RecruitingPost> createRecruitingPost({
    required String userId,
    required int campaignId,
    required String title,
    required String region,
    required String city,
    required int capacity,
    required DateTime startDate,
    DateTime? endDate,
    int minAge = 0,
    int maxAge = 0,
  });

  /// 리크루팅 게시글 수정
  Future<RecruitingPost> updateRecruitingPost({
    required int postId,
    required String userId,
    String? title,
    String? region,
    String? city,
    int? capacity,
    DateTime? startDate,
    DateTime? endDate,
    int? minAge,
    int? maxAge,
    bool? isRecruiting,
  });

  /// 리크루팅 게시글 삭제
  Future<void> deleteRecruitingPost({
    required int postId,
    required String userId,
  });

  /// 리크루팅 참여하기
  Future<RecruitingPost> joinRecruiting({
    required int postId,
    required String userId,
  });

  /// 채팅 메시지 목록 조회
  Future<List<ChatMessage>> getChatMessages({
    required int roomId,
    required String userId,
    int offset = 0,
    int limit = 50,
  });

  /// 채팅 메시지 전송
  Future<ChatMessage> sendChatMessage({
    required int roomId,
    required String userId,
    required String message,
  });

  /// 채팅방 참여자 목록 조회
  Future<List<ChatRoomParticipant>> getChatRoomParticipants({
    required int roomId,
    required String userId,
  });

  /// 채팅방 실시간 메시지 구독
  Stream<ChatMessage> subscribeToChatRoom(int roomId);

  /// 채팅방 실시간 메시지 구독 해제
  void unsubscribeFromChatRoom();

  /// 참여자 강퇴 (주최자 전용)
  Future<void> kickParticipant({
    required int postId,
    required String hostUserId,
    required String targetUserId,
  });

  /// 리크루팅 나가기
  Future<void> leaveRecruiting({
    required int postId,
    required String userId,
  });
}

/// 채팅방 참여자 모델
class ChatRoomParticipant {
  final String id;
  final String chatRoomId;
  final String userId;
  final String username;
  final String? userImageUrl;
  final DateTime joinedAt;

  const ChatRoomParticipant({
    required this.id,
    required this.chatRoomId,
    required this.userId,
    required this.username,
    this.userImageUrl,
    required this.joinedAt,
  });
}
