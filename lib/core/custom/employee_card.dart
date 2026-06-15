// Date: 3/3/2026
// Purpose: Pure UI card — zero logic, everything passed from outside

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:demo_app/core/widgets/custom_check_box.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/core/theme/app_text_styles.dart';

import '../theme/app_colors.dart';

class ProviderCard extends StatelessWidget {
  final String name;
  final String? subtitle1;
  final String? subtitle2;
  final String avatarAsset;     // pass the resolved asset path from outside
  final bool isSelected;
  final bool showCheckbox;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  const ProviderCard({
    super.key,
    required this.name,
    required this.avatarAsset,
    required this.isSelected,
    required this.onTap,
    this.subtitle1,
    this.subtitle2,
    this.showCheckbox = true,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: backgroundColor ?? AppColors.background,
              borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Avatar ──────────────────────────────────────────────────────
                CircleAvatar(
                  radius: 30.r,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: SvgPicture.asset(
                      avatarAsset,
                      fit: BoxFit.cover,
                      width: 40.sp,
                      height: 40.sp,
                    ),
                  ),
                ),

                SizedBox(width: 8.sp),

                // ── Text ────────────────────────────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        style: AppTextStyles.font13SecondaryBlackCairo
                            .copyWith(color: AppColors.text),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      if (subtitle1 != null && subtitle1!.isNotEmpty) ...[
                        SizedBox(height: 3.sp),
                        Text(
                          subtitle1!,
                          style: AppTextStyles.font10BlackCairoRegular
                              .copyWith(color: AppColors.secondaryText),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                      if (subtitle2 != null && subtitle2!.isNotEmpty) ...[
                        SizedBox(height: 3.sp),
                        Text(
                          subtitle2!,
                          style: AppTextStyles.font10BlackCairoRegular
                              .copyWith(color: AppColors.secondaryText),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ],
                  ),
                ),


              ],
            ),
          ),
          // ── Checkbox ────────────────────────────────────────────────────
          if (showCheckbox)
            Positioned(
              top: 10.sp,
              right: 10.sp,
              // left:   10.sp,
              child: CustomCheckBox(
                isSelected: isSelected,
                size: 20.sp,
                borderColor: AppColors.secondaryText,
              ),
            ),
        ],
      ),
    );
  }
}


// ─────────────────────────────────────────────────────────────────────────────
// HOW TO USE — you handle ALL logic outside, just pass strings
// ─────────────────────────────────────────────────────────────────────────────
//
// ProviderCard(
//   name: 'John Smith',
//   subtitle1: 'Engineering',
//   subtitle2: 'Senior Developer',
//   avatarAsset: 'assets/male.svg',
//   isSelected: isSelected,
//   onTap: () {},
// )