abstract class AgentChatRepository {
  Future<String> sendMessage({
    required String userId,
    required String message,
  });
}
