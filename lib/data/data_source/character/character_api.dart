import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../dto/character/character_list_response.dart';
import '../../dto/character/character_unlock_response.dart';

@injectable
class CharacterApi {
  final Dio _dio;

  CharacterApi(this._dio);

  /// 캐릭터 목록 조회
  /// GET /api/v1/character/{user_id}
  Future<CharacterListResponse> getCharacters(String userId) async {
    final response = await _dio.get('/character/$userId');
    return CharacterListResponse.fromJson(response.data);
  }

  /// 캐릭터 해금
  /// POST /api/v1/character/unlock?user_id={user_id}&character_id={character_id}
  Future<CharacterUnlockResponse> unlockCharacter(
    String userId,
    String characterId,
  ) async {
    final response = await _dio.post(
      '/character/unlock',
      queryParameters: {
        'user_id': userId,
        'character_id': characterId,
      },
    );
    return CharacterUnlockResponse.fromJson(response.data);
  }
}
