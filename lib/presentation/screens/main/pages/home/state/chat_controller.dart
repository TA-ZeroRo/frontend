import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/domain/model/chat_message/chat_message.dart';
import 'package:frontend/domain/model/conversation/conversation.dart';
import 'package:frontend/domain/model/chat_summary/chat_summary.dart';
import 'package:frontend/presentation/screens/main/pages/home/state/Mock/mock_chat_data.dart';

// Chat view states
enum ChatViewState {
  characterVisible, // Default: Character only
  chatActive, // Overlay shown, chat in focus
  historyOpen, // Sidebar visible
}

// Chat view state notifier
class ChatViewStateNotifier extends Notifier<ChatViewState> {
  @override
  ChatViewState build() {
    return ChatViewState.characterVisible;
  }

  void setState(ChatViewState newState) {
    state = newState;
  }
}

// Chat view state provider
final chatViewStateProvider = NotifierProvider<ChatViewStateNotifier, ChatViewState>(
  ChatViewStateNotifier.new,
);

// Active conversation notifier
class ConversationNotifier extends Notifier<Conversation?> {
  @override
  Conversation? build() {
    return null; // Start with no active conversation
  }

  // Start a new conversation
  void startNewConversation() {
    final newConv = Conversation(
      id: 'conv_${DateTime.now().millisecondsSinceEpoch}',
      title: '새로운 대화',
      messages: [
        ChatMessage(
          id: 'msg_welcome',
          text: '안녕하세요! 저는 제로로예요 🌱\n환경에 대해 무엇이든 물어보세요!',
          sender: 'ai',
          timestamp: DateTime.now(),
          isUser: false,
        ),
      ],
      lastUpdated: DateTime.now(),
    );
    state = newConv;
  }

  // Load existing conversation
  void loadConversation(String conversationId) {
    final conv = MockChatData.getConversationById(conversationId);
    if (conv != null) {
      state = conv;
    }
  }

  // Send a message
  Future<void> sendMessage(String text) async {
    if (state == null || text.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      text: text.trim(),
      sender: 'user',
      timestamp: DateTime.now(),
      isUser: true,
    );

    state = state!.copyWith(
      messages: [...state!.messages, userMessage],
      lastUpdated: DateTime.now(),
    );

    // Simulate AI typing delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Add AI response
    final aiMessage = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      text: MockChatData.getRandomResponse(),
      sender: 'ai',
      timestamp: DateTime.now(),
      isUser: false,
    );

    state = state!.copyWith(
      messages: [...state!.messages, aiMessage],
      lastUpdated: DateTime.now(),
    );
  }

  // Clear conversation
  void clearConversation() {
    state = null;
  }
}

// Active conversation provider
final conversationProvider = NotifierProvider<ConversationNotifier, Conversation?>(
  ConversationNotifier.new,
);

// Chat history notifier
class ChatHistoryNotifier extends Notifier<List<ChatSummary>> {
  @override
  List<ChatSummary> build() {
    return MockChatData.mockChatSummaries;
  }

  // Delete a chat from history
  void deleteChat(String chatId) {
    state = state.where((chat) => chat.id != chatId).toList();
  }

  // Add new chat to history (when user sends first message in new conv)
  void addChatToHistory(Conversation conversation) {
    final lastMessage = conversation.messages.isNotEmpty
        ? conversation.messages.last.text
        : '';

    final newSummary = ChatSummary(
      id: conversation.id,
      title: conversation.title,
      preview: lastMessage.length > 50
          ? '${lastMessage.substring(0, 50)}...'
          : lastMessage,
      lastMessageTime: conversation.lastUpdated,
    );

    // Remove existing if present, then add to top
    state = [
      newSummary,
      ...state.where((chat) => chat.id != conversation.id),
    ];
  }
}

// Chat history provider
final chatHistoryProvider = NotifierProvider<ChatHistoryNotifier, List<ChatSummary>>(
  ChatHistoryNotifier.new,
);

// Typing indicator notifier
class AITypingNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void setTyping(bool isTyping) {
    state = isTyping;
  }
}

// Typing indicator provider
final isAITypingProvider = NotifierProvider<AITypingNotifier, bool>(
  AITypingNotifier.new,
);
