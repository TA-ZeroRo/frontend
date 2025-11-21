import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../dto/report/monthly_report_dto.dart';

@injectable
class ReportApi {
  final Dio _dio;

  ReportApi(this._dio);

  /// Get monthly reports for a user
  /// GET /report/{user_id}
  Future<List<MonthlyReportDto>> getMonthlyReports(String userId) async {
    final response = await _dio.get('/report/$userId');

    // API 응답이 배열인 경우
    if (response.data is List) {
      final List<dynamic> data = response.data;
      return data.map((json) => MonthlyReportDto.fromJson(json)).toList();
    }

    // API 응답이 단일 객체인 경우
    return [MonthlyReportDto.fromJson(response.data)];
  }
}
