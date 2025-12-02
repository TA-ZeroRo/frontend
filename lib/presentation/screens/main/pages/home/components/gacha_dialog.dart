import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/utils/toast_helper.dart';
import '../../../../../../presentation/screens/settings/state/settings_controller.dart';
import '../../../../entry/state/auth_controller.dart';

class GachaDialog extends ConsumerStatefulWidget {
  const GachaDialog({super.key});

  @override
  ConsumerState<GachaDialog> createState() => _GachaDialogState();
}

class _GachaDialogState extends ConsumerState<GachaDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;
  late Animation<double> _scaleAnimation;

  bool _isDrawing = false;
  String? _resultCharacter;
  bool _showResult = false;
  bool _isNewCharacter = false;
  bool _showCollection = false; // 성격 도감 표시 여부
  String? _selectedInCollection; // 도감에서 선택된 캐릭터 (확정 전)

  // UI 테스트용 보유 성격 목록 (임시 데이터)
  final Set<String> _collectedCharacters = {'playful', 'passionate'};

  // 목표 달성 점수 (이 점수에 도달하면 뽑기 가능)
  final int _targetMilestone = 300;
  // 이전 변수명인 _costPerGacha는 더 이상 사용하지 않지만, 로직 호환성을 위해 임시 유지하거나 삭제 후 코드 수정 필요
  // 여기서는 _targetMilestone으로 완전히 대체합니다.
  final List<Map<String, String>> _characterPool = [
    {
      'id': 'playful',
      'name': '장난꾸러기 아이',
      'image': 'assets/images/earth_zeroro.png',
    },
    {
      'id': 'rational',
      'name': '이성적인 연구원',
      'image': 'assets/images/cloud_zeroro.png',
    },
    {
      'id': 'passionate',
      'name': '열정적인 코치',
      'image': 'assets/images/earth_zeroro_magic.png',
    },
    {
      'id': 'noble',
      'name': '품격있는 귀족',
      'image': 'assets/images/cloud_zeroro_magic.png',
    },
    {
      'id': 'kind',
      'name': '친절한 선생님',
      'image': 'assets/images/earth_zeroro.png', // 임시 이미지
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(
      begin: 0,
      end: 10,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticIn));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startGacha() async {
    // UI 테스트용 로직: 실제 포인트 차감이나 유저 업데이트 로직은 제거됨
    // TODO: 추후 백엔드 연동 시 포인트 확인 및 차감 로직 구현 필요

    // 1. 뽑기 진행 (기기 애니메이션)
    setState(() {
      _isDrawing = true;
      _showResult = false;
    });

    // Shake animation sequence (기계 흔들기)
    await _controller.forward();
    await _controller.reverse();
    await _controller.forward();
    await _controller.reverse();

    // 2. 결과 계산 (UI 테스트용 랜덤 선택)
    final random = Random();
    final result = _characterPool[random.nextInt(_characterPool.length)];

    // UI 테스트를 위해 항상 새로운 캐릭터로 가정
    final isNew = true;

    if (mounted) {
      setState(() {
        _isDrawing = false;
        _showResult = true; // 결과 화면 표시
        _resultCharacter = result['id'];
        _isNewCharacter = isNew;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).currentUser;
    final currentPoints = user?.totalPoints ?? 400; // UI 테스트를 위해 400으로 설정

    // 메인 다이얼로그
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            SizedBox(
              height: _showResult ? null : 400,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _showCollection
                    ? _buildCollectionView()
                    : Column(
                        key: const ValueKey('gacha_view'),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 220,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              child: _showResult
                                  ? _buildResultView()
                                  : _buildGachaMachine(),
                            ),
                          ),
                          const SizedBox(height: 24),
                          if (!_showResult) ...[
                            _buildPointInfo(currentPoints),
                            const SizedBox(height: 24),
                            _buildDrawButton(currentPoints),
                          ] else
                            _buildResultActions(),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _showCollection ? '성격 도감' : '캐릭터 성격 뽑기',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        Row(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _showCollection = !_showCollection;
                    if (_showCollection) {
                      _showResult = false;
                    }
                  });
                },
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _showCollection
                        ? AppColors.primary
                        : Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.grid_view_rounded,
                    color: _showCollection
                        ? Colors.white
                        : AppColors.textSecondary,
                    size: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  if (_showCollection) {
                    setState(() {
                      _showCollection = false;
                      _selectedInCollection = null; // 선택 초기화
                    });
                  } else {
                    Navigator.pop(context);
                  }
                },
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
      ],
    );
  }

  Widget _buildCollectionView() {
    final currentEquipped = ref.watch(appSettingsProvider).selectedCharacter;

    return Column(
      key: const ValueKey('collection_view'),
      children: [
        Expanded(
          child: Scrollbar(
            thumbVisibility: true,
            child: GridView.builder(
              padding: const EdgeInsets.only(right: 12, bottom: 12),
              itemCount: _characterPool.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                final char = _characterPool[index];
                final isCollected = _collectedCharacters.contains(char['id']);
                final isEquipped = char['id'] == currentEquipped;
                final isSelected = char['id'] == _selectedInCollection;

                return _buildCollectionItem(
                  char,
                  isCollected,
                  isEquipped,
                  isSelected,
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildCollectionActions(),
      ],
    );
  }

  Widget _buildCollectionActions() {
    final hasSelection = _selectedInCollection != null;
    final currentEquipped = ref.read(appSettingsProvider).selectedCharacter;
    final isDifferent = _selectedInCollection != currentEquipped;

    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () {
              setState(() {
                _showCollection = false;
                _selectedInCollection = null;
              });
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              '취소',
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
              if (hasSelection && isDifferent) {
                ref
                    .read(appSettingsProvider.notifier)
                    .updateCharacter(_selectedInCollection!);
              }

              setState(() {
                _showCollection = false;
                _selectedInCollection = null;
              });

              ToastHelper.showSuccess('캐릭터 성격이 선택되었습니다.');
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCollectionItem(
    Map<String, String> char,
    bool isCollected,
    bool isEquipped,
    bool isSelected,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isCollected
            ? () {
                setState(() {
                  _selectedInCollection = char['id'];
                });
              }
            : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: isCollected ? Colors.white : Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : (isCollected
                        ? AppColors.primary.withValues(alpha: 0.3)
                        : Colors.transparent),
              width: isSelected ? 3 : 2,
            ),
            boxShadow: isCollected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCollected ? Colors.white : Colors.grey[300],
                      ),
                      child: ClipOval(
                        child: isCollected
                            ? Transform.translate(
                                offset:
                                    ['passionate', 'noble'].contains(char['id'])
                                    ? const Offset(-5, 0)
                                    : Offset.zero,
                                child: Image.asset(
                                  char['image']!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(
                                Icons.lock_rounded,
                                color: Colors.grey[400],
                                size: 32,
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      char['name']!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isCollected
                            ? AppColors.textPrimary
                            : Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (isEquipped)
                      const Text(
                        '착용 중',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    else if (isCollected)
                      Text(
                        '터치하여 선택',
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
              if (isEquipped)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPointInfo(int currentPoints) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '누적 포인트',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          Container(width: 1, height: 16, color: Colors.grey[300]),
          const SizedBox(width: 12),
          const Icon(
            Icons.monetization_on_rounded,
            color: Colors.amber,
            size: 20,
          ),
          const SizedBox(width: 6),
          Transform.translate(
            offset: const Offset(0, -1),
            child: Text(
              '$currentPoints P',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGachaMachine() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            _shakeAnimation.value * sin(_controller.value * pi * 4),
            0,
          ),
          child: Transform.scale(
            scale: _isDrawing ? _scaleAnimation.value : 1.0,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.05),
                    ),
                    child: const Icon(
                      Icons.card_giftcard_rounded,
                      size: 64,
                      color: AppColors.primary,
                    ),
                  ),
                  if (_isDrawing)
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: CircularProgressIndicator(
                        color: AppColors.primary.withValues(alpha: 0.5),
                        strokeWidth: 4,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawButton(int currentPoints) {
    final canDraw = currentPoints >= _targetMilestone;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isDrawing ? null : _startGacha,
        style: ElevatedButton.styleFrom(
          backgroundColor: canDraw ? AppColors.primary : Colors.grey[400],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: _isDrawing
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '성격 뽑기',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    canDraw
                        ? '누적 $_targetMilestone점 달성 보상!'
                        : '$_targetMilestone점 달성 시 오픈',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildResultView() {
    final character = _characterPool.firstWhere(
      (c) => c['id'] == _resultCharacter,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        Text(
          '축하합니다!',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          character['name']!,
          style: const TextStyle(
            fontSize: 22,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(scale: value, child: child);
            },
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withValues(alpha: 0.2),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                    border: Border.all(
                      color: Colors.amber.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: Transform.translate(
                      offset: ['passionate', 'noble'].contains(character['id'])
                          ? const Offset(-5, 0)
                          : Offset.zero,
                      child: Image.asset(
                        character['image']!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                if (_isNewCharacter)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Text(
                      'NEW!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultActions() {
    return Row(
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
              setState(() {
                _showResult = false;
                _resultCharacter = null;
                _isNewCharacter = false;
              });
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
              '다시 뽑기',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
