import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_color.dart';
import 'package:go_router/go_router.dart';
import '../../../../routes/router_path.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const double appBarHeight = 50;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Image.asset(
          'assets/images/ZeroRo_logo.png',
          height: appBarHeight,
          fit: BoxFit.contain,
        ),
        backgroundColor: AppColors.background,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Home Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => context.push(RoutePath.verifyImage),
              icon: const Icon(Icons.image),
              label: const Text('사진 인증'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF30E836),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => context.push(RoutePath.verifyQuiz),
              icon: const Icon(Icons.psychology),
              label: const Text('퀴즈 인증'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF30E836),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
