import 'package:flutter/material.dart';

import '../../../../../core/theme/app_color.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(child: Text('Community Page')),
    );
  }
}
