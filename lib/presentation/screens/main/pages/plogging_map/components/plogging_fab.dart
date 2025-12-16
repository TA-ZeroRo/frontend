import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../../../../../../core/utils/character_notification_helper.dart';
import '../state/plogging_session_state.dart';
import 'initial_photo_sheet.dart';

/// 플로깅 시작/종료 버튼 상수
class _PloggingButtonConstants {
  static const double buttonWidth = 160;
  static const double buttonHeight = 56;
  static const double iconSize = 24;
  static const double borderRadius = 28;
}

class PloggingFab extends ConsumerWidget {
  const PloggingFab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState = ref.watch(ploggingSessionProvider);
    final notifier = ref.read(ploggingSessionProvider.notifier);
    final isActive = sessionState.isSessionActive;

    return _buildSessionButton(
      context: context,
      isActive: isActive,
      onPressed: () => _handleSessionToggle(context, notifier, sessionState),
    );
  }

  /// 세션 버튼 (시작/종료 동일 크기)
  Widget _buildSessionButton({
    required BuildContext context,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: _PloggingButtonConstants.buttonWidth,
      height: _PloggingButtonConstants.buttonHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_PloggingButtonConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: (isActive ? AppColors.error : AppColors.primary)
                .withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: isActive ? AppColors.error : AppColors.primary,
        borderRadius: BorderRadius.circular(_PloggingButtonConstants.borderRadius),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(_PloggingButtonConstants.borderRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isActive ? Icons.stop_rounded : Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: _PloggingButtonConstants.iconSize,
                ),
                const SizedBox(width: 8),
                Text(
                  isActive ? '플로깅 종료' : '플로깅 시작',
                  style: AppTextStyle.bodyLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSessionToggle(
    BuildContext context,
    PloggingSessionNotifier notifier,
    PloggingSessionState state,
  ) {
    if (state.isSessionActive) {
      _showEndSessionDialog(context, notifier, state);
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

  /// 종료 확인 다이얼로그 (개선된 UI)
  void _showEndSessionDialog(
    BuildContext context,
    PloggingSessionNotifier notifier,
    PloggingSessionState state,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        // 다이얼로그가 빌드된 후 캐릭터 알림 표시
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (dialogContext.mounted) {
            CharacterNotificationHelper.show(
              dialogContext,
              message: '벌써 끝내려고요..?',
              characterImage: 'assets/images/cloud_zeroro_sad.png',
              duration: const Duration(minutes: 5),
              alignment: const Alignment(0, -0.5),
            );
          }
        });

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 아이콘
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.flag_rounded,
                    color: AppColors.error,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),
                // 제목
                Text(
                  '플로깅을 종료할까요?',
                  style: AppTextStyle.titleLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                // 활동 요약 박스
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildStatRow(
                        Icons.timer_outlined,
                        '경과 시간',
                        '${state.elapsedMinutes}분',
                      ),
                      const SizedBox(height: 12),
                      _buildStatRow(
                        Icons.straighten_rounded,
                        '이동 거리',
                        '${(state.totalDistanceMeters / 1000).toStringAsFixed(2)}km',
                      ),
                      const SizedBox(height: 12),
                      _buildStatRow(
                        Icons.camera_alt_outlined,
                        '인증 횟수',
                        '${state.verifications.length}회',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // 버튼 영역
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppColors.textSubtle.withValues(alpha: 0.5),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            '계속하기',
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            notifier.endSession();
                            // 플로깅 완료 알림
                            CharacterNotificationHelper.show(
                              context,
                              message: '수고했어요!\n오늘도 지구를 지켰어요~',
                              characterImage: 'assets/images/earth_zeroro_magic.png',
                              alignment: const Alignment(0.85, -0.4),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            '종료하기',
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      CharacterNotificationHelper.hide();
    });
  }

  /// 통계 행 위젯
  Widget _buildStatRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 10),
        Text(
          label,
          style: AppTextStyle.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: AppTextStyle.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
