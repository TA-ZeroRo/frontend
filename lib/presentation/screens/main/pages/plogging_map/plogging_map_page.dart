import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/components/custom_app_bar.dart';

import '../../../../../core/theme/app_color.dart';
import '../../../../../core/utils/character_notification_helper.dart';
import 'components/photo_verification_sheet.dart';
import 'components/plogging_fab.dart';
import 'components/plogging_map_view.dart';
import 'components/plogging_session_info.dart';
import 'state/plogging_session_state.dart';

class PloggingMapPage extends ConsumerWidget {
  const PloggingMapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState = ref.watch(ploggingSessionProvider);

    // 에러 메시지 표시
    ref.listen<PloggingSessionState>(ploggingSessionProvider, (prev, next) {
      if (next.errorMessage != null &&
          next.errorMessage != prev?.errorMessage) {
        // GPS 관련 에러인 경우 캐릭터 알림 사용
        if (next.errorMessage!.contains('위치') ||
            next.errorMessage!.contains('GPS') ||
            next.errorMessage!.contains('location')) {
          CharacterNotificationHelper.show(
            context,
            message: '앗, GPS가 안잡혀요ㅠ',
            characterImage: 'assets/images/cloud_zeroro_sad.png',
            alignment: const Alignment(0.85, -0.4),
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
        }
        ref.read(ploggingSessionProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(
        title: '플로깅 맵',
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          // 지도
          const PloggingMapView(),

          // 세션 정보 (상단)
          if (sessionState.isSessionActive)
            Positioned(
              top: 120,
              left: 0,
              right: 0,
              child: PloggingSessionInfo(
                onVerificationPressed: () {
                  showPhotoVerificationSheet(context);
                },
              ),
            ),
        ],
      ),
      floatingActionButton: const PloggingFab(),
    );
  }
}
