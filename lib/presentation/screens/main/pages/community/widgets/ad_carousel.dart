import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_color.dart';
import '../../../../../../core/theme/app_text_style.dart';

class AdItem {
  final String title;
  final String description;
  final Gradient gradient;

  const AdItem({
    required this.title,
    required this.description,
    required this.gradient,
  });
}

class AdCarousel extends StatefulWidget {
  const AdCarousel({super.key});

  @override
  State<AdCarousel> createState() => _AdCarouselState();
}

class _AdCarouselState extends State<AdCarousel> {
  final PageController _pageController = PageController();
  Timer? _autoPlayTimer;
  double _currentPage = 0;

  final List<AdItem> _adList = const [
    AdItem(
      title: '환경 보호 캠페인',
      description: '지구를 지키는 작은 실천',
      gradient: LinearGradient(
        colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    AdItem(
      title: '제로 웨이스트 챌린지',
      description: '일회용품 없는 하루',
      gradient: LinearGradient(
        colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    AdItem(
      title: '플로깅 이벤트',
      description: '함께 걷고, 함께 줍고',
      gradient: LinearGradient(
        colors: [Color(0xFFFF9800), Color(0xFFF57C00)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageScroll);
    _startAutoPlay();
  }

  void _onPageScroll() {
    if (!mounted) return;
    final page = _pageController.page ?? 0;
    if (_currentPage != page) {
      setState(() => _currentPage = page);
    }
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;

      final nextPage = (_currentPage.round() + 1) % _adList.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.removeListener(_onPageScroll);
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildAdItem(AdItem ad) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: ad.gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ad.title,
              style: AppTextStyle.titleLarge.copyWith(
                color: AppColors.buttonTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              ad.description,
              style: AppTextStyle.bodyMedium.copyWith(
                color: AppColors.buttonTextColor.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_adList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          height: 100,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _adList.length,
            itemBuilder: (context, index) {
              return _buildAdItem(_adList[index]);
            },
          ),
        ),
        const SizedBox(height: 8),
        if (_adList.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _adList.asMap().entries.map((entry) {
              // 현재 페이지와의 거리를 계산하여 활성화 정도를 결정
              final distance = (_currentPage - entry.key).abs();
              final activation = (1 - distance).clamp(0.0, 1.0);

              // 너비를 부드럽게 전환 (8 ~ 28)
              final width = 8 + (28 - 8) * activation;

              return Container(
                width: width,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: activation > 0.5
                      ? AppColors.primaryGradient
                      : null,
                  color: activation > 0.5
                      ? null
                      : AppColors.textTertiary.withValues(alpha: 0.3),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
