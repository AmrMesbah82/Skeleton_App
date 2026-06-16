import 'package:demo_app/features/onboarding/presentation/ui/pages/onboarding.dart' hide themeController;
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';


import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/features/onboarding/authentication/welcome_screen/views/mobile_view/nav_bar.dart';

class MultipleChoiceItem extends StatelessWidget {
  MultipleChoiceItem({
    super.key,
    required this.isSelected,
    required this.label,
    required this.onTap,
  });
  bool isSelected;
  final String label;
  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(
            isSelected
                ? themeController.currentTheme == AppColors.lightTheme
                    ? 'assets/icons/checkedCheckBox.svg'
                    : 'assets/icons/checkBoxCheckedDark1.svg'
                : 'assets/icons/notCheckedCheckBox.svg',
            color: isSelected
                ? AppColors.lightPrimary
                : Theme.of(context).colorScheme.tertiaryContainer,
            height: isTablet ? (isPortrait ? 0.035.w : 0.02.w) : 0.025.h,
          ),
          SizedBox(
            width: 0.015.w,
          ),
          Text(label, //'Text Messages'.tr,
              style: AppFontStyle.cairoRegularStyle.copyWith(
                  fontSize: FontConstants.fontSize018.h,
                  height: isTablet ? null : 1.8,
                  color: isSelected
                      ? Theme.of(context).colorScheme.inverseSurface
                      : Theme.of(context).colorScheme.tertiaryContainer,
                  fontWeight: Get.locale.toString().contains('en')
                      ? FontWeight.w600
                      : FontWeight.w500))
        ],
      ),
    );
  }
}
