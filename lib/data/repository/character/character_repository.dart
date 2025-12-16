import '../../dto/character/character_list_response.dart';
import '../../dto/character/character_unlock_response.dart';

/// 캐릭터 리포지토리 인터페이스
abstract class CharacterRepository {
  /// 캐릭터 목록 조회
  Future<CharacterListResponse> getCharacters(String userId);

  /// 캐릭터 해금
  Future<CharacterUnlockResponse> unlockCharacter(
    String userId,
    String characterId,
  );
}
