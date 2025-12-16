import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/utils/character_notification_helper.dart';
import '../state/plogging_session_state.dart';
import 'initial_photo_sheet.dart';

class PloggingFab extends ConsumerWidget {
  const PloggingFab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState = ref.watch(ploggingSessionProvider);
    final notifier = ref.read(ploggingSessionProvider.notifier);

    return FloatingActionButton.extended(
      heroTag: 'session_fab',
      onPressed: () => _handleSessionToggle(context, notifier, sessionState),
      backgroundColor:
          sessionState.isSessionActive ? Colors.red : AppColors.primary,
      icon: Icon(
        sessionState.isSessionActive ? Icons.stop : Icons.play_arrow,
      ),
      label: Text(
        sessionState.isSessionActive ? '종료' : '플로깅 시작',
      ),
    );
  }

  void _handleSessionToggle(
    BuildContext context,
    PloggingSessionNotifier notifier,
    PloggingSessionState state,
  ) {
    if (state.isSessionActive) {
      // 종료 확인 다이얼로그
      showDialog(
        context: context,
        builder: (dialogContext) {
          // 다이얼로그가 빌드된 후 캐릭터 알림 표시
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (dialogContext.mounted) {
              CharacterNotificationHelper.show(
                dialogContext,
                message: '벌써 끝내려고요..?',
                characterImage: 'assets/images/cloud_zeroro_sad.png',
                duration: const Duration(minutes: 5),
                alignment: const Alignment(0, -0.45),
              );
            }
          });

          return AlertDialog(
            title: const Text('플로깅 종료'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('경과 시간: ${state.elapsedMinutes}분'),
                Text('이동 거리: ${(state.totalDistanceMeters / 1000).toStringAsFixed(2)}km'),
                Text('인증 횟수: ${state.verifications.length}회'),
                const SizedBox(height: 8),
                const Text('플로깅을 종료하시겠습니까?'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  notifier.endSession();
                  // 플로깅 완료 알림
                  CharacterNotificationHelper.show(
                    context,
                    message: '수고했어요!\n오늘도 지구를 지켰어요~',
                    characterImage: 'assets/images/earth_zeroro_magic.png',
                    alignment: const Alignment(0.85, -0.4),
                  );
                },
                child: const Text('종료'),
              ),
            ],
          );
        },
      ).then((_) {
        CharacterNotificationHelper.hide();
      });
    } else {
      // 시작 - 초기 사진 촬영 시트 표시
      showInitialPhotoSheet(
        context,
        onPhotoSubmitted: () {
          // 플로깅 시작 알림 (타임 카드와 동시에 표시되도록 프레임 렌더링 후 표시)
          WidgetsBinding.instance.addPostFrameCallback((_) {
            CharacterNotificationHelper.show(
              context,
              message: '플로깅 시작! 화이팅~',
              characterImage: 'assets/images/earth_zeroro_smile.png',
              alignment: const Alignment(0.85, 0.15),
            );
          });
        },
      );
    }
  }
}
