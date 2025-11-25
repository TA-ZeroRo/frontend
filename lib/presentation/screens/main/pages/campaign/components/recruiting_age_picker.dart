import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_color.dart';

class RecruitingAgePicker extends StatefulWidget {
  final int minAge;
  final int maxAge;
  final List<int> ageOptions;
  final ValueChanged<int> onMinAgeChanged;
  final ValueChanged<int> onMaxAgeChanged;

  const RecruitingAgePicker({
    super.key,
    required this.minAge,
    required this.maxAge,
    required this.ageOptions,
    required this.onMinAgeChanged,
    required this.onMaxAgeChanged,
  });

  @override
  State<RecruitingAgePicker> createState() => _RecruitingAgePickerState();
}

class _RecruitingAgePickerState extends State<RecruitingAgePicker> {
  late FixedExtentScrollController _minAgeScrollController;
  late FixedExtentScrollController _maxAgeScrollController;

  @override
  void initState() {
    super.initState();
    _minAgeScrollController = FixedExtentScrollController(
      initialItem: widget.ageOptions.indexOf(widget.minAge),
    );
    _maxAgeScrollController = FixedExtentScrollController(
      initialItem: widget.ageOptions.indexOf(widget.maxAge),
    );
  }

  @override
  void didUpdateWidget(covariant RecruitingAgePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 외부에서 값이 변경되었을 때 (예: 최소값이 올라가서 최대값이 강제로 변경된 경우) 스크롤 위치 동기화
    if (oldWidget.minAge != widget.minAge && _minAgeScrollController.hasClients) {
      final index = widget.ageOptions.indexOf(widget.minAge);
      if (_minAgeScrollController.selectedItem != index) {
        _minAgeScrollController.jumpToItem(index);
      }
    }
    if (oldWidget.maxAge != widget.maxAge && _maxAgeScrollController.hasClients) {
      final index = widget.ageOptions.indexOf(widget.maxAge);
      if (_maxAgeScrollController.selectedItem != index) {
        _maxAgeScrollController.jumpToItem(index);
      }
    }
  }

  @override
  void dispose() {
    _minAgeScrollController.dispose();
    _maxAgeScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                '최소 나이',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '최대 나이',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: Row(
              children: [
                // 최소 나이 피커
                Expanded(
                  child: CupertinoPicker(
                    scrollController: _minAgeScrollController,
                    itemExtent: 36,
                    onSelectedItemChanged: (index) {
                      final val = widget.ageOptions[index];
                      widget.onMinAgeChanged(val);
                    },
                    selectionOverlay: Container(
                      decoration: BoxDecoration(
                        border: Border.symmetric(
                          horizontal: BorderSide(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                    ),
                    children: widget.ageOptions
                        .map(
                          (age) => Center(
                            child: Text(
                              '$age대',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                // 구분선
                Container(
                  width: 1,
                  height: 80,
                  color: AppColors.textTertiary.withValues(alpha: 0.2),
                ),
                // 최대 나이 피커
                Expanded(
                  child: CupertinoPicker(
                    scrollController: _maxAgeScrollController,
                    itemExtent: 36,
                    onSelectedItemChanged: (index) {
                      final val = widget.ageOptions[index];
                      widget.onMaxAgeChanged(val);
                    },
                    selectionOverlay: Container(
                      decoration: BoxDecoration(
                        border: Border.symmetric(
                          horizontal: BorderSide(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                    ),
                    children: widget.ageOptions
                        .map(
                          (age) => Center(
                            child: Text(
                              '$age대',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

