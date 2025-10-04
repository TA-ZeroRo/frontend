import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_text_style.dart';
import 'state/campaign_controller.dart';

// Form state model
class CampaignRecruitingFormState {
  final String title;
  final int? recruitmentCount;
  final String campaignName;
  final String requirements;
  final String? url;
  final bool isLoading;
  final String? error;

  const CampaignRecruitingFormState({
    this.title = '',
    this.recruitmentCount,
    this.campaignName = '',
    this.requirements = '',
    this.url,
    this.isLoading = false,
    this.error,
  });

  CampaignRecruitingFormState copyWith({
    String? title,
    int? recruitmentCount,
    String? campaignName,
    String? requirements,
    String? url,
    bool? isLoading,
    String? error,
  }) {
    return CampaignRecruitingFormState(
      title: title ?? this.title,
      recruitmentCount: recruitmentCount ?? this.recruitmentCount,
      campaignName: campaignName ?? this.campaignName,
      requirements: requirements ?? this.requirements,
      url: url ?? this.url,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Campaign recruiting form notifier
class CampaignRecruitingFormNotifier extends Notifier<CampaignRecruitingFormState> {
  @override
  CampaignRecruitingFormState build() => const CampaignRecruitingFormState();

  void updateTitle(String title) {
    state = state.copyWith(title: title);
  }

  void updateRecruitmentCount(int? count) {
    state = state.copyWith(recruitmentCount: count);
  }

  void updateCampaignName(String campaignName) {
    state = state.copyWith(campaignName: campaignName);
  }

  void updateRequirements(String requirements) {
    state = state.copyWith(requirements: requirements);
  }

  void updateUrl(String? url) {
    state = state.copyWith(url: url);
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void reset() {
    state = const CampaignRecruitingFormState();
  }

  bool validate() {
    if (state.title.trim().isEmpty) {
      setError('제목을 입력해주세요');
      return false;
    }
    if (state.recruitmentCount == null || state.recruitmentCount! < 2) {
      setError('모집인원은 최소 2명 이상이어야 합니다');
      return false;
    }
    if (state.campaignName.trim().isEmpty) {
      setError('캠페인 이름을 입력해주세요');
      return false;
    }
    if (state.requirements.trim().isEmpty) {
      setError('상세 요건을 입력해주세요');
      return false;
    }
    if (state.url != null && state.url!.isNotEmpty) {
      final urlPattern = RegExp(
        r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
      );
      if (!urlPattern.hasMatch(state.url!)) {
        setError('올바른 URL 형식을 입력해주세요');
        return false;
      }
    }
    setError(null);
    return true;
  }
}

final campaignRecruitingFormProvider =
    NotifierProvider<CampaignRecruitingFormNotifier, CampaignRecruitingFormState>(
  CampaignRecruitingFormNotifier.new,
);

/// Campaign Recruiting Screen - For creating campaign recruiting posts
///
/// Usage:
/// ```dart
/// // Create new campaign recruiting
/// context.push('/campaign/recruiting');
/// ```
class CampaignRecruitingScreen extends ConsumerStatefulWidget {
  const CampaignRecruitingScreen({super.key});

  @override
  ConsumerState<CampaignRecruitingScreen> createState() =>
      _CampaignRecruitingScreenState();
}

class _CampaignRecruitingScreenState
    extends ConsumerState<CampaignRecruitingScreen> {
  final _titleController = TextEditingController();
  final _recruitmentCountController = TextEditingController();
  final _campaignNameController = TextEditingController();
  final _requirementsController = TextEditingController();
  final _urlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final double appBarHeight = 60;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(campaignRecruitingFormProvider.notifier).reset();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _recruitmentCountController.dispose();
    _campaignNameController.dispose();
    _requirementsController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final formNotifier = ref.read(campaignRecruitingFormProvider.notifier);

      if (!formNotifier.validate()) {
        toastification.show(
          margin: EdgeInsets.only(top: appBarHeight),
          alignment: Alignment.topCenter,
          style: ToastificationStyle.flatColored,
          title: Text(formNotifier.state.error ?? '입력 값을 확인해주세요'),
          autoCloseDuration: const Duration(seconds: 2),
          primaryColor: AppColors.error,
        );
        return;
      }

      formNotifier.setLoading(true);

      try {
        await ref.read(campaignRecruitingsProvider.notifier).createCampaignRecruiting(
              title: _titleController.text,
              recruitmentCount: int.parse(_recruitmentCountController.text),
              campaignName: _campaignNameController.text,
              requirements: _requirementsController.text,
              url: _urlController.text.isEmpty ? null : _urlController.text,
            );

        if (mounted) {
          formNotifier.reset();
          toastification.show(
            margin: EdgeInsets.only(top: appBarHeight),
            alignment: Alignment.topCenter,
            style: ToastificationStyle.flatColored,
            title: const Text('캠페인 모집글이 등록되었습니다'),
            autoCloseDuration: const Duration(seconds: 2),
            primaryColor: AppColors.success,
          );
          context.pop(true);
        }
      } catch (e) {
        formNotifier.setError(e.toString());
        if (mounted) {
          toastification.show(
            margin: EdgeInsets.only(top: appBarHeight),
            alignment: Alignment.topCenter,
            style: ToastificationStyle.flatColored,
            title: Text('오류가 발생했습니다: ${e.toString()}'),
            autoCloseDuration: const Duration(seconds: 2),
            primaryColor: AppColors.error,
          );
        }
      } finally {
        if (mounted) {
          formNotifier.setLoading(false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(campaignRecruitingFormProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '캠페인 크루팅',
          style: AppTextStyle.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: ElevatedButton(
                onPressed: formState.isLoading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryAccent,
                  foregroundColor: AppColors.buttonTextColor,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                child: formState.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.buttonTextColor,
                          ),
                        ),
                      )
                    : Text(
                        '모집하기',
                        style: AppTextStyle.labelLarge.copyWith(
                          color: AppColors.buttonTextColor,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title input card
                Card(
                  elevation: 0,
                  color: AppColors.cardBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                        color: AppColors.textTertiary.withValues(alpha: 0.3)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.title,
                              color: AppColors.primaryAccent,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '제목',
                              style: AppTextStyle.titleMedium.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _titleController,
                          onChanged: (value) {
                            ref
                                .read(campaignRecruitingFormProvider.notifier)
                                .updateTitle(value);
                          },
                          decoration: InputDecoration(
                            hintText: '제목을 입력하세요',
                            hintStyle: AppTextStyle.bodyMedium.copyWith(
                              color: AppColors.textTertiary,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color:
                                    AppColors.textTertiary.withValues(alpha: 0.3),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color:
                                    AppColors.textTertiary.withValues(alpha: 0.3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.primaryAccent,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            filled: true,
                            fillColor: AppColors.background,
                          ),
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                          maxLength: 50,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return '제목을 입력해주세요';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Recruitment count input card
                Card(
                  elevation: 0,
                  color: AppColors.cardBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                        color: AppColors.textTertiary.withValues(alpha: 0.3)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.people,
                              color: AppColors.primaryAccent,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '모집인원',
                              style: AppTextStyle.titleMedium.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _recruitmentCountController,
                          onChanged: (value) {
                            final count = int.tryParse(value);
                            ref
                                .read(campaignRecruitingFormProvider.notifier)
                                .updateRecruitmentCount(count);
                          },
                          decoration: InputDecoration(
                            hintText: '모집인원을 입력하세요 (최소 2명)',
                            hintStyle: AppTextStyle.bodyMedium.copyWith(
                              color: AppColors.textTertiary,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color:
                                    AppColors.textTertiary.withValues(alpha: 0.3),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color:
                                    AppColors.textTertiary.withValues(alpha: 0.3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.primaryAccent,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            filled: true,
                            fillColor: AppColors.background,
                          ),
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return '모집인원을 입력해주세요';
                            }
                            final count = int.tryParse(value);
                            if (count == null || count < 2) {
                              return '모집인원은 최소 2명 이상이어야 합니다';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Campaign name input card
                Card(
                  elevation: 0,
                  color: AppColors.cardBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                        color: AppColors.textTertiary.withValues(alpha: 0.3)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.campaign,
                              color: AppColors.primaryAccent,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '참가할 캠페인',
                              style: AppTextStyle.titleMedium.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _campaignNameController,
                          onChanged: (value) {
                            ref
                                .read(campaignRecruitingFormProvider.notifier)
                                .updateCampaignName(value);
                          },
                          decoration: InputDecoration(
                            hintText: '캠페인 이름을 입력하세요',
                            hintStyle: AppTextStyle.bodyMedium.copyWith(
                              color: AppColors.textTertiary,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color:
                                    AppColors.textTertiary.withValues(alpha: 0.3),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color:
                                    AppColors.textTertiary.withValues(alpha: 0.3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.primaryAccent,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            filled: true,
                            fillColor: AppColors.background,
                          ),
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return '캠페인 이름을 입력해주세요';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Requirements input card
                Card(
                  elevation: 0,
                  color: AppColors.cardBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                        color: AppColors.textTertiary.withValues(alpha: 0.3)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.description,
                              color: AppColors.primaryAccent,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '상세 요건',
                              style: AppTextStyle.titleMedium.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _requirementsController,
                          onChanged: (value) {
                            ref
                                .read(campaignRecruitingFormProvider.notifier)
                                .updateRequirements(value);
                          },
                          decoration: InputDecoration(
                            hintText: '상세 요건을 입력하세요',
                            hintStyle: AppTextStyle.bodyMedium.copyWith(
                              color: AppColors.textTertiary,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color:
                                    AppColors.textTertiary.withValues(alpha: 0.3),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color:
                                    AppColors.textTertiary.withValues(alpha: 0.3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.primaryAccent,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            filled: true,
                            fillColor: AppColors.background,
                          ),
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 8,
                          minLines: 5,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return '상세 요건을 입력해주세요';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // URL input card
                Card(
                  elevation: 0,
                  color: AppColors.cardBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                        color: AppColors.textTertiary.withValues(alpha: 0.3)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.link,
                              color: AppColors.primaryAccent,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'URL',
                              style: AppTextStyle.titleMedium.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.textTertiary.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '선택',
                                style: AppTextStyle.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _urlController,
                          onChanged: (value) {
                            ref
                                .read(campaignRecruitingFormProvider.notifier)
                                .updateUrl(value.isEmpty ? null : value);
                          },
                          decoration: InputDecoration(
                            hintText: '캠페인 URL을 입력하세요 (선택사항)',
                            hintStyle: AppTextStyle.bodyMedium.copyWith(
                              color: AppColors.textTertiary,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color:
                                    AppColors.textTertiary.withValues(alpha: 0.3),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color:
                                    AppColors.textTertiary.withValues(alpha: 0.3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.primaryAccent,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            filled: true,
                            fillColor: AppColors.background,
                          ),
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                          keyboardType: TextInputType.url,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final urlPattern = RegExp(
                                r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
                              );
                              if (!urlPattern.hasMatch(value)) {
                                return '올바른 URL 형식을 입력해주세요';
                              }
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Info message
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.primaryAccent.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.primaryAccent,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '환경을 위한 캠페인에 함께해요!',
                          style: AppTextStyle.bodySmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
