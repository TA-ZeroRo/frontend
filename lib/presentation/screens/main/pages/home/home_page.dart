import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_color.dart';
import 'package:frontend/presentation/screens/main/pages/home/state/chat_controller.dart';
import 'package:frontend/presentation/screens/main/pages/home/widgets/chat/chat_overlay.dart';
import 'package:frontend/presentation/screens/main/pages/home/widgets/chat/inline_chat_widget.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double logoHeight = 50;
    final viewState = ref.watch(chatViewStateProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Character image (dimmed when chat is active)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 400),
              opacity: viewState == ChatViewState.characterVisible ? 1.0 : 0.6,
              child: Image.asset(
                'assets/images/mock_zeroro.jpg',
                fit: BoxFit.contain,
                cacheWidth: 1080, // Limit cache size to reduce memory
                cacheHeight: 1920,
              ),
            ),

            // Logo at top (only visible when character is visible)
            if (viewState == ChatViewState.characterVisible)
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 16,
                child: Image.asset(
                  'assets/images/ZeroRo_logo.png',
                  height: logoHeight,
                  fit: BoxFit.contain,
                ),
              ),

            // Chat overlay
            const ChatOverlay(),

            // Inline chat widget (only visible when character is visible)
            if (viewState == ChatViewState.characterVisible)
              const InlineChatWidget(),
          ],
        ),
      ),
    );
  }
}
