import 'package:injectable/injectable.dart';

import '../../core/logger/logger.dart';
import '../../core/utils/character_preferences.dart';
import '../../domain/repository/agent_chat_repository.dart';
import '../data_source/agent/agent_chat.api.dart';
import '../dto/agent/agent_chat_request.dart';

@Injectable(as: AgentChatRepository)
class AgentChatRepositoryImpl implements AgentChatRepository {
  final AgentChatApi _agentChatApi;

  AgentChatRepositoryImpl(this._agentChatApi);

  @override
  Future<String> sendMessage({
    required String userId,
    required String message,
  }) async {
    try {
      // Shared Preferences에서 선택된 캐릭터 가져오기
      final selectedCharacter = await CharacterPreferences.getSelectedCharacter();

      final request = AgentChatRequest(
        userId: userId,
        message: message,
        selectedCharacter: selectedCharacter,
      );
      final response = await _agentChatApi.sendMessage(request);
      return response.message;
    } catch (e) {
      CustomLogger.logger.e('sendMessage - 메시지 전송 실패', error: e);
      rethrow;
    }
  }
}
