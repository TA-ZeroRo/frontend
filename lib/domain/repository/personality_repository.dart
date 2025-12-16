import '../../data/dto/personality/personality_list_response.dart';
import '../../data/dto/personality/gacha_response.dart';

abstract class PersonalityRepository {
  /// 보유한 성격 목록 조회
  Future<PersonalityListResponse> getPersonalities(String userId);

  /// 성격 뽑기
  Future<GachaResponse> drawGacha(String userId);
}
