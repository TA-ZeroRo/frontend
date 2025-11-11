import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../dto/agent/agent_chat_request.dart';
import '../../dto/agent/agent_chat_response.dart';

@injectable
class AgentChatApi {
  final Dio _dio;

  AgentChatApi(this._dio);

  /// Send a message to the agent
  /// POST /api/agent/chat
  Future<AgentChatResponse> sendMessage(AgentChatRequest request) async {
    final response = await _dio.post(
      '/agent/chat',
      data: request.toJson(),
    );
    return AgentChatResponse.fromJson(response.data);
  }
}
