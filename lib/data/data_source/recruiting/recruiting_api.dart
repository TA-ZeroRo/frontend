import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../dto/recruiting/recruiting_post_dto.dart';
import '../../dto/recruiting/chat_message_dto.dart';
import '../../dto/recruiting/chat_room_participant_dto.dart';

@injectable
class RecruitingApi {
  final Dio _dio;

  RecruitingApi(this._dio);

  /// 리크루팅 게시글 목록 조회
  /// GET /recruiting/posts
  Future<List<RecruitingPostDto>> getRecruitingPosts({
    required int offset,
    int? campaignId,
    String? region,
    String? participationStatus,
    String? userId,
  }) async {
    final queryParameters = <String, dynamic>{
      'offset': offset,
    };

    if (campaignId != null) {
      queryParameters['campaign_id'] = campaignId;
    }
    if (region != null) {
      queryParameters['region'] = region;
    }
    if (participationStatus != null) {
      queryParameters['participation_status'] = participationStatus;
    }
    if (userId != null) {
      queryParameters['user_id'] = userId;
    }

    final response = await _dio.get(
      '/recruiting/posts',
      queryParameters: queryParameters,
    );

    final List<dynamic> data = response.data;
    return data.map((json) => RecruitingPostDto.fromJson(json)).toList();
  }

  /// 리크루팅 게시글 상세 조회
  /// GET /recruiting/posts/{postId}
  Future<RecruitingPostDto> getRecruitingPost({
    required int postId,
    String? userId,
  }) async {
    final queryParameters = <String, dynamic>{};
    if (userId != null) {
      queryParameters['user_id'] = userId;
    }

    final response = await _dio.get(
      '/recruiting/posts/$postId',
      queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
    );

    return RecruitingPostDto.fromJson(response.data);
  }

  /// 리크루팅 게시글 생성
  /// POST /recruiting/posts
  Future<RecruitingPostDto> createRecruitingPost({
    required String userId,
    required int campaignId,
    required String title,
    required String region,
    required String city,
    required int capacity,
    required String startDate,
    String? endDate,
    int minAge = 0,
    int maxAge = 0,
  }) async {
    final data = {
      'user_id': userId,
      'campaign_id': campaignId,
      'title': title,
      'region': region,
      'city': city,
      'capacity': capacity,
      'start_date': startDate,
      'min_age': minAge,
      'max_age': maxAge,
    };

    if (endDate != null) {
      data['end_date'] = endDate;
    }

    final response = await _dio.post(
      '/recruiting/posts',
      data: data,
    );

    return RecruitingPostDto.fromJson(response.data);
  }

  /// 리크루팅 게시글 수정
  /// PUT /recruiting/posts/{postId}
  Future<RecruitingPostDto> updateRecruitingPost({
    required int postId,
    required String userId,
    String? title,
    String? region,
    String? city,
    int? capacity,
    String? startDate,
    String? endDate,
    int? minAge,
    int? maxAge,
    bool? isRecruiting,
  }) async {
    final data = <String, dynamic>{
      'user_id': userId,
    };

    if (title != null) data['title'] = title;
    if (region != null) data['region'] = region;
    if (city != null) data['city'] = city;
    if (capacity != null) data['capacity'] = capacity;
    if (startDate != null) data['start_date'] = startDate;
    if (endDate != null) data['end_date'] = endDate;
    if (minAge != null) data['min_age'] = minAge;
    if (maxAge != null) data['max_age'] = maxAge;
    if (isRecruiting != null) data['is_recruiting'] = isRecruiting;

    final response = await _dio.put(
      '/recruiting/posts/$postId',
      data: data,
    );

    return RecruitingPostDto.fromJson(response.data);
  }

  /// 리크루팅 게시글 삭제
  /// DELETE /recruiting/posts/{postId}
  Future<void> deleteRecruitingPost({
    required int postId,
    required String userId,
  }) async {
    await _dio.delete(
      '/recruiting/posts/$postId',
      data: {'user_id': userId},
    );
  }

  /// 리크루팅 참여하기
  /// POST /recruiting/posts/{postId}/join
  Future<RecruitingPostDto> joinRecruiting({
    required int postId,
    required String userId,
  }) async {
    final response = await _dio.post(
      '/recruiting/posts/$postId/join',
      data: {'user_id': userId},
    );

    return RecruitingPostDto.fromJson(response.data);
  }

  /// 채팅 메시지 목록 조회
  /// GET /recruiting/rooms/{roomId}/messages
  Future<List<ChatMessageDto>> getChatMessages({
    required int roomId,
    required String userId,
    int offset = 0,
    int limit = 50,
  }) async {
    final response = await _dio.get(
      '/recruiting/rooms/$roomId/messages',
      queryParameters: {
        'user_id': userId,
        'offset': offset,
        'limit': limit,
      },
    );

    final List<dynamic> data = response.data;
    return data.map((json) => ChatMessageDto.fromJson(json)).toList();
  }

  /// 채팅 메시지 전송
  /// POST /recruiting/rooms/{roomId}/messages
  Future<ChatMessageDto> sendChatMessage({
    required int roomId,
    required String userId,
    required String message,
  }) async {
    final response = await _dio.post(
      '/recruiting/rooms/$roomId/messages',
      data: {
        'user_id': userId,
        'message': message,
      },
    );

    return ChatMessageDto.fromJson(response.data);
  }

  /// 채팅방 참여자 목록 조회
  /// GET /recruiting/rooms/{roomId}/participants
  Future<List<ChatRoomParticipantDto>> getChatRoomParticipants({
    required int roomId,
    required String userId,
  }) async {
    final response = await _dio.get(
      '/recruiting/rooms/$roomId/participants',
      queryParameters: {'user_id': userId},
    );

    final List<dynamic> data = response.data;
    return data.map((json) => ChatRoomParticipantDto.fromJson(json)).toList();
  }
}
