import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_color.dart';
import '../state/plogging_session_state.dart';

class PloggingFab extends ConsumerWidget {
  final VoidCallback? onVerificationPressed;

  const PloggingFab({
    super.key,
    this.onVerificationPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState = ref.watch(ploggingSessionProvider);
    final notifier = ref.read(ploggingSessionProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 인증 버튼 (세션 진행 중일 때만)
        if (sessionState.isSessionActive) ...[
          FloatingActionButton(
            heroTag: 'verify_fab',
            onPressed: sessionState.canVerify ? onVerificationPressed : null,
            backgroundColor: sessionState.canVerify
                ? AppColors.primary
                : Colors.grey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.camera_alt, size: 20),
                if (!sessionState.canVerify)
                  Text(
                    '${_getMinutesUntilVerification(sessionState)}분',
                    style: const TextStyle(fontSize: 10),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],

        // 시작/종료 버튼
        FloatingActionButton.extended(
          heroTag: 'session_fab',
          onPressed: () => _handleSessionToggle(context, notifier, sessionState),
          backgroundColor: sessionState.isSessionActive
              ? Colors.red
              : AppColors.primary,
          icon: Icon(
            sessionState.isSessionActive ? Icons.stop : Icons.play_arrow,
          ),
          label: Text(
            sessionState.isSessionActive ? '종료' : '플로깅 시작',
          ),
        ),
      ],
    );
  }

  int _getMinutesUntilVerification(PloggingSessionState state) {
    if (state.nextVerificationTime == null) return 0;
    final diff = state.nextVerificationTime!.difference(DateTime.now());
    return diff.inMinutes.clamp(0, 20);
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
        builder: (context) => AlertDialog(
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
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                notifier.endSession();
              },
              child: const Text('종료'),
            ),
          ],
        ),
      );
    } else {
      // 시작
      notifier.startSession();
    }
  }
}
