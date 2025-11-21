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
    } catch (e) {
      CustomLogger.logger.e(
        'getMonthlyReports - 월간 보고서 조회 실패 (userId: $userId)',
        error: e,
      );
      rethrow;
    }
  }
}
