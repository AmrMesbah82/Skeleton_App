import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_button.dart';
import 'package:demo_app/components/meetings_components/timeline_widget.dart';
import 'package:demo_app/components/settings_components/custom_black_button.dart';
import 'package:demo_app/core/widgets/form_fields/profile_textfield.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';

class CustomRejectDialog extends StatefulWidget {
  final List<String> options;
  CustomRejectDialog({super.key, required this.options});

  @override
  State<CustomRejectDialog> createState() => _CustomRejectDialogState();
}

class _CustomRejectDialogState extends State<CustomRejectDialog> {
  TextEditingController description = TextEditingController();
  String? _selectedOption;
  bool _customMessageSelected = false;

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal:isTablet? ( isPortrait ? 0.17.w : 0.25.w) : 0.08.w,
      ),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          height: null,
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 0.02.w, vertical: 0.015.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 0.02.h),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: MyThemeData.colorWhiteDark,
                  ),
                  child: SvgPicture.asset(
                    "assets/images/rejected.svg",
                    height: 0.1.h,
                  ),
                ),
                SizedBox(
                  height: 0.02.h,
                ),
                Text(
                  "Rejecting Application".tr,
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: isPortrait
                          ? FontConstants.fontSize022.h
                          : FontConstants.fontSize035.h,
                      fontWeight: FontWeight.w600,
                       letterSpacing: Get.locale.toString().contains('en')
                                      ?  1.1 :null,
                      color: Theme.of(context).colorScheme.inverseSurface,
                      height: 1.4),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.01.h),
                  child: Text(
                    "Reject Application and Send Message?".tr,
                    style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: isPortrait
                          ? FontConstants.fontSize016.h
                          : FontConstants.fontSize029.h,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.scrim,
                    ),
                  ),
                ),
                SizedBox(
                  height:isTablet? ( isPortrait ? 0 : 0.02.h) : 0.01.h,
                ),
                Container(
                  height: 0.35.h,
                  child: ListView.builder(
padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: widget.options.length + 1,
                    itemBuilder: (context, index) {
                      if (index < widget.options.length) {
                        final option = widget.options[index];
                        return RadioListTile<String>(
                          title: Text(
                            option,
                            style: AppFontStyle.cairoRegularStyle.copyWith(
                                fontSize: isPortrait
                                    ? FontConstants.fontSize016.h
                                    : FontConstants.fontSize024.h,
                                fontWeight: FontWeight.w600,
                                 letterSpacing: Get.locale.toString().contains('en')
                                      ?  1.1 :null,
                                color:
                                    Theme.of(context).colorScheme.inverseSurface,
                                height: 1.6),
                          ),
                          value: option,
                          groupValue: _selectedOption,
                          activeColor:
                              Theme.of(context).colorScheme.inverseSurface,
                          onChanged: (value) {
                            setState(() {
                              _selectedOption = value;
                              _customMessageSelected = false;
                            });
                            print('Selected option: $value $index');
                          },
                        );
                      } else if (_customMessageSelected == true) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RadioListTile(
                              title: textfieled(
                                context,
                                (value) {},
                                (value) {},
                                'Text Here'.tr, // hintText
                                "",
                                null, // prefixIcon
                                controller: null,
                                isReadOnly: false,
                              ),
                              value: 'custom',
                              groupValue: _selectedOption,
                              activeColor:
                                  Theme.of(context).colorScheme.inverseSurface,
                              onChanged: (value) {
                                setState(() {
                                  _selectedOption = value;
                                  _customMessageSelected = true;
                                });
                              },
                            ),
                           
                          ],
                        );
                      }
                    },
                  ),
                ),
                if (_customMessageSelected == true && !isTablet)
                SizedBox(height: 0.02.h,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: !_customMessageSelected,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: isPortrait ? 0.02.h : 0.04.h),
                        child: CustomBlackButton(
                          buttonText: 'Create Custom Message'.tr,
                          onPressed: () {
                             hapticController.triggerHapticFeedback(
                                        vibration: VibrateType.lightImpact,
                                        hapticFeedback:
                                            HapticFeedback.lightImpact);
                            setState(() {
                              _selectedOption = 'custom';
                              _customMessageSelected = true;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: isPortrait ?  0.01.h : 0.02.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.04.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: MainCustomButton(
                          buttonColor: MyThemeData.colorWhiteDark,
                          buttonText: 'Cancel',
                          onPressed: () {
                             Navigator.of(context).pop();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 0.04.w,
                      ),
                      Expanded(
                        child: MainCustomButton(
                          buttonText: 'Send',
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
