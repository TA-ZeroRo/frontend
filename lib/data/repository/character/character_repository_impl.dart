import 'package:injectable/injectable.dart';
import '../../data_source/character/character_api.dart';
import '../../dto/character/character_list_response.dart';
import '../../dto/character/character_unlock_response.dart';
import 'character_repository.dart';

@Injectable(as: CharacterRepository)
class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterApi _characterApi;

  CharacterRepositoryImpl(this._characterApi);

  @override
  Future<CharacterListResponse> getCharacters(String userId) async {
    return await _characterApi.getCharacters(userId);
  }

  @override
  Future<CharacterUnlockResponse> unlockCharacter(
    String userId,
    String characterId,
  ) async {
    return await _characterApi.unlockCharacter(userId, characterId);
  }
}
