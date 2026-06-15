//Date Created :28/September/2023
// Developer Name : Mazen shabaan
//App Version : Version tablet
// Date of Last Edit :4/October/2023 by mazen
// Objectives: this class  created to Customize the row of user name and icon in the card widget

// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/card_files/edit_icon.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/features/settings/presentation/ui/pages/settings_screen.dart';
import 'package:demo_app/core/nav_bar_package.dart/functions.dart';
import 'package:demo_app/core/custom/33-custom_haptic.dart';

// ignore: must_be_immutable
class UserNameAndIcon extends StatefulWidget {
  UserNameAndIcon({
    super.key,
    required this.isCard,
    required this.isHorizontalCard,
    required this.cardHeight,
    required this.username,
    required this.cardHeight2,
  });
  bool isCard;
  bool isHorizontalCard;
  double cardHeight;
  final String username;
  double cardHeight2;

  @override
  State<UserNameAndIcon> createState() => _UserNameAndIconState();
}

class _UserNameAndIconState extends State<UserNameAndIcon> {
  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    return Row(
      mainAxisAlignment: widget.isCard == true
          ? widget.isHorizontalCard == true
              ? MainAxisAlignment.start
              : MainAxisAlignment.spaceBetween
          : MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: widget.isHorizontalCard == true
                  ? 0.03.h
                  : widget.isCard == false
                      ? widget.cardHeight == null
                          ? 0.02.h
                          : isTablet
                              ? 0.025.h
                              : 0.015.h
                      : 0.02.h), //4
          child: SizedBox(
            width: widget.isCard == true
                ? widget.isHorizontalCard == true
                    ? .145.w
                    : isTablet
                        ? .2.w
                        : .33.w
                : isPortrait == true
                    ? isTablet
                        ? .24.w
                        : 0.35.w
                    : .17.w,
            child: FittedBox(
              alignment: Get.locale.toString().contains('ar')
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Text(
                widget.username,
                style: AppFontStyle.cairoRegularStyle.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: widget.cardHeight == null
                        ? FontConstants.fontSize028.h
                        : FontConstants.fontSize032.h),
              ),
            ),
          ),
        ),
        widget.isCard == true
            ? EditIcon(
                cardHeight: widget.cardHeight2,
                isHorizontalCard: widget.isHorizontalCard,
                onTap: () {
                  hapticController.triggerHapticFeedback(
                      vibration: VibrateType.mediumImpact,
                      hapticFeedback: HapticFeedback.mediumImpact);
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    withNavBar: false,
                    screen: SettingsScreen(),
                  );
                },
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
