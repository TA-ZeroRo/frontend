import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_color.dart';
import '../state/plogging_session_state.dart';

class PloggingSessionInfo extends ConsumerStatefulWidget {
  const PloggingSessionInfo({super.key});

  @override
  ConsumerState<PloggingSessionInfo> createState() =>
      _PloggingSessionInfoState();
}

class _PloggingSessionInfoState extends ConsumerState<PloggingSessionInfo> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(ploggingSessionProvider);

    if (!sessionState.isSessionActive) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 경과 시간
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.timer, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                _formatDuration(sessionState.elapsedMinutes),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 정보 행
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _InfoItem(
                icon: Icons.route,
                label: '거리',
                value: '${(sessionState.totalDistanceMeters / 1000).toStringAsFixed(2)}km',
              ),
              _InfoItem(
                icon: Icons.verified,
                label: '인증',
                value: '${sessionState.verifications.length}회',
              ),
              _InfoItem(
                icon: Icons.stars,
                label: '포인트',
                value: '${sessionState.verifications.length * 50}P',
              ),
            ],
          ),

          // 다음 인증까지 남은 시간
          if (sessionState.nextVerificationTime != null) ...[
            const SizedBox(height: 12),
            _NextVerificationIndicator(
              nextTime: sessionState.nextVerificationTime!,
              canVerify: sessionState.canVerify,
            ),
          ],
        ],
      ),
    );
  }

  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours > 0) {
      return '${hours}h ${mins.toString().padLeft(2, '0')}m';
    }
    return '${mins}m';
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[600], size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class _NextVerificationIndicator extends StatelessWidget {
  final DateTime nextTime;
  final bool canVerify;

  const _NextVerificationIndicator({
    required this.nextTime,
    required this.canVerify,
  });

  @override
  Widget build(BuildContext context) {
    if (canVerify) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.camera_alt, color: AppColors.primary, size: 16),
            SizedBox(width: 4),
            Text(
              '지금 인증 가능!',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    final remaining = nextTime.difference(DateTime.now());
    final minutes = remaining.inMinutes;
    final seconds = remaining.inSeconds % 60;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, color: Colors.grey[600], size: 16),
          const SizedBox(width: 4),
          Text(
            '다음 인증까지 ${minutes}:${seconds.toString().padLeft(2, '0')}',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
