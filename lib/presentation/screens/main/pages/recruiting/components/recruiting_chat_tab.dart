import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../../../../../../core/di/injection.dart';
import '../../../../../../domain/repository/recruiting_repository.dart';
import '../../campaign/models/recruiting_post.dart';
import '../../../../../../domain/model/recruiting/chat_message.dart';
import 'recruiting_message_bubble.dart';
import 'recruiting_chat_input.dart';

class RecruitingChatTab extends ConsumerStatefulWidget {
  final RecruitingPost post;

  const RecruitingChatTab({super.key, required this.post});

  @override
  ConsumerState<RecruitingChatTab> createState() => _RecruitingChatTabState();
}

class _RecruitingChatTabState extends ConsumerState<RecruitingChatTab> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  final RecruitingRepository _repository = getIt<RecruitingRepository>();
  List<ChatMessage> _messages = [];
  bool _isLoading = true;
  String? _error;

  String? get _currentUserId =>
      Supabase.instance.client.auth.currentSession?.user.id;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final chatRoomId = widget.post.chatRoomId;
    final userId = _currentUserId;

    if (chatRoomId == null || userId == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final messages = await _repository.getChatMessages(
        roomId: int.parse(chatRoomId),
        userId: userId,
      );
      setState(() {
        _messages = messages;
        _isLoading = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    final chatRoomId = widget.post.chatRoomId;
    final userId = _currentUserId;
    if (chatRoomId == null || userId == null) return;

    _messageController.clear();

    try {
      // API로 메시지 전송
      final newMessage = await _repository.sendChatMessage(
        roomId: int.parse(chatRoomId),
        userId: userId,
        message: message,
      );

      setState(() {
        _messages = [..._messages, newMessage];
      });

      // 메시지 전송 후 스크롤
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    } catch (e) {
      // 에러 시 사용자에게 알림
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('메시지 전송 실패: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatRoomId = widget.post.chatRoomId;

    // 참여하지 않은 경우
    if (!widget.post.isParticipating || chatRoomId == null) {
      return _buildNotParticipatingView();
    }

    // 로딩 중
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 에러 발생
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.textTertiary),
            const SizedBox(height: 16),
            Text('메시지를 불러올 수 없습니다', style: AppTextStyle.bodyLarge),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _loadMessages,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    final messages = _messages;

    return Column(
      children: [
        // 채팅 메시지 목록
        Expanded(
          child: messages.isEmpty
              ? _buildEmptyView()
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.userId == _currentUserId;

                    // 날짜 구분선 표시 여부 확인
                    bool showDateSeparator = false;
                    if (index == 0) {
                      showDateSeparator = true;
                    } else {
                      final prevMessage = messages[index - 1];
                      showDateSeparator = !_isSameDay(
                        prevMessage.timestamp,
                        message.timestamp,
                      );
                    }

                    return Column(
                      children: [
                        if (showDateSeparator)
                          _buildDateSeparator(message.timestamp),
                        RecruitingMessageBubble(
                          message: message,
                          isMe: isMe,
                        ),
                      ],
                    );
                  },
                ),
        ),
        // 메시지 입력창
        RecruitingChatInput(
          controller: _messageController,
          onSend: _sendMessage,
        ),
      ],
    );
  }

  /// 참여하지 않은 경우 뷰
  Widget _buildNotParticipatingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline,
            size: 80,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            '채팅은 참여자만 이용할 수 있어요',
            style: AppTextStyle.bodyLarge.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '정보 탭에서 참여하기 버튼을 눌러주세요',
            style: AppTextStyle.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// 빈 채팅방 뷰
  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            '아직 메시지가 없어요',
            style: AppTextStyle.bodyLarge.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '첫 메시지를 보내보세요!',
            style: AppTextStyle.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// 날짜 구분선
  Widget _buildDateSeparator(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(date.year, date.month, date.day);

    String dateText;
    if (messageDate == today) {
      dateText = '오늘';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      dateText = '어제';
    } else {
      dateText = '${date.month}월 ${date.day}일';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(color: AppColors.textTertiary)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              dateText,
              style: AppTextStyle.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(child: Divider(color: AppColors.textTertiary)),
        ],
      ),
    );
  }

  /// 같은 날짜인지 확인
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
