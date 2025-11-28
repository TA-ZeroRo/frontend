import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

import '../../domain/model/recruiting/chat_message.dart';
import '../../domain/repository/recruiting_repository.dart';
import '../../presentation/screens/main/pages/campaign/models/recruiting_post.dart';
import '../data_source/recruiting/recruiting_api.dart';
import '../data_source/recruiting/recruiting_chat_realtime_service.dart';

@Injectable(as: RecruitingRepository)
class RecruitingRepositoryImpl implements RecruitingRepository {
  final RecruitingApi _recruitingApi;
  final RecruitingChatRealtimeService _realtimeService;

  RecruitingRepositoryImpl(this._recruitingApi, this._realtimeService);

  @override
  Future<List<RecruitingPost>> getRecruitingPosts({
    required int offset,
    int? campaignId,
    String? region,
    String? participationStatus,
    String? userId,
  }) async {
    final dtos = await _recruitingApi.getRecruitingPosts(
      offset: offset,
      campaignId: campaignId,
      region: region,
      participationStatus: participationStatus,
      userId: userId,
    );

    return dtos.map((dto) => dto.toModel()).toList();
  }

  @override
  Future<RecruitingPost> getRecruitingPost({
    required int postId,
    String? userId,
  }) async {
    final dto = await _recruitingApi.getRecruitingPost(
      postId: postId,
      userId: userId,
    );

    return dto.toModel();
  }

  @override
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
  }) async {
    final dateFormat = DateFormat('yyyy-MM-dd');

    final dto = await _recruitingApi.createRecruitingPost(
      userId: userId,
      campaignId: campaignId,
      title: title,
      region: region,
      city: city,
      capacity: capacity,
      startDate: dateFormat.format(startDate),
      endDate: endDate != null ? dateFormat.format(endDate) : null,
      minAge: minAge,
      maxAge: maxAge,
    );

    return dto.toModel();
  }

  @override
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
  }) async {
    final dateFormat = DateFormat('yyyy-MM-dd');

    final dto = await _recruitingApi.updateRecruitingPost(
      postId: postId,
      userId: userId,
      title: title,
      region: region,
      city: city,
      capacity: capacity,
      startDate: startDate != null ? dateFormat.format(startDate) : null,
      endDate: endDate != null ? dateFormat.format(endDate) : null,
      minAge: minAge,
      maxAge: maxAge,
      isRecruiting: isRecruiting,
    );

    return dto.toModel();
  }

  @override
  Future<void> deleteRecruitingPost({
    required int postId,
    required String userId,
  }) async {
    await _recruitingApi.deleteRecruitingPost(
      postId: postId,
      userId: userId,
    );
  }

  @override
  Future<RecruitingPost> joinRecruiting({
    required int postId,
    required String userId,
  }) async {
    final dto = await _recruitingApi.joinRecruiting(
      postId: postId,
      userId: userId,
    );

    return dto.toModel();
  }

  @override
  Future<List<ChatMessage>> getChatMessages({
    required int roomId,
    required String userId,
    int offset = 0,
    int limit = 50,
  }) async {
    final dtos = await _recruitingApi.getChatMessages(
      roomId: roomId,
      userId: userId,
      offset: offset,
      limit: limit,
    );

    return dtos.map((dto) => dto.toModel()).toList();
  }

  @override
  Future<ChatMessage> sendChatMessage({
    required int roomId,
    required String userId,
    required String message,
  }) async {
    final dto = await _recruitingApi.sendChatMessage(
      roomId: roomId,
      userId: userId,
      message: message,
    );

    return dto.toModel();
  }

  @override
  Future<List<ChatRoomParticipant>> getChatRoomParticipants({
    required int roomId,
    required String userId,
  }) async {
    final dtos = await _recruitingApi.getChatRoomParticipants(
      roomId: roomId,
      userId: userId,
    );

    return dtos
        .map((dto) => ChatRoomParticipant(
              id: dto.id.toString(),
              chatRoomId: dto.chatRoomId.toString(),
              userId: dto.userId,
              username: dto.username,
              userImageUrl: dto.userImageUrl,
              joinedAt: dto.joinedAtDateTime,
            ))
        .toList();
  }

  @override
  Stream<ChatMessage> subscribeToChatRoom(int roomId) {
    _realtimeService.subscribeToRoom(roomId);
    return _realtimeService.messageStream.map((dto) => dto.toModel());
  }

  @override
  void unsubscribeFromChatRoom() {
    _realtimeService.unsubscribe();
  }

  @override
  Future<void> kickParticipant({
    required int postId,
    required String hostUserId,
    required String targetUserId,
  }) async {
    await _recruitingApi.kickParticipant(
      postId: postId,
      hostUserId: hostUserId,
      targetUserId: targetUserId,
    );
  }
}
