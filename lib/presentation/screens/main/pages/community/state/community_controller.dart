import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../domain/model/comment/comment.dart';
import '../../../../../../domain/model/post/post.dart';
import 'mock/mock_posts.dart';
import 'mock/mock_comments.dart';

// Posts state
class PostsNotifier extends AsyncNotifier<List<Post>> {
  @override
  Future<List<Post>> build() async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));
    return mockPosts;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      return mockPosts;
    });
  }

  Future<void> updatePostLikes(int postId, int newLikesCount) async {
    final currentPosts = state.value ?? [];
    final updatedPosts = currentPosts.map((post) {
      if (post.id == postId) {
        return post.copyWith(likesCount: newLikesCount);
      }
      return post;
    }).toList();
    state = AsyncValue.data(updatedPosts);
  }

  Future<void> deletePost(int postId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      final currentPosts = state.value ?? [];
      return currentPosts.where((post) => post.id != postId).toList();
    });
  }

  Future<void> createPost(String title, String content) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      final currentPosts = state.value ?? [];
      final newPost = Post(
        id: DateTime.now().millisecondsSinceEpoch,
        userId: 'current_user',
        title: title,
        content: content,
        likesCount: 0,
        createdAt: DateTime.now().toIso8601String(),
        username: 'Current User',
        userImg: null,
        imageUrl: null,
      );
      return [newPost, ...currentPosts];
    });
  }

  Future<void> updatePost(int postId, String title, String content) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      final currentPosts = state.value ?? [];
      return currentPosts.map((post) {
        if (post.id == postId) {
          return post.copyWith(
            title: title,
            content: content,
          );
        }
        return post;
      }).toList();
    });
  }
}

final postsProvider = AsyncNotifierProvider<PostsNotifier, List<Post>>(
  PostsNotifier.new,
);

// Comments provider using FutureProvider.family for simplicity
final commentsProvider = FutureProvider.family<List<Comment>, int>((ref, postId) async {
  await Future.delayed(const Duration(milliseconds: 300));
  return mockComments[postId] ?? [];
});

// Comment operations provider
class CommentOperationsNotifier extends Notifier<void> {
  @override
  void build() {}

  Future<void> addComment(int postId, String userId, String username, String content) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final currentComments = mockComments[postId] ?? [];
    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch,
      postId: postId,
      userId: userId,
      username: username,
      content: content,
      createdAt: DateTime.now(),
    );
    mockComments[postId] = [...currentComments, newComment];
    ref.invalidate(commentsProvider(postId));
  }

  Future<void> deleteComment(int postId, int commentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final currentComments = mockComments[postId] ?? [];
    mockComments[postId] = currentComments.where((comment) => comment.id != commentId).toList();
    ref.invalidate(commentsProvider(postId));
  }

  Future<void> updateComment(int postId, int commentId, String newContent) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final currentComments = mockComments[postId] ?? [];
    mockComments[postId] = currentComments.map((comment) {
      if (comment.id == commentId) {
        return comment.copyWith(content: newContent);
      }
      return comment;
    }).toList();
    ref.invalidate(commentsProvider(postId));
  }
}

final commentOperationsProvider = NotifierProvider<CommentOperationsNotifier, void>(
  CommentOperationsNotifier.new,
);
