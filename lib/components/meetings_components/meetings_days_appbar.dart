// Date Created :21/November/2023
// Developer Name : Mazen shabaan
//App Version : Version 2
// Date of Last Edit :21/November/2023
// Objectives: this is a widget to customize the app bar of the date selcted to show data in meetings screen
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/screen_size.dart';

class MeetingDaysAppBar extends StatefulWidget {
  const MeetingDaysAppBar({super.key});

  @override
  State<MeetingDaysAppBar> createState() => _MeetingDaysAppBarState();
}

class _MeetingDaysAppBarState extends State<MeetingDaysAppBar> {
  DateTime now = DateTime.now();
  late int day;
  @override
  void initState() {
    super.initState();
    day = now.day;
  }

  final HapticController hapticController = Get.put(HapticController());
  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                hapticController.triggerHapticFeedback(
                    vibration: VibrateType.lightImpact,
                    hapticFeedback: HapticFeedback.lightImpact);
                setState(() {
                  now = now.subtract(const Duration(days: 7));
                });
              },
              child: Transform.scale(
                scale: isPortrait ? 1.6 : 1.3,
                child: Transform.rotate(
                  angle: Get.locale.toString().contains('en') ? 0 : 3.12,
                  child: SvgPicture.asset(
                    "assets/images/arrow_left.svg",
                    // ignore: deprecated_member_use
                    color: Theme.of(context).colorScheme.scrim,
                  ),
                ),
              ),
            ),
            Text(
              "${now.day} ${DateFormat.MMM().format(now).tr} ${now.year}",
              style: AppFontStyle.cairoRegularStyle.copyWith(
                  fontSize: isPortrait
                      ? FontConstants.fontSize018.h
                      : FontConstants.fontSize016.w,
                  fontWeight: FontWeight.w600,
                  height:isPortrait?1.5: 0.002.h,
                  color: Theme.of(context).colorScheme.inverseSurface),
            ),
            GestureDetector(
              onTap: () {
                hapticController.triggerHapticFeedback(
                    vibration: VibrateType.lightImpact,
                    hapticFeedback: HapticFeedback.lightImpact);
                setState(() {
                  now = now.add(const Duration(days: 7));
                });
              },
              child: Transform.scale(
                  scale:isPortrait?1.6 :1.2,
                  child: Transform.rotate(
                      angle: Get.locale.toString().contains('en') ? 0 : 3.12,
                      child:
                          SvgPicture.asset("assets/images/right_circle.svg"))),
            ),
          ],
        ),
        RichText(
          text: TextSpan(
              text: "This".tr,
              style: AppFontStyle.cairoRegularStyle.copyWith(
                fontSize: FontConstants.fontSize026.w,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.scrim,
              ),
              children: [
                TextSpan(
                    text: "Week".tr,
                    style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: FontConstants.fontSize043.w,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ))
              ]),
        )
      ],
    );
  }
}
