import 'package:flutter/material.dart';

// 외부에서 _SubCategory를 사용할 수 있도록 export
class SubCategory {
  final int id;
  final String name;
  final int mainIndex;
  const SubCategory({
    required this.id,
    required this.name,
    required this.mainIndex,
  });
}

class CategorySelector extends StatefulWidget {
  final ValueChanged<SubCategory> onSubCategorySelected;
  final VoidCallback onSuggestionTap;

  const CategorySelector({
    super.key,
    required this.onSubCategorySelected,
    required this.onSuggestionTap,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector>
    with TickerProviderStateMixin {
  bool _isCategoryExpanded = false;
  int? _selectedSubCategoryId;

  static const List<String> mainCategories = [
    '올바른 분리배출',
    '다회용품 사용',
    '자원 절약 및 재활용',
    '건의하기',
  ];

  static const List<SubCategory> subCategories = [
    // 올바른 분리배출 (0)
    SubCategory(id: 0, name: '페트병 라벨 제거', mainIndex: 0),
    SubCategory(id: 1, name: '택배 상자 테이프/송장 제거', mainIndex: 0),
    SubCategory(id: 2, name: '내용물이 비워진 우유갑/주스팩', mainIndex: 0),
    SubCategory(id: 3, name: '깨끗한 스티로폼 박스', mainIndex: 0),

    // 다회용품 사용 (1)
    SubCategory(id: 4, name: '카페/식당에서의 텀블러 사용', mainIndex: 1),
    SubCategory(id: 5, name: '다회용기(용기내) 포장', mainIndex: 1),
    SubCategory(id: 6, name: '장바구니 사용', mainIndex: 1),

    // 자원 절약 및 재활용 (2)
    SubCategory(id: 8, name: '전자영수증 발급 화면', mainIndex: 2),
    SubCategory(id: 9, name: '사용하지 않는 플러그 뽑기', mainIndex: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCategorySelector(),
        const SizedBox(height: 12),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _isCategoryExpanded
              ? _buildCategoryDropdown()
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    return GestureDetector(
      onTap: () => setState(() => _isCategoryExpanded = !_isCategoryExpanded),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6),
          color: Colors.grey.shade100,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.category, size: 18),
            const SizedBox(width: 8),
            Text(
              _selectedSubCategoryId != null
                  ? subCategories
                        .firstWhere((e) => e.id == _selectedSubCategoryId!)
                        .name
                  : '카테고리',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Icon(
              _isCategoryExpanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '카테고리 선택',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(mainCategories.length, (index) {
            final isSuggestion = index == 3;
            final subCats = subCategories
                .where((e) => e.mainIndex == index)
                .toList();

            return _buildCategorySection(
              title: mainCategories[index],
              index: index,
              isSuggestion: isSuggestion,
              subCategories: subCats,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCategorySection({
    required String title,
    required int index,
    required bool isSuggestion,
    required List<SubCategory> subCategories,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 메인 카테고리 헤더
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSuggestion ? Colors.orange.shade50 : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isSuggestion
                    ? Colors.orange.shade200
                    : Colors.blue.shade200,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isSuggestion
                      ? Icons.lightbulb_outline
                      : Icons.category_outlined,
                  size: 18,
                  color: isSuggestion
                      ? Colors.orange.shade700
                      : Colors.blue.shade700,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isSuggestion
                        ? Colors.orange.shade700
                        : Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ),

          // 서브 카테고리들 (가로 배치)
          if (!isSuggestion && subCategories.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: subCategories.map((sub) {
                final isSelected = _selectedSubCategoryId == sub.id;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedSubCategoryId = sub.id;
                      _isCategoryExpanded = false;
                    });
                    widget.onSubCategorySelected(sub);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.green.shade100
                          : Colors.grey.shade50,
                      border: Border.all(
                        color: isSelected
                            ? Colors.green.shade300
                            : Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      sub.name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w500
                            : FontWeight.normal,
                        color: isSelected
                            ? Colors.green.shade700
                            : Colors.black87,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],

          // 건의하기 버튼
          if (isSuggestion) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                widget.onSuggestionTap();
                setState(() => _isCategoryExpanded = false);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.orange.shade300),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.send, size: 16, color: Colors.orange.shade700),
                    const SizedBox(width: 4),
                    Text(
                      '새로운 아이디어 제안하기',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
