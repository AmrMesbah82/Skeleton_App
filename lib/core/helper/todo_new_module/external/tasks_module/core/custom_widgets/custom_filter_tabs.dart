import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:demo_app/core/helper/knowledge_hub_module/core/extension/responsive_extensions.dart';

import 'package:demo_app/generated/l10n.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';



class CustomFilterTabs extends StatelessWidget {
  const CustomFilterTabs({
    super.key,
    required this.isTablet,
    required this.counts,
    required this.selectedLabel,
    required this.onSelected,
  });

  final bool isTablet;
  final Map<String, int> counts;
  final String selectedLabel;
  final Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    var isMobile = context.isPhone;
    var lightMode = Theme.of(context).brightness == Brightness.light;
    final filters = [
      S.of(context).homeScreenAllTitle,
      S.of(context).toDo,
      S.of(context).done,
      S.of(context).overdue,
      S.of(context).scheduled,
      S.of(context).deleted,
    ];

    // ✅ Get text direction to determine alignment
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Align(
      // ✅ Changed: Use centerRight for RTL, centerLeft for LTR
      alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: isRTL,
        child: Row(
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          children: filters.map((label) {
            final isSelected = label == selectedLabel;
            final count = counts[label] ?? 0;

            return GestureDetector(
              onTap: () => onSelected(label),
              child: Row(
                children: [
                  Container(
                    width: isMobile ? 35 : 45,
                    height: isMobile ? 35 : 45,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.card,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Center(
                      child: Text(
                        '$count',
                        style: AppTextStyles.font18BlackMediumCairo.copyWith(
                            color: isSelected
                                ? AppColors.textButton
                                : AppColors.secondaryText
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Text(
                    '$label ',
                    style: AppTextStyles.font16BlackSemiBoldCairo.copyWith(
                        color: isSelected
                            ? AppColors.text
                            : AppColors.secondaryText
                    ),
                  ),
                  SizedBox(width: 15.w),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}