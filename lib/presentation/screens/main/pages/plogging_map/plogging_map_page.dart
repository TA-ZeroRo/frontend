import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/components/custom_app_bar.dart';

import '../../../../../core/theme/app_color.dart';
import 'components/leaderboard_section.dart';
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
      if (next.errorMessage != null && next.errorMessage != prev?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
        ref.read(ploggingSessionProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: '플로깅 맵',
        additionalActions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: EdgeInsets.symmetric(horizontal: 16),
                  child: LeaderboardSection(),
                ),
              );
            },
            icon: const Icon(Icons.emoji_events_outlined),
          ),
        ],
      ),
      body: Stack(
        children: [
          // 지도
          const PloggingMapView(),

          // 세션 정보 (상단)
          if (sessionState.isSessionActive)
            const Positioned(
              top: 16,
              left: 0,
              right: 0,
              child: PloggingSessionInfo(),
            ),
        ],
      ),
      floatingActionButton: PloggingFab(
        onVerificationPressed: () {
          showPhotoVerificationSheet(context);
        },
      ),
    );
  }
}
