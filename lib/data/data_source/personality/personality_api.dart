import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../dto/personality/personality_list_response.dart';
import '../../dto/personality/gacha_response.dart';

@injectable
class PersonalityApi {
  final Dio _dio;

  PersonalityApi(this._dio);

  /// 보유한 성격 목록 조회
  /// GET /api/v1/personality/{user_id}
  Future<PersonalityListResponse> getPersonalities(String userId) async {
    final response = await _dio.get('/personality/$userId');
    return PersonalityListResponse.fromJson(response.data);
  }

  /// 성격 뽑기
  /// POST /api/v1/personality/gacha?user_id={user_id}
  Future<GachaResponse> drawGacha(String userId) async {
    final response = await _dio.post(
      '/personality/gacha',
      queryParameters: {'user_id': userId},
    );
    return GachaResponse.fromJson(response.data);
  }
}
