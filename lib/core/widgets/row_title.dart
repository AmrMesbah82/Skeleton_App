import 'package:demo_app/core/constants/image_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:demo_app/core/widgets/bread_scrum.dart';
import 'package:demo_app/features/external/main_core/core/theme/font_manager.dart';


Row titleRow(
    BuildContext context, bool orientation, String title, Function()? onTap,
    {bool hasArrow = true,
    bool scrum = false,
    List<String>? titles,
    List<Function()?>? functions}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      scrum == true
          ? const SizedBox.shrink()
          : hasArrow
              ? GestureDetector(
                  onTap: () {
                    onTap!();
                    // hapticController.triggerHapticFeedback(
                    //     vibration: VibrateType.lightImpact,
                    //     hapticFeedback: HapticFeedback.lightImpact);
                  },
                  child: Transform.rotate(
                    angle: Get.locale.toString().contains('ar') ? 3.13 : 0,
                    child: Transform.scale(
                      scale: orientation ? 0.0014.h : 0.0023.h,
                      child: SvgPicture.asset(
                        // ignore: deprecated_member_use
                        color: Theme.of(context).colorScheme.onInverseSurface,
                        ImagePaths.getImagePath(
                          context,
                          'back_icon',
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
      scrum == true
          ? const SizedBox.shrink()
          : hasArrow
              ? SizedBox(
                  width: 0.01.w,
                )
              : const SizedBox.shrink(),
      scrum == true
          ? BreadCrumbsComponent(
              titles: titles!,
              onTaps: functions!,
            )
          : Text(
              title.tr,
              style: AppFontStyle.cairoRegularStyle.copyWith(
                fontSize: orientation
                    ? FontConstants.fontSize023.h
                    : FontConstants.fontSize026.w,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1,
                height: 1.8,
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
            ),
    ],
  );
}
