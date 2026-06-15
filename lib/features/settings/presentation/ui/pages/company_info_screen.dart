// ignore_for_file: must_be_immutable, prefer_const_declarations, unused_local_variable, deprecated_member_use, duplicate_ignore, no_leading_underscores_for_local_identifiers, unrelated_type_equality_checks, unrelated_type_equality_checks

//import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:demo_app/features/onboarding/presentation/ui/pages/onboarding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app/core/widgets/custom_button_widget.dart';
import 'package:demo_app/core/theme/new_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/network/api_constants.dart';
import 'package:demo_app/core/widgets/custom_appbar_mobile.dart';
import 'package:demo_app/core/widgets/custom_upper_filter.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/widgets/loading.dart';
import 'package:demo_app/core/dummy_data/mode_changer.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/core/theme/theme_controller.dart';
import 'package:demo_app/core/theme/app_colors.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/services_mangment_module/core/new_theme.dart';
import 'package:demo_app/features/settings/presentation/controller/add_company_controller.dart';
import 'package:demo_app/features/settings/settings_screen/views/owner_screens/company_info_update_dialog/update_company_info_dialog.dart';
import 'package:demo_app/features/settings/presentation/ui/widgets/company/company_branding_screen.dart';
import 'package:demo_app/features/settings/presentation/ui/widgets/company/company_information_fields.dart';
import 'package:demo_app/features/settings/presentation/ui/pages/settings_screen.dart';
import 'package:page_transition/page_transition.dart';


final HapticController hapticController = Get.put(HapticController());

class CompanyInfoScreen extends StatefulWidget {
  final bool? isBranding;

  CompanyInfoScreen({super.key, this.isBranding = false});

  @override
  // ignore: library_private_types_in_public_api
  _CompanyInfoScreenState createState() => _CompanyInfoScreenState();
}

class _CompanyInfoScreenState extends State<CompanyInfoScreen> {
  bool isEnglish = Get.locale.toString().contains('en');

  @override
  void initState() {
    super.initState();
  }

  late String filterChoice;
  CompanyController companyController = Get.find();

  @override
  Widget build(BuildContext context) {
    var isMobile = context.isPhone;
    var lightMode = Theme.of(context).brightness == Brightness.light;
    final orientation = MediaQuery.of(context).orientation;
    final HapticController hapticController = Get.put(HapticController());
    final ThemeController themeController = Get.find();
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            //  height: 492.h,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 0.02.w, vertical: 0.01.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UpperFilters(
                    isSettingsPage: true,
                    filterTitles: [
                      'Company Information',
                      'Branding',
                    ],
                    selectedIndex: companyController.brandingSelectedIndex,
                    selectedIndexState: (value) {
                      setState(() {
                        companyController.brandingSelectedIndex = value;
                      });
                    },
                    selectedDepartmentState: (value) {
                      setState(
                        () {
                          filterChoice = value;
                        },
                      );
                    },
                  ),
                  if (companyController.brandingSelectedIndex == 0)
                    Column(
                      children: [

                        CompanyInformationFields()],
                    ),
                  if (companyController.brandingSelectedIndex == 1)
                    CompanyBrandingScreen(
                      onChangedImageUrl: (value) {},
                      onChangedPrimaryColor: (Color value) {
                        print(
                            'primary color is ${value.value.toRadixString(16)}');
                      },
                      onChangedSecondaryColor: (Color value) {},
                      onChangedFontArabic: (String value) {
                        print('arabic font isss $value');
                      },
                      onChangedFontEnglish: (String value) {},
                    ),
                ],
              ),
            ),
          ),

          customButton(
            title: companyController.brandingSelectedIndex == 0
                ? 'Update'.tr
                : "Apply".tr,
            function: () async {
              if (companyController.brandingSelectedIndex == 0) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const UpdateCompanyInfoDialog();
                  },
                );
              } else {
                showLoadingIndicator();
                if (companyController.imageUrl != null) {
                  companyController.company!.companyLogo!.companyLogo!
                      .add(companyController.imageUrl);
                  companyController.company!.companyLogo!.timestamps!
                      .add(Timestamp.now());
                }

                companyController.company!.status = 'active';
                if (companyController.primaryColor != null) {
                  companyController.company!.primaryColor!.primaryColor!.add(
                      '0x${companyController.primaryColor!.value.toRadixString(16)}');
                  companyController.company!.primaryColor!.timestamps!
                      .add(Timestamp.now());
                }

                if (companyController.secondaryColor != null) {
                  companyController.company!.secondaryColor!.secondaryColor!.add(
                      '0x${companyController.secondaryColor!.value.toRadixString(16)}');
                  companyController.company!.secondaryColor!.timestamps!
                      .add(Timestamp.now());
                }

                if (companyController.selectedEnglishFont != null) {
                  companyController.company!.englishFont!.englishFont!.add(
                      companyController.selectedEnglishFont!.toLowerCase());

                  companyController.company!.englishFont!.timestamps!
                      .add(Timestamp.now());
                }

                if (companyController.selectedArabicFont != null) {
                  companyController.company!.arabicFont!.arabicFont!
                      .add(companyController.selectedArabicFont!.toLowerCase());

                  companyController.company!.arabicFont!.timestamps!
                      .add(Timestamp.now());
                }

                await companyController.addCompany(
                  companyController.company!,
                  ApiConstants.baseUri.split('/').last,
                );

                await companyController.getCompany();
                themeController.updatePrimaryColor();
                themeController.updateSecondaryColor();
                themeController.updateFonts();
                setState(() {});
                print(
                    'rrrrrrrrrrr=${companyController.company!.primaryColor!.primaryColor!.last}');
                hideLoadingIndicator();
              }
            },
            width: isMobile ? 340.w : 300.w,
            height: 38.sp,
            color: AppColors.primary,
            textStyle: StyleText.fontSize22Weight700.copyWith(
              color: AppColors.textButton
            )
          )

          //  SizedBox(height: 0.02.h,),
        ],
      ),
    );
  }
}
