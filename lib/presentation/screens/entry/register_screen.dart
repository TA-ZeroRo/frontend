import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_text_style.dart';
import '../../routes/router_path.dart';
import 'state/auth_controller.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  Future<void> _handleRegister(BuildContext context, WidgetRef ref) async {
    final authState = ref.read(authProvider);

    try {
      await ref.read(authProvider.notifier).register(
            nickname: authState.registerNickname,
            region: authState.registerLocation,
          );

      // 회원가입 성공 시 메인 화면으로 이동
      if (context.mounted) {
        context.go(RoutePath.main);
      }
    } catch (e) {
      if (!context.mounted) return;

      // 에러 토스트 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('회원가입 실패: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '회원가입',
          style: AppTextStyle.titleLarge.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: AppColors.primary,
        child: SafeArea(
          child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // Title
              Text(
                '기본 정보를 입력해주세요',
                style: AppTextStyle.headlineSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '나중에 프로필에서 수정할 수 있어요',
                style: AppTextStyle.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 40),

              // Nickname input
              Text(
                '닉네임',
                style: AppTextStyle.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                onChanged: authNotifier.updateRegisterNickname,
                style: AppTextStyle.bodyLarge,
                decoration: InputDecoration(
                  hintText: '닉네임을 입력해주세요',
                  hintStyle: AppTextStyle.bodyLarge.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  filled: true,
                  fillColor: AppColors.cardBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Location input
              Text(
                '거주지',
                style: AppTextStyle.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '리더보드 조회에 사용됩니다',
                style: AppTextStyle.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                onChanged: authNotifier.updateRegisterLocation,
                style: AppTextStyle.bodyLarge,
                decoration: InputDecoration(
                  hintText: '예: 서울특별시 강남구',
                  hintStyle: AppTextStyle.bodyLarge.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  filled: true,
                  fillColor: AppColors.cardBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),

              const Spacer(),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: authNotifier.isRegisterFormValid() && !authState.isLoading
                      ? () => _handleRegister(context, ref)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonColor,
                    disabledBackgroundColor: AppColors.textTertiary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: authState.isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          '완료',
                          style: AppTextStyle.labelLarge.copyWith(
                            color: authNotifier.isRegisterFormValid()
                                ? AppColors.buttonTextColor
                                : AppColors.cardBackground,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
