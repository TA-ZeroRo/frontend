import 'package:injectable/injectable.dart';
import '../../core/logger/logger.dart';
import '../../domain/repository/personality_repository.dart';
import '../data_source/personality/personality_api.dart';
import '../dto/personality/personality_list_response.dart';
import '../dto/personality/gacha_response.dart';

@Injectable(as: PersonalityRepository)
class PersonalityRepositoryImpl implements PersonalityRepository {
  final PersonalityApi _personalityApi;

  PersonalityRepositoryImpl(this._personalityApi);

  @override
  Future<PersonalityListResponse> getPersonalities(String userId) async {
    try {
      return await _personalityApi.getPersonalities(userId);
    } catch (e) {
      CustomLogger.logger.e('getPersonalities - 성격 목록 조회 실패', error: e);
      rethrow;
    }
  }

  @override
  Future<GachaResponse> drawGacha(String userId) async {
    try {
      return await _personalityApi.drawGacha(userId);
    } catch (e) {
      CustomLogger.logger.e('drawGacha - 성격 뽑기 실패', error: e);
      rethrow;
    }
  }
}
