import '../../../../../../../domain/model/comment.dart';

// Mock comments for different posts
final mockComments = <int, List<Comment>>{
  1: [
    Comment(
      id: 1,
      postId: 1,
      userId: 'user_002',
      username: '에코워리어',
      content: '정말 멋진 활동이네요! 저도 다음에 같이 참여하고 싶어요.',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Comment(
      id: 2,
      postId: 1,
      userId: 'user_003',
      username: '그린라이프',
      content: '5kg이나! 대단하십니다 👏',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ],
  2: [
    Comment(
      id: 3,
      postId: 2,
      userId: 'user_001',
      username: '제로로로',
      content: '저도 도전 중인데 정말 뿌듯해요!',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
  ],
  3: [
    Comment(
      id: 4,
      postId: 3,
      userId: 'user_004',
      username: '자연사랑',
      content: '유익한 정보 감사합니다. 주말에 가봐야겠어요!',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Comment(
      id: 5,
      postId: 3,
      userId: 'user_001',
      username: '제로로로',
      content: '위치 정보까지 알려주셔서 감사합니다!',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ],
  4: [
    Comment(
      id: 6,
      postId: 4,
      userId: 'user_002',
      username: '에코워리어',
      content: '대나무 칫솔 정보 감사해요. 저도 바꿔볼게요!',
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
  ],
  5: [
    Comment(
      id: 7,
      postId: 5,
      userId: 'user_003',
      username: '그린라이프',
      content: '텃밭 너무 좋아요! 성장 과정도 공유해주세요.',
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
  ],
};
