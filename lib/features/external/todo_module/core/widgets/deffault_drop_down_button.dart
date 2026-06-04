import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/external/todo_module/core/constants/screen_size.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_colors.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_text_styles.dart';


class DefaultDropdown extends StatelessWidget {
  final bool enabled;
  final Function()? onOpened, onCanceled;
  final Widget child;
  final dynamic initialValue;
  final List<String> popupMenuItems;
  final Function(dynamic)? onSelected;
  final double? height, width;
  final bool noPadding;
  final bool haveConstraintsForMenu;

  const DefaultDropdown({
    super.key,
    required this.enabled,
    required this.child,
    required this.popupMenuItems,
    this.initialValue,
    this.onOpened,
    this.onCanceled,
    this.height,
    this.width,
    this.onSelected,
    this.noPadding = false,
    this.haveConstraintsForMenu = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? (context.isTablet ? 0.069.h : 0.056.h),
      width: width ?? double.infinity,
      padding: noPadding == true
          ? null
          : EdgeInsetsDirectional.only(
        start: 0.008.w,
      ),
      decoration: BoxDecoration(
        color: AppColors.field,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: Colors.transparent,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          highlightColor: AppColors.primary,
          splashColor: Colors.transparent,
        ),
        child: PopupMenuButton(
          enabled: enabled,
          onOpened: onOpened,
          onCanceled: onCanceled ?? onOpened,
          color: AppColors.grey,
          offset: const Offset(0, 0),
          initialValue: initialValue,
          constraints: haveConstraintsForMenu == true
              ? BoxConstraints(
              minWidth: width ?? (context.isTablet ? 0.250.w : 0.100.w),
              maxWidth: width ?? (context.isTablet ? 0.2.w : 0.1.w))
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: BorderSide.none,
          ),
          position: PopupMenuPosition.under,
          padding: EdgeInsets.zero,
          onSelected: onSelected,
          itemBuilder: (context) {
            return popupMenuItems.map(
                  (item) {
                return PopupMenuItem(
                  value: item,
                  child: Align(
                    alignment: AlignmentDirectional.bottomStart,
                    child: Text(
                      item.tr,
                      style: AppTextStyles.font12BlackCairoRegular,
                    ),
                  ),
                );
              },
            ).toList();
          },
          child: child,
        ),
      ),
    );
  }
}