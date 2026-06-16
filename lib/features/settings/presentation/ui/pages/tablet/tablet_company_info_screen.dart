/// ************************ FILe INFO ********************************///
/// File Name: tablet_company_info_screen.dart
/// Author: Mohamed Elrashidy
/// refactored at:11/12/2024

import 'package:demo_app/core/widgets/custom_button_widget.dart';
import 'package:demo_app/core/widgets/side_frame_master.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:demo_app/core/dummy_data/mode_changer.dart';


import 'package:demo_app/core/theme/app_font_size.dart';
import 'package:demo_app/core/theme/app_colors.dart';
import 'package:demo_app/features/settings/presentation/controller/add_company_controller.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/shared_components/timeline_widget.dart';
import '../../../../../../core/enumeration/enum.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../../services_mangment_module/core/new_theme.dart';
import '../../widgets/company/company_branding_screen.dart';
import 'package:flutter/src/services/haptic_feedback.dart';

class TabletCompanyInfoScreen extends StatefulWidget {
  TabletCompanyInfoScreen({super.key});

  @override
  State<TabletCompanyInfoScreen> createState() =>
      _TabletCompanyInfoScreenState();
}

class _TabletCompanyInfoScreenState extends State<TabletCompanyInfoScreen> {
  CompanyController companyController = Get.find();

  @override
  Widget build(BuildContext context) {
    var isMobile = context.isPhone;
    var lightMode = Theme.of(context).brightness== Brightness.light;
    return isMobile ?
    SideFrameMasterServices(
      titleText: S.of(context).settings,
      secondTitle: S.of(context).brandingAndTheme,
      onSecondTap: (){
        Navigator.pop(context);
      },
      onFirstTap: (){
        Navigator.pop(context);
      },
      child: Column(
      children: [
        Container(
          height: isMobile ? null : 400.h,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: CompanyBrandingScreen(
            onChangedImageUrl: (value) {
              print('📸 TabletScreen - onChangedImageUrl: $value');
              companyController.imageUrl = value;
            },
            onChangedPrimaryColor: (Color value) {
              print('🎨 TabletScreen - onChangedPrimaryColor: $value');
              print('🎨 TabletScreen - Hex: 0x${value.value.toRadixString(16)}');
              companyController.primaryColor = value;
              print('🎨 TabletScreen - companyController.primaryColor is now: ${companyController.primaryColor}');
            },
            onChangedSecondaryColor: (Color value) {
              print('🖌️ TabletScreen - onChangedSecondaryColor: $value');
              print('🖌️ TabletScreen - Hex: 0x${value.value.toRadixString(16)}');
              companyController.secondaryColor = value;
              print('🖌️ TabletScreen - companyController.secondaryColor is now: ${companyController.secondaryColor}');
            },
            onChangedFontArabic: (String value) {
              print('📝 TabletScreen - onChangedFontArabic: $value');
              companyController.selectedArabicFont = value;
            },
            onChangedFontEnglish: (String value) {
              print('✍️ TabletScreen - onChangedFontEnglish: $value');
              companyController.selectedEnglishFont = value;
            },
          ),
        ),



        SizedBox(height: 10.h),
        customButton(
          title: 'Apply'.tr,
          width: isMobile ? 340.w : 300.w,
          height: 36.h,
          radius: 4.r,
          color: AppColors.primary,
          textStyle: StyleText.fontSize16Weight500.copyWith(
              color: AppColors.textButton
          ),
          function: () async {
            print('🔵 APPLY BUTTON PRESSED');
            print('🔵 companyController.primaryColor BEFORE update: ${companyController.primaryColor}');
            print('🔵 companyController.secondaryColor BEFORE update: ${companyController.secondaryColor}');
            print('🔵 companyController.company is null? ${companyController.company == null}');

            await companyController.updateCompanyModel();

            print('🔵 APPLY BUTTON - updateCompanyModel completed');
            setState(() {});
          },
        ),


      ],
    ),
    )
        : Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(

              decoration: BoxDecoration(
                color: lightMode ? AppColors.background : AppColors.chatBackground,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: SingleChildScrollView(
                child: CompanyBrandingScreen(
                  onChangedImageUrl: (value) {},
                  onChangedPrimaryColor: (Color value) {},
                  onChangedSecondaryColor: (Color value) {},
                  onChangedFontArabic: (String value) {},
                  onChangedFontEnglish: (String value) {},
                ),
              ),
            ),



            SizedBox(height: 10.h),
            customButton(
              title: 'Apply'.tr,
              width: isMobile ? 340.w : 300.w,
              height: 36.h,
              radius: 4.r,
              color: AppColors.primary,
              textStyle: StyleText.fontSize16Weight500.copyWith(
                  color: AppColors.textButton
              ),
              function: () async {
                hapticController.triggerHapticFeedback(
                    vibration: VibrateType.mediumImpact,
                    hapticFeedback: HapticFeedback.mediumImpact
                );
                await companyController.updateCompanyModel();
                setState(() {});
              },

            ),


          ],
        ),
      ),
    );
  }
}
