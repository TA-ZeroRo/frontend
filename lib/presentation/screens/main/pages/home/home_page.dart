import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../routes/router_path.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const double appBarHeight = 60;

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/zeroro_logo_design5.png',
          height: appBarHeight,
          fit: BoxFit.contain,
        ),
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
