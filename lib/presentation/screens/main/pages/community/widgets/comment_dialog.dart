import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../profile/state/profile_controller.dart';
import '../state/community_controller.dart';
import 'comment_card.dart';

class CommentDialog extends ConsumerStatefulWidget {
  final int postId;

  const CommentDialog({super.key, required this.postId});

  @override
  ConsumerState<CommentDialog> createState() => _CommentDialogState();
}

class _CommentDialogState extends ConsumerState<CommentDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendComment() {
    final content = _controller.text.trim();
    final profile = ref.read(profileProvider);

    if (content.isNotEmpty) {
      ref.read(commentOperationsProvider.notifier).addComment(
        widget.postId,
        profile.userId,
        profile.username,
        content,
      );
      _controller.clear();
    }
  }

  void _deleteComment(int commentId) {
    ref.read(commentOperationsProvider.notifier).deleteComment(
      widget.postId,
      commentId,
    );
  }

  void _editComment(int commentId, String newContent) {
    ref.read(commentOperationsProvider.notifier).updateComment(
      widget.postId,
      commentId,
      newContent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final commentsAsync = ref.watch(commentsProvider(widget.postId));
    final profile = ref.watch(profileProvider);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 100),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '댓글',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(height: 16),
            Expanded(
              child: commentsAsync.when(
                data: (comments) {
                  if (comments.isEmpty) {
                    return const Center(
                      child: Text('아직 댓글이 없습니다.\n첫 번째 댓글을 작성해보세요!'),
                    );
                  }
                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      final isMyComment = comment.userId == profile.userId;

                      return CommentCard(
                        userName: comment.username,
                        content: comment.content,
                        isMyComment: isMyComment,
                        onDelete: isMyComment
                            ? () => _deleteComment(comment.id)
                            : null,
                        onEdit: isMyComment
                            ? (newContent) => _editComment(comment.id, newContent)
                            : null,
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '오류가 발생했습니다.',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => ref.invalidate(commentsProvider(widget.postId)),
                        child: const Text('다시 시도'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: '댓글을 입력하세요',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    maxLines: null,
                    onSubmitted: (_) => _sendComment(),
                  ),
                ),
                const SizedBox(width: 8),
                commentsAsync.isLoading
                    ? const SizedBox(
                        width: 40,
                        height: 40,
                        child: Center(
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: _sendComment,
                        child: const Text('전송'),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
