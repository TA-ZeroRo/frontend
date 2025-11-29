import 'package:flutter/material.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_text_style.dart';

class PrivacyPolicyModal extends StatelessWidget {
  const PrivacyPolicyModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              border: Border(
                bottom: BorderSide(
                  color: AppColors.textTertiary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 48), // Balance for close button
                Text(
                  '개인정보 수집 및 이용 동의',
                  style: AppTextStyle.titleLarge.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context, false),
                  icon: Icon(Icons.close_rounded, color: AppColors.onPrimary),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    '1. 수집하는 개인정보 항목',
                    '회사는 회원가입, 원활한 고객상담, 각종 서비스의 제공을 위해 아래와 같은 개인정보를 수집하고 있습니다.\n\n- 필수항목: 닉네임, 거주지(시/도, 시/군/구), 프로필 사진',
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    '2. 개인정보의 수집 및 이용목적',
                    '회사는 수집한 개인정보를 다음의 목적을 위해 활용합니다.\n\n- 서비스 제공에 관한 계약 이행 및 서비스 제공에 따른 요금정산\n- 회원 관리: 회원제 서비스 이용에 따른 본인확인, 개인식별, 불량회원의 부정 이용 방지와 비인가 사용 방지, 가입 의사 확인, 연령확인, 불만처리 등 민원처리, 고지사항 전달',
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    '3. 개인정보의 보유 및 이용기간',
                    '원칙적으로 개인정보 수집 및 이용목적이 달성된 후에는 해당 정보를 지체 없이 파기합니다. 단, 관계법령의 규정에 의하여 보존할 필요가 있는 경우 회사는 아래와 같이 관계법령에서 정한 일정한 기간 동안 회원정보를 보관합니다.\n\n- 보존 항목: 로그인ID, 결제기록\n- 보존 근거: 전자상거래등에서의 소비자보호에 관한 법률\n- 보존 기간: 3개월',
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    '4. 동의 거부 권리 및 불이익',
                    '이용자는 개인정보 수집 및 이용에 대해 동의를 거부할 권리가 있습니다. 다만, 필수항목에 대한 동의를 거부할 경우 회원가입 및 서비스 이용이 제한될 수 있습니다.',
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          // Bottom Button
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  '확인',
                  style: AppTextStyle.bodyLarge.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyle.bodyLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: AppTextStyle.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
