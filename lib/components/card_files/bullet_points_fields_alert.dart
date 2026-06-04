//Date Created :28/September/2023
// Developer Name : Mazen shabaan
//App Version : Version tablet
// Date of Last Edit :2/October/2023 by mazen
// Objectives: this class  created to view the Bullet points fields that shown in the alerts i the card when you want to edit your bullet points
import 'package:demo_app/features/skeleton/onboarding/presentation/ui/pages/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/core/theme/theme_controller.dart';

// ignore: must_be_immutable
class BulletPointsFieldsAlert extends StatefulWidget {
  BulletPointsFieldsAlert(
      {super.key, this.bullet1, this.bullet2, this.bullet3});
  TextEditingController? bullet1;
  TextEditingController? bullet2;
  TextEditingController? bullet3;

  @override
  State<BulletPointsFieldsAlert> createState() =>
      _BulletPointsFieldsAlertState();
}

class _BulletPointsFieldsAlertState extends State<BulletPointsFieldsAlert> {
  TextEditingController bullet1 = TextEditingController();
  TextEditingController bullet2 = TextEditingController();
  TextEditingController bullet3 = TextEditingController();
  final HapticController hapticController = Get.put(HapticController());
  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    // ignore: non_constant_identifier_names
    Widget TextBulletFields(TextEditingController controller, String hits) {
      final ThemeController themeController = Get.put(ThemeController());
      final orientation = MediaQuery.of(context).orientation;
      return Padding(
        padding: EdgeInsets.symmetric(
            vertical: orientation == Orientation.portrait ? 0.001.h : 0.003.h),
        child: SizedBox(
          height: orientation == Orientation.portrait ? null : 0.065.h,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 0.007.h),
            child: TextFormField(
              controller: controller,
              onChanged: (value) {
                setState(() {});
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: AppFontStyle.cairoRegularStyle.copyWith(
                  fontSize: orientation == Orientation.portrait
                      ? FontConstants.fontSize016.h
                      : FontConstants.fontSize026.h,
                  // ignore: unrelated_type_equality_checks
                  color: themeController.currentTheme == MyThemeData.lightTheme
                      ? MyThemeData.colorBlack
                      : MyThemeData.colorWhite,
                  fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                filled: true,
                contentPadding: EdgeInsets.only(
                    top: isPortrait ? 0.02.h : 0.005.h,
                    bottom: isPortrait ? 0.01.h : 0.005.h,
                    left: Get.locale.toString().contains('en') ? 0.03.w : 0,
                    right: Get.locale.toString().contains('en') ? 0 : 0.03.w),
                focusColor: MyThemeData.textfieldColor,
                hoverColor: MyThemeData.textfieldColor,
                hintText: hits,
                counterText: '',
                prefixIconConstraints: BoxConstraints(
                  maxHeight: .035.h,
                  maxWidth: .06.h,
                ),
                hintStyle: AppFontStyle.cairoRegularStyle.copyWith(
                    fontSize: orientation == Orientation.portrait
                        ? FontConstants.fontSize016.h
                        : FontConstants.fontSize026.h,
                    color: MyThemeData.colorGrey,
                    fontWeight: FontWeight.w400,
                    height: orientation == Orientation.portrait
                        ? 0.0014.h
                        : 0.002.h),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                //
                // ignore: unrelated_type_equality_checks
                fillColor:
                    // ignore: unrelated_type_equality_checks
                    themeController.currentTheme == MyThemeData.lightTheme
                        ? const Color(0xFFF6F6F6)
                        : const Color(0xFF545454),
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.03.w),
      child: SizedBox(
        height: isPortrait == true
            ? isTablet
                ? 0.35.h
                : 0.4.h
            : 0.4.h,
        child: Column(
          children: [
            SizedBox(
              height: isPortrait == true
                  ? isTablet
                      ? 0.25.h
                      : 0.3.h
                  : 0.3.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 0.012.h),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/sharable.svg',
                          // ignore: deprecated_member_use
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                        ),
                        SizedBox(
                          width: 0.008.w,
                        ),
                        Text(
                          'Sharable Bullet Points'.tr,
                          style: AppFontStyle.cairoRegularStyle.copyWith(
                              fontSize: isPortrait
                                  ? FontConstants.fontSize018.h
                                  : FontConstants.fontSize028.h,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              height: isPortrait ? 0.0013.h : 0.0016.h,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  TextBulletFields(
                    bullet1,
                    'Shared Info Back Of Knowticed...'.tr,
                  ),
                  TextBulletFields(
                    bullet2,
                    'Shared Info Back Of Knowticed...'.tr,
                  ),
                  TextBulletFields(
                    bullet3,
                    'Shared Info Back Of Knowticed...'.tr,
                  ),
                ],
              ),
            ),
            MainCustomIconButton(
              onPressed: () {
                hapticController.triggerHapticFeedback(
                    vibration: VibrateType.heavyImpact,
                    hapticFeedback: HapticFeedback.heavyImpact);
                setState(() {
                  widget.bullet1!.text = bullet1.text;
                  widget.bullet2!.text = bullet2.text;
                  widget.bullet3!.text = bullet3.text;
                  Navigator.pop(context);
                });
              },
              buttonText: 'Update Sharable Points'.tr,
              buttonStyle: ElevatedButton.styleFrom(
                minimumSize:
                    Size(0.94.w, isPortrait == true ? 0.050.h : 0.060.h),
                backgroundColor: MyThemeData.signOut,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                  Radius.circular(6),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
