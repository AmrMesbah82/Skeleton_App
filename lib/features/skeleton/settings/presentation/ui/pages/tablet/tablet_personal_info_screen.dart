///***************************** FILE INFO ****************************/
/// Purpose: This file contains the tablet personal information screen Starting point.
/// Author: Mohamed Elrashidy
/// refactored at: 11/11/2024

import 'package:demo_app/core/widgets/navigation.dart';
import 'package:demo_app/core/widgets/shared_action_widgets.dart';
import 'package:demo_app/core/widgets/side_frame_master.dart';
import 'package:demo_app/features/external/main_core/core/theme/new_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/src/services/haptic_feedback.dart';
import 'package:demo_app/components/tracking_time_components/track_time_subwidget/request_escalate_dialog.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/dummy_data/mode_changer.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/feature/controller/request_controller.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/inventory_module/core/navigate.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/knowledge_hub_module/core/responsive_side_frame.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/services_mangment_module/core/custom_botton.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/services_mangment_module/core/custom_button_with_image.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/services_mangment_module/core/new_theme.dart';
import 'package:demo_app/features/skeleton/settings/presentation/ui/widgets/personal_information_fields.dart';

import '../../../../../../../core/enumeration/enum.dart';
import '../../../../../../../generated/l10n.dart';
import '../../../../../../external/main_core/core/theme/app_colors.dart';
// REMOVED_MODULE: import '../../../../../../external/services_mangment_module/Category/presentation/ui/services_admin/Widget/W3_Frame_Screen_tablet.dart';
import 'eeit_page_request.dart';

String? section;
String? whatChanged;

final HapticController hapticController = Get.put(HapticController());

class TabletPersonalInfoScreen extends StatefulWidget {
  const TabletPersonalInfoScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TabletPersonalInfoScreenState createState() =>
      _TabletPersonalInfoScreenState();
}

class _TabletPersonalInfoScreenState extends State<TabletPersonalInfoScreen> {
  int selectedContainerIndex = 0;
  bool isEnglish = Get.locale.toString().contains('en');
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isPhone = context.isPhone;
    var lightMode = Theme.of(context).brightness == Brightness.light;
    var isMobile = context.isPhone;
    final orientation = MediaQuery.of(context).orientation;
    return GetBuilder<RequestController>(
        init: Get.find<RequestController>(),
        builder: (requestController) {
          return !isMobile ?  Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 470.h,
                clipBehavior: Clip.antiAlias, // Add this line
                child: ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        // Fixed height container with internal scrolling
                        Container(
                          decoration: isMobile ? BoxDecoration(
                            color: AppColors.card,

                            borderRadius: BorderRadius.circular(8),
                          ): BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(8),
                          ) ,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [PersonalInformationFields()],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15.h,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customButtonWithImage(
                    title: 'Request to Change'.tr,
                    function: (){
                      hapticController.triggerHapticFeedback(
                          vibration: VibrateType.heavyImpact,
                          hapticFeedback: HapticFeedback.heavyImpact
                      );

                      print("triggerHapticFeedback Work");
                      navigateTo(context, EditPageRequest());
                    },
                    color: AppColors.primary,
                    width: 300.w,
                    height: 36.h,
                    textStyle: StyleText.fontSize16Weight500.copyWith(
                        color: ColorAppLight.buttonTextColor
                    ),
                    image: 'assets/request_chnage.svg',
                    radius: 4.r,
                    svgColor: ColorAppLight.buttonTextColor,
                    widthImage: 16,
                    heightImage: 23,
                  ),
                ],
              ),

             // isPhone ? SizedBox() : SizedBox(height: 16.h),
            ],
          ) :




          SideFrameMaster(
            secondTitle: S.of(context).personalInformation,
            titleText: S.of(context).settings,
            onFirstTap: (){
              Navigator.pop(context);
            },
            onSecondTap: (){
              Navigator.pop(context);
            },
            child: Column(
              children: [
                // Fixed height container with internal scrolling
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.card,

                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [PersonalInformationFields()],
                  ),
                ),

                SizedBox(height: 15.h,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    customButtonWithImage(
                      title: 'Request to Change'.tr,
                      function: (){
                        hapticController.triggerHapticFeedback(
                            vibration: VibrateType.mediumImpact,
                            hapticFeedback: HapticFeedback.mediumImpact
                        );
                        navigateTo(context, EditPageRequest());
                      },
                      color: AppColors.primary,
                      width: 340.w,
                      height: 36.h,
                      textStyle: StyleText.fontSize16Weight500.copyWith(
                          color: ColorAppLight.buttonTextColor
                      ),
                      image: 'assets/request_chnage.svg',
                      radius: 4.r,
                      svgColor: ColorAppLight.buttonTextColor,
                      widthImage: 16.w,
                      heightImage: 23.h,
                    ),
                  ],
                ),

                isPhone ? SizedBox() : SizedBox(height: 16.h),
              ],
            ),
          );
        });
  }
}