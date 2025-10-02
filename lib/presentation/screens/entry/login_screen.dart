import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../routes/router_path.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 로고 이미지
          Image.asset(
            'assets/images/zeroro_logo_design5.png',
            height: 80,
            fit: BoxFit.contain,
          ),

          const SizedBox(height: 16),

          // 부제목
          const Text(
            '친환경 라이프스타일을 시작해보세요',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 120),

          // 구글 로그인 버튼
          SizedBox(
            height: 56,
            width: 380,
            child: ElevatedButton(
              onPressed: () {
                context.go(RoutePath.main);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade400, width: 1),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/google.png',
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Google 계정으로 빠르게 시작하세요',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 구분선
          Row(
            children: [
              Expanded(child: Container(height: 1, color: Colors.grey[300])),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('또는', style: TextStyle(fontSize: 14)),
              ),
              Expanded(child: Container(height: 1, color: Colors.grey[300])),
            ],
          ),

          const SizedBox(height: 20),

          // 게스트 로그인 버튼
          SizedBox(
            width: 380,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                context.go(RoutePath.main);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade400, width: 1),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_outline,
                    color: Colors.grey[700],
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '게스트로 시작하기',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
