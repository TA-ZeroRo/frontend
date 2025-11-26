import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../core/logger/logger.dart';
import '../../domain/model/report/monthly_report.dart';
import '../../domain/repository/report_repository.dart';
import '../data_source/report/report_api.dart';

@Injectable(as: ReportRepository)
class ReportRepositoryImpl implements ReportRepository {
  final ReportApi _reportApi;

  ReportRepositoryImpl(this._reportApi);

  @override
  Future<List<MonthlyReport>> getMonthlyReports(String userId) async {
    try {
      final result = await _reportApi.getMonthlyReports(userId);
      return result.map((dto) => dto.toModel()).toList();
    } on DioException catch (e) {
      // 404 또는 500 에러인 경우 (보고서가 없는 경우) 빈 배열 반환
      if (e.response?.statusCode == 404 || e.response?.statusCode == 500) {
        CustomLogger.logger.w(
          'getMonthlyReports - 보고서가 없습니다 (userId: $userId)',
        );
        return [];
      }

      CustomLogger.logger.e(
        'getMonthlyReports - 월간 보고서 조회 실패 (userId: $userId)',
        error: e,
      );
      rethrow;
    } catch (e) {
      CustomLogger.logger.e(
        'getMonthlyReports - 예상치 못한 오류 (userId: $userId)',
        error: e,
      );
      rethrow;
    }
  }
}
