import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/utils/toast_helper.dart';
import '../../../../../../core/di/injection.dart';
import '../../../../../../data/repository/character/character_repository.dart';
import '../../../../../../data/dto/character/character_info.dart';
import '../../../../settings/state/settings_controller.dart';
import '../../../../entry/state/auth_controller.dart';
import '../state/chat_controller.dart';

class CharacterSelectModal extends ConsumerStatefulWidget {
  const CharacterSelectModal({super.key});

  @override
  ConsumerState<CharacterSelectModal> createState() => _CharacterSelectModalState();
}

class _CharacterSelectModalState extends ConsumerState<CharacterSelectModal> {
  late String _tempSelectedCharacter;
  final CharacterRepository _characterRepository = getIt<CharacterRepository>();

  bool _isLoading = true;
  List<CharacterInfo> _characters = [];
  int _currentPoints = 0;

  @override
  void initState() {
    super.initState();
    // 현재 설정된 캐릭터를 임시 선택 상태로 초기화
    _tempSelectedCharacter = ref.read(appSettingsProvider).selectedCharacter;
    _loadCharacters();
  }

  /// 백엔드에서 캐릭터 목록 불러오기
  Future<void> _loadCharacters() async {
    final userId = ref.read(authProvider).currentUser?.id;
    if (userId == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await _characterRepository.getCharacters(userId);
      setState(() {
        _characters = response.characters;
        _currentPoints = response.totalPoints;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ToastHelper.showError('캐릭터 목록을 불러오는데 실패했습니다.');
    }
  }

  /// 캐릭터 선택 처리 (잠금 해제 포함)
  Future<void> _handleCharacterSelect(String characterId) async {
    final userId = ref.read(authProvider).currentUser?.id;
    if (userId == null) {
      ToastHelper.showError('로그인이 필요합니다.');
      return;
    }

    final character = _characters.firstWhere((c) => c.id == characterId);

    // 이미 해금된 캐릭터면 바로 선택
    if (character.isUnlocked) {
      setState(() {
        _tempSelectedCharacter = characterId;
      });
      return;
    }

    // 해금 가능한지 확인
    if (!character.canUnlock) {
      ToastHelper.showError('${character.requiredPoints}점 달성 시 해금됩니다.');
      return;
    }

    // 캐릭터 해금 API 호출
    try {
      await _characterRepository.unlockCharacter(userId, characterId);
      ToastHelper.showSuccess('${character.name}이(가) 해금되었습니다!');

      // 캐릭터 목록 새로고침
      await _loadCharacters();

      setState(() {
        _tempSelectedCharacter = characterId;
      });
    } catch (e) {
      ToastHelper.showError('캐릭터 해금에 실패했습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '캐릭터 선택',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Description
            const Text(
              '함께할 제로로를 선택해주세요',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),

            // Character Options
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else
              Row(
                children: _characters.map((character) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: character == _characters.last ? 0 : 16,
                      ),
                      child: _CharacterOptionCard(
                        id: character.id,
                        name: character.name,
                        imagePath: character.id == 'earth_zeroro'
                            ? 'assets/images/earth_zeroro.png'
                            : 'assets/images/cloud_zeroro.png',
                        isSelected: _tempSelectedCharacter == character.id,
                        isLocked: !character.isUnlocked,
                        canUnlock: character.canUnlock,
                        requiredPoints: character.requiredPoints,
                        currentPoints: _currentPoints,
                        onTap: () => _handleCharacterSelect(character.id),
                      ),
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      '닫기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      // 캐릭터 변경 시 채팅 기록 초기화
                      ref.read(chatProvider.notifier).clearMessages();
                      // 상태 업데이트를 먼저 수행
                      ref
                          .read(appSettingsProvider.notifier)
                          .updateCharacter(_tempSelectedCharacter);
                      // 다이얼로그 닫기
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      '선택하기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CharacterOptionCard extends StatefulWidget {
  final String id;
  final String name;
  final String imagePath;
  final bool isSelected;
  final bool isLocked;
  final bool canUnlock;
  final int requiredPoints;
  final int currentPoints;
  final VoidCallback onTap;

  const _CharacterOptionCard({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.isSelected,
    required this.isLocked,
    required this.canUnlock,
    required this.requiredPoints,
    required this.currentPoints,
    required this.onTap,
  });

  @override
  State<_CharacterOptionCard> createState() => _CharacterOptionCardState();
}

class _CharacterOptionCardState extends State<_CharacterOptionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnimation.value, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.primary.withValues(alpha: 0.05)
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isSelected ? AppColors.primary : Colors.grey[200]!,
              width: widget.isSelected ? 2 : 1.5,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // Glow effect behind image when selected
                  if (widget.isSelected && !widget.isLocked)
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: 0.2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: widget.isSelected && !widget.isLocked
                            ? AppColors.primary.withValues(alpha: 0.3)
                            : Colors.transparent,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Stack(
                        children: [
                          Transform.scale(
                            scale: 1.2,
                            child: Image.asset(
                              widget.imagePath,
                              fit: BoxFit.cover,
                              color: widget.isLocked
                                  ? Colors.black.withValues(alpha: 0.5)
                                  : null,
                              colorBlendMode:
                                  widget.isLocked ? BlendMode.darken : null,
                            ),
                          ),
                          // Lock overlay
                          if (widget.isLocked)
                            Container(
                              color: Colors.black.withValues(alpha: 0.4),
                              child: const Center(
                                child: Icon(
                                  Icons.lock,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  // Selection badge
                  if (widget.isSelected && !widget.isLocked)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: widget.isSelected && !widget.isLocked
                      ? FontWeight.bold
                      : FontWeight.w600,
                  color: widget.isLocked
                      ? AppColors.textSecondary
                      : (widget.isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary),
                ),
              ),
              if (widget.isLocked) ...[
                const SizedBox(height: 4),
                Text(
                  widget.canUnlock
                      ? '탭하여 해금'
                      : '${widget.requiredPoints}점 필요',
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.canUnlock
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontWeight:
                        widget.canUnlock ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
