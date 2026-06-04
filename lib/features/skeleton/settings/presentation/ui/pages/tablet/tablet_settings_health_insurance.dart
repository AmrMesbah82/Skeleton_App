// ignore_for_file: must_be_immutable, prefer_const_declarations, unused_local_variable, deprecated_member_use, duplicate_ignore, no_leading_underscores_for_local_identifiers, unrelated_type_equality_checks, unrelated_type_equality_checks, sdk_version_since, use_build_context_synchronously

//import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app/core/widgets/navigation.dart';
import 'package:demo_app/core/widgets/shared_action_widgets.dart';
import 'package:demo_app/core/widgets/side_frame_master.dart';
import 'package:demo_app/features/external/main_core/core/theme/new_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/components/lib/phone_number.dart';

import 'package:demo_app/core/widgets/dialogs/response_dialog.dart';
import 'package:demo_app/components/tracking_time_components/track_time_subwidget/request_escalate_dialog.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/dummy_data/mode_changer.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/feature/controller/request_controller.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/inventory_module/core/navigate.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/knowledge_hub_module/core/responsive_side_frame.dart';
import 'package:demo_app/features/external/main_core/core/theme/app_colors.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/services_mangment_module/Category/presentation/ui/services_admin/Widget/W3_Frame_Screen_tablet.dart';
import 'package:demo_app/features/skeleton/settings/presentation/ui/pages/tablet/edit_health.dart';
import 'package:demo_app/features/skeleton/settings/presentation/ui/widgets/health_insurance_fields.dart';
import 'package:demo_app/features/skeleton/settings/presentation/ui/pages/settings_screen.dart';

import '../../../../../../../generated/l10n.dart';
// REMOVED_MODULE: import '../../../../../../external/inventory_module/core/custom_button_widget.dart';
// REMOVED_MODULE: import '../../../../../../external/services_mangment_module/core/new_theme.dart';

// Import the new edit page

String? section;
String? whatChanged;
String? insuranceName2;

final HapticController hapticController = Get.put(HapticController());

class TabletSettingsHealthInsurance extends StatefulWidget {
  const TabletSettingsHealthInsurance({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TabletSettingsHealthInsuranceState createState() =>
      _TabletSettingsHealthInsuranceState();
}

// Health Insurance text fields controllers

class _TabletSettingsHealthInsuranceState
    extends State<TabletSettingsHealthInsurance> {
  int selectedContainerIndex = 0;
  bool isEnglish = Get.locale.toString().contains('en');
  @override
  void initState() {
    section = null;
    whatChanged = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isMobile = context.isPhone;
    final orientation = MediaQuery.of(context).orientation;
    final HapticController hapticController = Get.put(HapticController());
    var lightMode = Theme.of(context).brightness == Brightness.light;

    return GetBuilder<RequestController>(
        init: Get.find<RequestController>(),
        builder: (requestController) {
          return  !isMobile ?  Column(

            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                height: 470.h,
                clipBehavior: Clip.antiAlias, // Add this line
                child: ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        Container(
                          decoration: isMobile ? BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(8),
                          ):BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HealthInsuranceFields(),
                            ],
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
                        // Navigate to the edit page
                        navigateTo(context, EditPageRequestHealth());
                      },
                      color: AppColors.primary,
                      width: 300.w,
                      height: 36.h,
                      textStyle: StyleText.fontSize16Weight500.copyWith(
                          color: ColorAppLight.buttonTextColor
                      ),
                      radius: 4.r,
                      image: 'assets/request_chnage.svg',
                      svgColor: ColorAppLight.buttonTextColor,

                      space: 8.w,
                      widthImage: 16.w,
                      heightImage: 23.h,
                      colorBorder: Colors.transparent
                  ),
                ],
              ),

              SizedBox(height: 15.sp),
            ],
          ): SideFrameMaster(
              titleText: S.of(context).settings,
              secondTitle: S.of(context).healthInsurance,

            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HealthInsuranceFields(),
                    ],
                  ),
                ),
                SizedBox(height: 15.h,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    customButtonWithImage(
                        title: 'Request to Change'.tr,
                        function: (){
                          // Navigate to the edit page
                          navigateTo(context, EditPageRequestHealth());
                        },
                        color: AppColors.primary,
                        width: isMobile ? 340.w : 300.w,
                        height: 36.h,
                        textStyle: StyleText.fontSize16Weight500.copyWith(
                            color: AppColors.textButton,
                        ),
                        radius: 4.r,
                        image: 'assets/request_chnage.svg',
                        svgColor: AppColors.textButton,

                        space: 8.w,
                        widthImage: 16.w,
                        heightImage: 23.h,
                        colorBorder: Colors.transparent
                    ),
                  ],
                ),

                SizedBox(height: 20.sp),
              ],
            ),
          );

        });
  }
}