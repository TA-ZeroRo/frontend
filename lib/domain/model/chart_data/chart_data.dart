import 'package:freezed_annotation/freezed_annotation.dart';

part 'chart_data.freezed.dart';
part 'chart_data.g.dart';

@freezed
abstract class ChartData with _$ChartData {
  const factory ChartData({
    required DateTime date,
    required int score,
  }) = _ChartData;

  factory ChartData.fromJson(Map<String, dynamic> json) =>
      _$ChartDataFromJson(json);
}
