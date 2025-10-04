import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_color.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const double appBarHeight = 50;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Image.asset(
          'assets/images/zeroro_logo_design5.png',
          height: appBarHeight,
          fit: BoxFit.contain,
        ),
        backgroundColor: AppColors.background,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/mock_zeroro.jpg',
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
