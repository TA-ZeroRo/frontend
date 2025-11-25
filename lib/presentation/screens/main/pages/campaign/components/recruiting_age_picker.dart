import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_color.dart';

class RecruitingAgePicker extends StatefulWidget {
  final int minAge;
  final int maxAge;
  final bool isAny;
  final ValueChanged<int> onMinAgeChanged;
  final ValueChanged<int> onMaxAgeChanged;
  final ValueChanged<bool> onAnyChanged;

  const RecruitingAgePicker({
    super.key,
    required this.minAge,
    required this.maxAge,
    required this.isAny,
    required this.onMinAgeChanged,
    required this.onMaxAgeChanged,
    required this.onAnyChanged,
  });

  @override
  State<RecruitingAgePicker> createState() => _RecruitingAgePickerState();
}

class _RecruitingAgePickerState extends State<RecruitingAgePicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 슬라이더
          AbsorbPointer(
            absorbing: widget.isAny,
            child: Opacity(
              opacity: widget.isAny ? 0.5 : 1.0,
              child: Column(
                children: [
                  RangeSlider(
                    values: RangeValues(
                      widget.minAge.toDouble(),
                      widget.maxAge.toDouble(),
                    ),
                    min: 10,
                    max: 90,
                    divisions: 8,
                    labels: RangeLabels(
                      '${widget.minAge}대',
                      '${widget.maxAge}대',
                    ),
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.textTertiary.withValues(
                      alpha: 0.3,
                    ),
                    onChanged: (RangeValues values) {
                      // 10단위로 스냅핑된 값 전달
                      widget.onMinAgeChanged(values.start.round());
                      widget.onMaxAgeChanged(values.end.round());
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(9, (index) {
                        final age = 10 + (index * 10);
                        return Text(
                          '$age',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textTertiary,
                            fontWeight: FontWeight.w400,
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // 상관없음 체크박스
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  value: widget.isAny,
                  onChanged: (value) {
                    widget.onAnyChanged(value ?? false);
                  },
                  activeColor: AppColors.primary,
                  side: const BorderSide(
                    color: AppColors.textSubtle,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '상관없음',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: widget.isAny
                      ? AppColors.textPrimary
                      : AppColors.textSubtle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
