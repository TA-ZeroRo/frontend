import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/di/injection.dart';
import '../../../../../../core/logger/logger.dart';
import '../../../../../../domain/model/point/point_trend.dart';
import '../../../../../../domain/repository/point_repository.dart';
import '../../../../entry/state/auth_controller.dart';

class ChartNotifier extends AsyncNotifier<List<PointTrendDataPoint>> {
  final PointRepository _pointRepository = getIt<PointRepository>();

  @override
  Future<List<PointTrendDataPoint>> build() async {
    // 현재 사용자 ID 가져오기
    final currentUser = ref.watch(authProvider).currentUser;
    if (currentUser == null) {
      CustomLogger.logger.w('ChartNotifier - 사용자 정보 없음');
      return [];
    }

    try {
      // 백엔드에서 포인트 추이 조회 (최근 7일)
      final pointTrend = await _pointRepository.getPointTrend(
        userId: currentUser.id,
        days: 7,
      );
      return pointTrend.data;
    } catch (e) {
      CustomLogger.logger.e('ChartNotifier - 포인트 추이 로드 실패', error: e);
      return [];
    }
  }

  /// 포인트 추이 새로고침
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }

  /// 조회 기간 변경 (일수)
  Future<void> updateDays(int days) async {
    final currentUser = ref.read(authProvider).currentUser;
    if (currentUser == null) {
      return;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final pointTrend = await _pointRepository.getPointTrend(
        userId: currentUser.id,
        days: days,
      );
      return pointTrend.data;
    });
  }
}

final chartProvider =
    AsyncNotifierProvider<ChartNotifier, List<PointTrendDataPoint>>(
  ChartNotifier.new,
);
