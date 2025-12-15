import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_color.dart';
import '../state/plogging_session_state.dart';

/// 플로깅 세션 정보 위젯
/// - state.elapsedDuration을 사용하여 1초마다 시간 업데이트 (단일 타이머)
class PloggingSessionInfo extends ConsumerStatefulWidget {
  final VoidCallback? onVerificationPressed;

  const PloggingSessionInfo({super.key, this.onVerificationPressed});

  @override
  ConsumerState<PloggingSessionInfo> createState() =>
      _PloggingSessionInfoState();
}

class _PloggingSessionInfoState extends ConsumerState<PloggingSessionInfo> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(ploggingSessionProvider);

    if (!sessionState.isSessionActive) {
      return const SizedBox.shrink();
    }

    // state에서 직접 경과 시간 가져오기 (단일 타이머에서 업데이트)
    final elapsed = sessionState.elapsedDuration;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.linear,
            padding: _isExpanded
                ? const EdgeInsets.fromLTRB(20, 24, 20, 20)
                : const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.8),
                  Colors.white.withValues(alpha: 0.5),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.6),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: _isExpanded
                ? _buildExpandedContent(elapsed, sessionState)
                : _buildCollapsedContent(elapsed, sessionState),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedContent(
    Duration elapsed,
    PloggingSessionState sessionState,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 접기 버튼
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () => setState(() => _isExpanded = false),
            child: Icon(
              Icons.keyboard_arrow_up_rounded,
              color: Colors.grey[400],
              size: 24,
            ),
          ),
        ),

        // 경과 시간 (00:00:00 형식)
        _buildTimer(elapsed),

        const SizedBox(height: 24),

        // 정보 행 (거리, 인증, 포인트)
        _buildStatsRow(sessionState),

        // 다음 인증까지 남은 시간
        if (sessionState.nextVerificationTime != null) ...[
          const SizedBox(height: 20),
          _NextVerificationIndicator(
            nextTime: sessionState.nextVerificationTime!,
            canVerify: sessionState.canVerify,
            onPressed: widget.onVerificationPressed,
          ),
        ],
      ],
    );
  }

  Widget _buildCollapsedContent(
    Duration elapsed,
    PloggingSessionState sessionState,
  ) {
    return GestureDetector(
      onTap: () => setState(() => _isExpanded = true),
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          // 시간
          Text(
            _formatDuration(elapsed),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D3142),
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(width: 16),
          // 거리
          Text(
            '${(sessionState.totalDistanceMeters / 1000).toStringAsFixed(2)}km',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 12),
          // 인증 횟수
          Text(
            '${sessionState.verifications.length}회',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const Spacer(),
          // 인증 가능 표시 또는 펼치기 버튼
          if (sessionState.canVerify)
            GestureDetector(
              onTap: widget.onVerificationPressed,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '인증',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.grey[400],
              size: 24,
            ),
        ],
      ),
    );
  }

  Widget _buildTimer(Duration elapsed) {
    return Column(
      children: [
        const Text(
          'PLOGGING TIME',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _formatDuration(elapsed),
          style: const TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.w800,
            color: Color(0xFF2D3142),
            height: 1.1,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(PloggingSessionState sessionState) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _InfoItem(
            label: '거리',
            value:
                '${(sessionState.totalDistanceMeters / 1000).toStringAsFixed(2)}',
            unit: 'km',
          ),
          _VerticalDivider(),
          _InfoItem(
            label: '인증',
            value: '${sessionState.verifications.length}',
            unit: '회',
          ),
          _VerticalDivider(),
          _InfoItem(
            label: '포인트',
            value: '${sessionState.verifications.length * 50}',
            unit: 'P',
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 24,
      color: Colors.black.withValues(alpha: 0.05),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _InfoItem({
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3142),
                height: 1.0,
              ),
            ),
            const SizedBox(width: 2),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                unit,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[500],
                  height: 1.0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _NextVerificationIndicator extends StatelessWidget {
  final DateTime nextTime;
  final bool canVerify;
  final VoidCallback? onPressed;

  const _NextVerificationIndicator({
    required this.nextTime,
    required this.canVerify,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (canVerify) {
      return GestureDetector(
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primary.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text(
                '지금 인증하고 포인트 받기',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final remaining = nextTime.difference(DateTime.now());
    final minutes = remaining.inMinutes;
    final seconds = remaining.inSeconds % 60;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.timer_outlined, color: Colors.grey[500], size: 18),
          const SizedBox(width: 8),
          Text(
            '다음 인증까지 ${minutes}:${seconds.toString().padLeft(2, '0')}',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
              fontSize: 14,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
