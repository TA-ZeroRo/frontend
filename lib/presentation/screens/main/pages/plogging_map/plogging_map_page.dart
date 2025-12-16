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

  /// 주간 플로깅 현황을 캐릭터 알림으로 표시 (배경 어둡게 + 터치시 닫힘)
  void _showWeeklyStatsNotification(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '닫기',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final slideAnimation = Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        ));

        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ));

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.of(context).pop(),
          child: Align(
            alignment: const Alignment(0.85, -0.3),
            child: SlideTransition(
              position: slideAnimation,
              child: FadeTransition(
                opacity: fadeAnimation,
                child: Material(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 말풍선
                      Container(
                        constraints: const BoxConstraints(maxWidth: 240),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Text(
                          '서울특별시는 지난주\n128명의 유저가\n256시간 활동했어요!',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // 캐릭터 아바타
                      Container(
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Transform.scale(
                            scale: 1.3,
                            child: Image.asset(
                              'assets/images/earth_zeroro_sunglasses.png',
                              fit: BoxFit.cover,
                              width: 65,
                              height: 65,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

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
      appBar: CustomAppBar(
        title: '플로깅 맵',
        backgroundColor: Colors.transparent,
        additionalActions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showWeeklyStatsNotification(context),
          ),
        ],
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
