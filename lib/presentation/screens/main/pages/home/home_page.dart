import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_color.dart';
import 'package:frontend/presentation/screens/main/pages/home/state/chat_controller.dart';
import 'package:frontend/presentation/screens/main/pages/home/widgets/chat/chat_overlay.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double appBarHeight = 50;
    final viewState = ref.watch(chatViewStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: viewState == ChatViewState.characterVisible
          ? AppBar(
              title: Image.asset(
                'assets/images/ZeroRo_logo.png',
                height: appBarHeight,
                fit: BoxFit.contain,
              ),
              backgroundColor: AppColors.background,
            )
          : null,
      body: Stack(
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

          // Chat overlay
          const ChatOverlay(),
        ],
      ),
      floatingActionButton: viewState == ChatViewState.characterVisible
          ? FloatingActionButton(
              onPressed: () {
                ref.read(chatViewStateProvider.notifier).setState(
                    ChatViewState.chatActive);
              },
              backgroundColor: AppColors.buttonColor,
              child: const Icon(Icons.chat, color: Colors.white),
            )
          : null,
    );
  }
}
