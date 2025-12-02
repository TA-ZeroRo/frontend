import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../dto/recruiting/chat_message_dto.dart';

/// Supabase Realtime을 통한 채팅 메시지 실시간 수신 서비스
@injectable
class RecruitingChatRealtimeService {
  final SupabaseClient _supabase = Supabase.instance.client;

  RealtimeChannel? _channel;
  final StreamController<ChatMessageDto> _messageStreamController =
      StreamController<ChatMessageDto>.broadcast();

  /// 메시지 스트림
  Stream<ChatMessageDto> get messageStream => _messageStreamController.stream;

  /// 특정 채팅방 구독
  void subscribeToRoom(int chatRoomId) {
    // 기존 구독 해제
    unsubscribe();

    _channel = _supabase
        .channel('recruiting_chat_room_$chatRoomId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'recruiting_chat_messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'chat_room_id',
            value: chatRoomId,
          ),
          callback: (payload) {
            _handleNewMessage(payload.newRecord);
          },
        )
        .subscribe();
  }

  /// 새 메시지 처리
  Future<void> _handleNewMessage(Map<String, dynamic> record) async {
    try {
      final messageId = record['id'];
      if (messageId == null) return;

      // 프로필 정보를 포함하여 메시지 조회
      final response = await _supabase
          .from('recruiting_chat_messages')
          .select('*, profiles(user_img, username)')
          .eq('id', messageId)
          .single();

      final messageDto = ChatMessageDto.fromJson(response);
      _messageStreamController.add(messageDto);
    } catch (e) {
      // 에러 발생 시 로그만 출력하고 계속 진행
      // ignore: avoid_print
      print('Realtime message fetch error: $e');
    }
  }

  /// 구독 해제
  void unsubscribe() {
    _channel?.unsubscribe();
    _channel = null;
  }

  /// 리소스 정리
  void dispose() {
    unsubscribe();
    _messageStreamController.close();
  }
}
