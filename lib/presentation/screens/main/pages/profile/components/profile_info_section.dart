import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/profile_controller.dart';

class ProfileInfoSection extends ConsumerStatefulWidget {
  const ProfileInfoSection({super.key});

  @override
  ConsumerState<ProfileInfoSection> createState() => _ProfileInfoSectionState();
}

class _ProfileInfoSectionState extends ConsumerState<ProfileInfoSection> {
  bool _isEditing = false;
  late TextEditingController _usernameController;
  String? _tempImageUrl;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider);
    _usernameController = TextEditingController(text: profile.username);
    _tempImageUrl = profile.userImg;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    if (_isEditing) {
      // 저장 로직
      final notifier = ref.read(profileProvider.notifier);
      notifier.updateUsername(_usernameController.text.trim());
      notifier.updateUserImage(_tempImageUrl);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('프로필이 업데이트되었습니다.'),
          backgroundColor: const Color.fromRGBO(116, 205, 124, 1),
        ),
      );
    } else {
      // 편집 모드 시작 - 현재 값으로 초기화
      final profile = ref.read(profileProvider);
      _usernameController.text = profile.username;
      _tempImageUrl = profile.userImg;
    }
    setState(() => _isEditing = !_isEditing);
  }

  void _cancelEdit() {
    final profile = ref.read(profileProvider);
    setState(() {
      _isEditing = false;
      _usernameController.text = profile.username;
      _tempImageUrl = profile.userImg;
    });
  }

  void _toggleAvatar() {
    setState(() {
      _tempImageUrl = _tempImageUrl == null
          ? 'https://picsum.photos/200'
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final displayImageUrl = _isEditing ? _tempImageUrl : profile.userImg;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // 프로필 사진
              GestureDetector(
                onTap: _isEditing ? _toggleAvatar : null,
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 43,
                        backgroundColor: const Color.fromRGBO(199, 199, 199, 1),
                        child: CircleAvatar(
                          radius: 43,
                          backgroundColor: Colors.grey[300],
                          backgroundImage:
                              (displayImageUrl != null &&
                                  displayImageUrl.isNotEmpty)
                              ? NetworkImage(displayImageUrl)
                              : null,
                          child:
                              (displayImageUrl == null ||
                                  displayImageUrl.isEmpty)
                              ? const Icon(
                                  Icons.person,
                                  size: 86,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                    ),
                    if (_isEditing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(48, 232, 54, 1),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (_isEditing)
                      Expanded(
                        child: TextField(
                          controller: _usernameController,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            hintText: '이름을 입력하세요',
                            border: UnderlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.username.isNotEmpty
                                  ? profile.username
                                  : '김오띠',
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '총 포인트: ${profile.totalPoints}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '연속 일수: ${profile.continuousDays}일',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    // 편집 버튼들
                    if (_isEditing) ...[
                      IconButton(
                        onPressed: _cancelEdit,
                        icon: const Icon(Icons.close, color: Colors.red),
                        iconSize: 28,
                      ),
                      IconButton(
                        onPressed: _toggleEdit,
                        icon: const Icon(Icons.check, color: Colors.green),
                        iconSize: 28,
                      ),
                    ] else
                      IconButton(
                        onPressed: _toggleEdit,
                        icon: const Icon(Icons.edit),
                        iconSize: 24,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
