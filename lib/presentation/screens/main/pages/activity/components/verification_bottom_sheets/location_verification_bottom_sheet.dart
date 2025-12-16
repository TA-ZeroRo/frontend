import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/di/injection.dart';
import 'package:frontend/core/theme/app_color.dart';
import 'package:frontend/core/utils/toast_helper.dart';
import 'package:frontend/data/data_source/location/location_service.dart';
import 'package:frontend/data/data_source/mission/mission_api.dart';
import 'package:frontend/domain/model/mission/mission_with_template.dart';
import 'package:frontend/domain/model/verification/location_verification_result.dart';

import '../../state/campaign_mission_state.dart';

class LocationVerificationBottomSheet extends ConsumerStatefulWidget {
  final MissionWithTemplate mission;

  const LocationVerificationBottomSheet({super.key, required this.mission});

  @override
  ConsumerState<LocationVerificationBottomSheet> createState() =>
      _LocationVerificationBottomSheetState();
}

class _LocationVerificationBottomSheetState
    extends ConsumerState<LocationVerificationBottomSheet> {
  final MissionApi _missionApi = getIt<MissionApi>();
  bool _isSubmittingProof = false;

  @override
  void initState() {
    super.initState();
    // Provider 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(locationVerificationProvider.notifier)
          .initialize(widget.mission.campaign.id);
    });
  }

  /// 위치 인증 성공 시 증빙 데이터 제출
  Future<void> _submitLocationProof(LocationVerificationResult result) async {
    if (_isSubmittingProof) return;
    _isSubmittingProof = true;

    try {
      await _missionApi.submitProof(
        logId: widget.mission.missionLog.id,
        proofData: {
          'verification_type': 'location',
          'address': result.locationAddress,
          'distance': result.distance?.toStringAsFixed(0),
          'verified_at': result.verifiedAt?.toIso8601String() ??
              DateTime.now().toIso8601String(),
        },
      );
      // 미션 목록 새로고침
      ref.read(campaignMissionProvider.notifier).refresh();
    } catch (e) {
      ToastHelper.showError('증빙 제출 중 오류가 발생했습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final verificationState = ref.watch(locationVerificationProvider);

    // 성공 시 토스트 표시 및 증빙 데이터 제출
    ref.listen<LocationVerificationState>(locationVerificationProvider,
        (previous, next) {
      if (previous?.status != LocationVerificationStatus.success &&
          next.status == LocationVerificationStatus.success) {
        ToastHelper.showSuccess('위치 인증에 성공했습니다!');
        // 증빙 데이터 제출
        if (next.result != null) {
          _submitLocationProof(next.result!);
        }
      }
    });

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          // Drag Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildContent(verificationState),
                const SizedBox(height: 32),
                _buildActionButton(verificationState),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.location_on_outlined,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              '위치 인증',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          widget.mission.missionTemplate.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.mission.missionTemplate.description,
          style: TextStyle(fontSize: 15, color: Colors.grey[600], height: 1.5),
        ),
      ],
    );
  }

  Widget _buildContent(LocationVerificationState verificationState) {
    switch (verificationState.status) {
      case LocationVerificationStatus.initial:
        return _buildInitialContent(verificationState);
      case LocationVerificationStatus.requestingPermission:
        return _buildLoadingContent('위치 권한을 요청하고 있습니다...');
      case LocationVerificationStatus.fetchingLocation:
        return _buildLoadingContent('현재 위치를 가져오고 있습니다...');
      case LocationVerificationStatus.verifying:
        return _buildLoadingContent('위치를 인증하고 있습니다...');
      case LocationVerificationStatus.success:
        return _buildSuccessContent(verificationState);
      case LocationVerificationStatus.failed:
        return _buildFailedContent(verificationState);
      case LocationVerificationStatus.error:
        return _buildErrorContent(verificationState);
    }
  }

  Widget _buildInitialContent(LocationVerificationState verificationState) {
    final permissionStatus = verificationState.permissionStatus;

    // 권한 상태에 따른 UI 분기
    if (permissionStatus == LocationPermissionStatus.serviceDisabled) {
      return _buildPermissionCard(
        icon: Icons.location_disabled,
        iconColor: AppColors.warning,
        backgroundColor: AppColors.warning.withValues(alpha: 0.1),
        title: '위치 서비스가 꺼져 있습니다',
        description: '위치 인증을 위해 기기의 위치 서비스를 켜주세요.',
        actionText: '위치 설정 열기',
        onAction: () {
          ref
              .read(locationVerificationProvider.notifier)
              .openLocationSettingsAndRefresh();
        },
      );
    }

    if (permissionStatus == LocationPermissionStatus.permanentlyDenied) {
      return _buildPermissionCard(
        icon: Icons.location_off,
        iconColor: AppColors.error,
        backgroundColor: AppColors.error.withValues(alpha: 0.1),
        title: '위치 권한이 거부되었습니다',
        description: '앱 설정에서 위치 권한을 허용해주세요.',
        actionText: '설정으로 이동',
        onAction: () {
          ref
              .read(locationVerificationProvider.notifier)
              .openSettingsAndRefresh();
        },
      );
    }

    // 정상 상태 - 위치 인증 안내
    return _buildLocationGuideCard();
  }

  Widget _buildPermissionCard({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
    required String description,
    required String actionText,
    required VoidCallback onAction,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: iconColor.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: iconColor, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: onAction,
            child: Text(
              actionText,
              style: TextStyle(
                color: iconColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationGuideCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.my_location,
              color: AppColors.primary,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '캠페인 장소에서 인증해주세요',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '현재 위치가 캠페인 지정 장소 근처인지 확인합니다.\n정확한 인증을 위해 GPS를 켜주세요.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingContent(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessContent(LocationVerificationState verificationState) {
    final result = verificationState.result;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '위치 인증 성공!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.success,
            ),
          ),
          if (result != null) ...[
            const SizedBox(height: 8),
            Text(
              result.reason,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            if (result.distance != null) ...[
              const SizedBox(height: 4),
              Text(
                '거리: ${result.distance!.toStringAsFixed(0)}m',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildFailedContent(LocationVerificationState verificationState) {
    final result = verificationState.result;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_off,
              color: AppColors.error,
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '위치 인증 실패',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.error,
            ),
          ),
          if (result != null) ...[
            const SizedBox(height: 8),
            Text(
              result.reason,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            if (result.distance != null) ...[
              const SizedBox(height: 4),
              Text(
                '현재 거리: ${result.distance!.toStringAsFixed(0)}m',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildErrorContent(LocationVerificationState verificationState) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              color: AppColors.warning,
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '오류가 발생했습니다',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.warning,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            verificationState.errorMessage ?? '알 수 없는 오류가 발생했습니다.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(LocationVerificationState verificationState) {
    switch (verificationState.status) {
      case LocationVerificationStatus.initial:
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: verificationState.canVerify
                ? () {
                    ref
                        .read(locationVerificationProvider.notifier)
                        .startVerification();
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              disabledBackgroundColor: Colors.grey[200],
              disabledForegroundColor: Colors.grey[400],
            ),
            child: const Text(
              '위치 인증하기',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        );

      case LocationVerificationStatus.requestingPermission:
      case LocationVerificationStatus.fetchingLocation:
      case LocationVerificationStatus.verifying:
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.grey[400],
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              '인증 중...',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        );

      case LocationVerificationStatus.success:
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              '완료',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        );

      case LocationVerificationStatus.failed:
      case LocationVerificationStatus.error:
        return Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 56,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[600],
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    '닫기',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(locationVerificationProvider.notifier).retry();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    '다시 시도',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        );
    }
  }
}
