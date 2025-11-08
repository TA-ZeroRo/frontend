import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_text_style.dart';
import '../../../core/utils/toast_helper.dart';
import '../../../domain/model/post/post.dart';
import '../main/pages/campaign/state/community_controller.dart';

// Form state model
class PostFormState {
  final String title;
  final String content;
  final String? imageUrl;
  final bool isLoading;
  final String? error;

  const PostFormState({
    this.title = '',
    this.content = '',
    this.imageUrl,
    this.isLoading = false,
    this.error,
  });

  PostFormState copyWith({
    String? title,
    String? content,
    String? imageUrl,
    bool? isLoading,
    String? error,
  }) {
    return PostFormState(
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Post form notifier
class PostFormNotifier extends Notifier<PostFormState> {
  @override
  PostFormState build() => const PostFormState();

  void updateTitle(String title) {
    state = state.copyWith(title: title);
  }

  void updateContent(String content) {
    state = state.copyWith(content: content);
  }

  void updateImageUrl(String? imageUrl) {
    state = state.copyWith(imageUrl: imageUrl);
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void initialize(Post? post) {
    if (post != null) {
      state = PostFormState(
        title: post.title,
        content: post.content,
        imageUrl: post.imageUrl,
      );
    } else {
      state = const PostFormState();
    }
  }

  void reset() {
    state = const PostFormState();
  }

  bool validate() {
    if (state.title.trim().isEmpty) {
      setError('제목을 입력해주세요');
      return false;
    }
    if (state.content.trim().isEmpty) {
      setError('내용을 입력해주세요');
      return false;
    }
    setError(null);
    return true;
  }
}

final postFormProvider = NotifierProvider<PostFormNotifier, PostFormState>(
  PostFormNotifier.new,
);

/// Edit Post Screen - Supports both creating and editing posts
///
/// Usage:
/// ```dart
/// // Create new post
/// context.push('/post/edit');
///
/// // Edit existing post
/// context.push('/post/edit', extra: post);
/// ```
class EditPostScreen extends ConsumerStatefulWidget {
  final Post? post; // null for creating new post, non-null for editing

  const EditPostScreen({super.key, this.post});

  @override
  ConsumerState<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends ConsumerState<EditPostScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize form state from post if editing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(postFormProvider.notifier).initialize(widget.post);
      if (widget.post != null) {
        _titleController.text = widget.post!.title;
        _contentController.text = widget.post!.content;
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final formNotifier = ref.read(postFormProvider.notifier);
      formNotifier.setLoading(true);

      try {
        if (widget.post != null) {
          // Update existing post
          await ref
              .read(postsProvider.notifier)
              .updatePost(
                widget.post!.id,
                _titleController.text,
                _contentController.text,
              );
        } else {
          // Create new post
          await ref
              .read(postsProvider.notifier)
              .createPost(_titleController.text, _contentController.text);
        }

        if (mounted) {
          formNotifier.reset();
          context.pop(true); // Return success result
        }
      } catch (e) {
        formNotifier.setError(e.toString());
        if (mounted) {
          ToastHelper.showError('오류가 발생했습니다: ${e.toString()}');
        }
      } finally {
        if (mounted) {
          formNotifier.setLoading(false);
        }
      }
    }
  }

  void _handleImagePicker() {
    // TODO: Image picker implementation
    ToastHelper.showInfo('이미지 선택 기능은 아직 구현되지 않았습니다.');
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(postFormProvider);
    final isEditMode = widget.post != null;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Custom AppBar
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.close, color: AppColors.textPrimary),
                        onPressed: () => context.pop(),
                      ),
                      Expanded(
                        child: Text(
                          isEditMode ? '게시글 수정' : '게시글 작성',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.titleMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      AnimatedContainer(
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
                                  '게시',
                                  style: AppTextStyle.labelLarge.copyWith(
                                    color: AppColors.buttonTextColor,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Expanded(
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
                                color: AppColors.textTertiary.withValues(
                                  alpha: 0.3,
                                ),
                              ),
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
                                        style: AppTextStyle.titleMedium
                                            .copyWith(
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
                                          .read(postFormProvider.notifier)
                                          .updateTitle(value);
                                    },
                                    decoration: InputDecoration(
                                      hintText: '제목을 입력하세요',
                                      hintStyle: AppTextStyle.bodyMedium
                                          .copyWith(
                                            color: AppColors.textTertiary,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: AppColors.textTertiary
                                              .withValues(alpha: 0.3),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: AppColors.textTertiary
                                              .withValues(alpha: 0.3),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: AppColors.primaryAccent,
                                          width: 2,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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
                                      if (value == null ||
                                          value.trim().isEmpty) {
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

                          // Content input card
                          Card(
                            elevation: 0,
                            color: AppColors.cardBackground,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: AppColors.textTertiary.withValues(
                                  alpha: 0.3,
                                ),
                              ),
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
                                        '내용',
                                        style: AppTextStyle.titleMedium
                                            .copyWith(
                                              color: AppColors.textPrimary,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: _contentController,
                                    onChanged: (value) {
                                      ref
                                          .read(postFormProvider.notifier)
                                          .updateContent(value);
                                    },
                                    decoration: InputDecoration(
                                      hintText: '내용을 입력하세요',
                                      hintStyle: AppTextStyle.bodyMedium
                                          .copyWith(
                                            color: AppColors.textTertiary,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: AppColors.textTertiary
                                              .withValues(alpha: 0.3),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: AppColors.textTertiary
                                              .withValues(alpha: 0.3),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: AppColors.primaryAccent,
                                          width: 2,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return '내용을 입력해주세요';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Image upload card
                          Card(
                            elevation: 0,
                            color: AppColors.cardBackground,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: AppColors.textTertiary.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.image,
                                        color: AppColors.primaryAccent,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '사진',
                                        style: AppTextStyle.titleMedium
                                            .copyWith(
                                              color: AppColors.textPrimary,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  InkWell(
                                    onTap: _handleImagePicker,
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 20,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: AppColors.textTertiary
                                              .withValues(alpha: 0.3),
                                          style: BorderStyle.solid,
                                        ),
                                        color: AppColors.background,
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.add_photo_alternate_outlined,
                                            size: 32,
                                            color: AppColors.textSecondary,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            '사진 추가',
                                            style: AppTextStyle.bodyMedium
                                                .copyWith(
                                                  color:
                                                      AppColors.textSecondary,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '1장만 업로드 가능',
                                            style: AppTextStyle.bodySmall
                                                .copyWith(
                                                  color: AppColors.textTertiary,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.black.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    '부적절한 게시글은 삭제될 수 있습니다.',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
