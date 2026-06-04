// Date Created :19/November/2023
// Developer Name : Mazen shabaan
//App Version : Version 2
// Date of Last Edit :21/November/2023
// Objectives: this is a widget to customize the views of the request a change dialog
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/custom_container.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';
import 'package:demo_app/core/widgets/custom_toggle.dart';
import 'package:demo_app/core/widgets/column_request_data.dart';
import 'package:demo_app/core/widgets/filters_appbar.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';

class RequestChangeDialog extends StatefulWidget {
  const RequestChangeDialog({super.key});

  @override
  State<RequestChangeDialog> createState() => _RequestChangeDialogState();
}

class _RequestChangeDialogState extends State<RequestChangeDialog> {
  String? section;
  TextEditingController toggleText = TextEditingController();
  final HapticController hapticController = Get.put(HapticController());
  @override
  Widget build(BuildContext context) {
        bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 0.25.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.02.w, vertical: 0.02.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const FiltersAppBar(
                  imageUrl: "assets/images/case_vertical.svg",
                  title: "Request to Change"),
              ColumnRequestData(
                title: "Section",
                isTextField: false,
                hint: "Section",
                isOptional: false,
                isExpanded: true,
                dropdownValue: section,
                dropWidth: isPortrait? 0.47.w:0.45.w,
                buttonWidth: double.infinity,
                dropDownValueState: (value) {
                  setState(() {
                    section = value;
                  });
                },
                dropDownItems: const ["Element1", "Element2"],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0.02.h),
                child: Text(
                  "What You Want to Change..?".tr,
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                    fontSize: FontConstants.fontSize020.h,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                ),
              ),
              CustomToggle(
                isExpanded: false,
                borded: true,
                horizontalMargin: false,
                onToggleChanged: () {},
                onExpand: () {},
                onCollapse: () {},
                textController: toggleText,
                fillColor: Theme.of(context).colorScheme.inversePrimary,
                sizeMultiplicationFactor: 0.6,
                showHint: true,
                hint: "Text Here".tr,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0.02.h),
                child: Custom_Container(
                    height: 0.055.h,
                    imageAddress: "assets/images/upload_pic.svg",
                    text: "Upload Attachment",
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    borderColor: MyThemeData.lightPrimary,
                    iconColor: MyThemeData.lightPrimary,
                    textColor: MyThemeData.lightPrimary),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MainCustomIconButton(
                    onPressed: section == null
                        ? () {}
                        : () {
                            hapticController.triggerHapticFeedback(
                                vibration: VibrateType.mediumImpact,
                                hapticFeedback: HapticFeedback.mediumImpact);
                            Navigator.pop(context);
                          },
                    buttonText: "Send Request".tr,

                    buttonStyle: section == null
                        ? ElevatedButton.styleFrom(
                            minimumSize: Size(0.12.w, 0.05.h),
                            backgroundColor: MyThemeData.GreyBack,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            )),
                          )
                        : ElevatedButton.styleFrom(
                            minimumSize: Size(0.12.w, 0.05.h),
                            backgroundColor: MyThemeData.signOut,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            )),
                          ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
