// ignore_for_file: must_be_immutable, prefer_const_declarations, unused_local_variable, deprecated_member_use, duplicate_ignore, no_leading_underscores_for_local_identifiers, unrelated_type_equality_checks, unrelated_type_equality_checks, sdk_version_since, use_build_context_synchronously

//import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:demo_app/core/shared_components/calender_package/src/models/calendar_date_picker2_config.dart';
import 'package:demo_app/core/shared_components/date_picker_class.dart';
import 'package:demo_app/core/widgets/custom_appbar_mobile.dart';
import 'package:demo_app/core/widgets/custom_drop_down_menu.dart';
import 'package:demo_app/core/widgets/country_picker_dialog.dart';
import 'package:demo_app/core/widgets/intl_phone_field.dart';
import 'package:demo_app/core/shared_components/phone_number.dart';
import 'package:demo_app/core/shared_components/custom_black_button.dart';
import 'package:demo_app/features/settings/settings_screen/views/custom_colored_container.dart';
import 'package:demo_app/core/shared_components/custom_icon_container.dart';
import 'package:demo_app/core/widgets/form_fields/profile_textfield.dart';
import 'package:demo_app/core/widgets/dialogs/response_dialog.dart';
import 'package:demo_app/core/shared_components/request_escalate_dialog.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/widgets/loading.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/constants/nationalities_list.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/core/helper/validator.dart';
import 'package:demo_app/features/requests/request_controller.dart';
import 'package:demo_app/features/settings/presentation/ui/pages/settings_screen.dart';
import 'package:demo_app/features/onboarding/presentation/ui/pages/onboarding.dart';
import 'package:url_launcher/url_launcher.dart';


String? section;
String? whatChanged;

final HapticController hapticController = Get.put(HapticController());

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

// personal information text fields controllers
TextEditingController firstName = TextEditingController();
TextEditingController lastName = TextEditingController();
TextEditingController birthDate = TextEditingController();
TextEditingController country = TextEditingController();
TextEditingController city = TextEditingController();
TextEditingController stateOrProvince = TextEditingController();
TextEditingController email = TextEditingController();
TextEditingController phone = TextEditingController();
TextEditingController streetAddress = TextEditingController();
TextEditingController code = TextEditingController();
String? firstName2;
String? middleName2;
String? lastName2;

String? email2;
PhoneNumber? phone2;
String? address2;
String? country2;
String? city2;
String? province2;

String? selectedGender;
String? selectedNationality;
String? selectedMaritalStatus;
String? birthDate2;
// Health Insurance text fields controllers
TextEditingController insuranceName = TextEditingController();
TextEditingController insurancePolice = TextEditingController();
TextEditingController insurancePhone = TextEditingController();
String? insuranceName2;
String? insurancePolice2;
PhoneNumber? insurancePhone2;

TextEditingController connectionName = TextEditingController();
TextEditingController connecntionContactRelation = TextEditingController();
TextEditingController connecntionPhone = TextEditingController();
String? connectionName2;
String? connectionMiddleName2;
String? connectionLastName2;
String? connecntionRelation2;
PhoneNumber? connecntionPhone2;
String? connecntionEmail2;
String? connecntionCountry2;
String? connecntionProvince2;
String? connecntionCity2;
String? connecntionAddress2;
String? connecntionPostalCode2;

String? educationCertificate2;
String? idPhoto2;
String? armyCertificate2;
String? drivingLicense2;
String? maritalCertificate2;
String? insuranceCard2;

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedContainerIndex = 0;
  bool isEnglish = Get.locale.toString().contains('en');
  @override
  void initState() {
    firstName2 = null;
    middleName2 = null;
    lastName2 = null;
    email2 = null;
    phone2 = null;
    address2 = null;
    country2 = null;
    city2 = null;
    connecntionPostalCode2 = null;
    province2 = null;
    selectedGender = null;
    selectedNationality = null;
    selectedMaritalStatus = null;
    birthDate2 = null;
    insuranceName2 = null;
    insurancePolice2 = null;
    insurancePhone2 = null;
    connectionName2 = null;
    connectionMiddleName2 = null;
    connecntionRelation2 = null;
    connecntionPhone2 = null;
    connecntionEmail2 = null;
    connecntionCountry2 = null;
    connecntionProvince2 = null;
    connecntionCity2 = null;
    connecntionAddress2 = null;
    educationCertificate2 = null;
    idPhoto2 = null;
    armyCertificate2 = null;
    drivingLicense2 = null;
    maritalCertificate2 = null;
    insuranceCard2 = null;
    section = null;
    whatChanged = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final HapticController hapticController = Get.put(HapticController());

    return MediaQuery.of(context).size.shortestSide > 600
        ? GetBuilder<RequestController>(
            init: Get.find<RequestController>(),
            builder: (requestController) {
              return Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 0.01.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomColoredContainer(
                              isSelected: selectedContainerIndex == 0,
                              labelText: 'Personal Info'.tr,
                              onTap: () {
                                setState(() {
                                  selectedContainerIndex = 0;
                                });
                              },
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(isEnglish ? 8 : 0),
                                bottomLeft: Radius.circular(isEnglish ? 8 : 0),
                                topRight: Radius.circular(!isEnglish ? 8 : 0),
                                bottomRight:
                                    Radius.circular(!isEnglish ? 8 : 0),
                              ),
                              horizontalPadding:
                                  Get.locale.toString().contains('en')
                                      ? 0.131.w
                                      : 0.085.w,
                            ),
                            CustomColoredContainer(
                              horizontalPadding:
                                  Get.locale.toString().contains('en')
                                      ? 0.2.h
                                      : 0.113.w,
                              isSelected: selectedContainerIndex == 1,
                              labelText: 'Health Insurance'.tr,
                              onTap: () {
                                setState(() {
                                  selectedContainerIndex = 1;
                                });
                              },
                            ),
                            CustomColoredContainer(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(!isEnglish ? 8 : 0),
                                bottomLeft: Radius.circular(!isEnglish ? 8 : 0),
                                topRight: Radius.circular(isEnglish ? 8 : 0),
                                bottomRight: Radius.circular(isEnglish ? 8 : 0),
                              ),
                              horizontalPadding:
                                  Get.locale.toString().contains('en')
                                      ? 0.24.h
                                      : 0.09.h,
                              isSelected: selectedContainerIndex == 2,
                              labelText: 'Additional Information'.tr,
                              onTap: () {
                                setState(() {
                                  selectedContainerIndex = 2;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: orientation == Orientation.portrait
                            ? 0.44.h
                            : 0.47.h,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 0.02.w, vertical: 0.01.w),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (selectedContainerIndex == 0)
                                  const PersonalInformationFields(),
                                if (selectedContainerIndex == 1)
                                  const HealthInsuranceFields(),
                                if (selectedContainerIndex == 2)
                                  const AdditionalFieldsContacts(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //  SizedBox(height: 0.02.h,),
                      Padding(
                        padding: Get.locale.toString().contains('ar')
                            ? (orientation == Orientation.portrait
                                ? EdgeInsets.only(
                                    top: 0.015.w,
                                    bottom: 0.0
                                        .h, // Use Arabic vertical value for bottom
                                  )
                                : EdgeInsets.only(
                                    top: 0.025
                                        .h, // Use Arabic horizontal value for top
                                    bottom: 0.0.w,
                                  ))
                            : EdgeInsets.only(
                                top: orientation == Orientation.portrait
                                    ? 0.02.w
                                    : 0.025.h,
                                bottom: orientation == Orientation.portrait
                                    ? 0.0
                                    : 0.0.h,
                              ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyThemeData.signOut,
                            padding: EdgeInsets.symmetric(
                              vertical: orientation == Orientation.portrait
                                  ? 0.01.h
                                  : 0.015.h,
                              horizontal: orientation == Orientation.portrait
                                  ? 0.11.w
                                  : 0.155.w,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: /*() async {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return RequestExcalateDialog(
                                  isSetting: true,
                                  title: "Request to Change",
                                  imageUrl: "assets/icons/reqToChange.svg",
                                  isExclate: false,
                                  onPressed: () async {
                                    print(
                                        'asdaaaff=$section 1223234$whatChanged');
                                    if (section != null &&
                                        whatChanged != null) {
                                      requestController
                                              .requestsModel.value.department =
                                          employee!
                                              .departmentid!.departmentId!.last!
                                              .trim();
                                      requestController.requestsModel.value
                                          .dateRequest = Timestamp.now();
                                      requestController
                                              .requestsModel.value.firstName =
                                          employee!
                                              .firstName!.firstNames!.last!;
                                      requestController
                                              .requestsModel.value.lastName =
                                          employee!.lastName!.lastNames!.last!;
                                      requestController
                                              .requestsModel.value.image =
                                          employee!.photo
                                              ?.photos?.lastOrNull;
                                      requestController.requestsModel.value
                                          .section = section!.toLowerCase();
                                      requestController
                                              .requestsModel.value.email =
                                          employee!.email!.emails!.last;
                                      requestController.requestsModel.value
                                          .whatChanged = whatChanged;
                                      requestController.requestsModel.value
                                          .status = 'pending';
                                      requestController.requestsModel.value
                                          .role = employee!.role!.role!.last!;
                                      requestController
                                              .requestsModel.value.requestId =
                                          '${employee!.firstName!.firstNames!.last!}_${employee!.lastName!.lastNames!.last!}_${DateTime.now()}';
                                      if (firstName2 != null) {
                                        requestController.requestsModel.value
                                                .currentData =
                                            employee!
                                                .firstName!.firstNames!.last!;
                                        requestController.requestsModel.value
                                            .newData = firstName2;
                                      }
                                      if (lastName2 != null) {
                                        requestController.requestsModel.value
                                                .currentData =
                                            employee!
                                                .lastName!.lastNames!.last!;
                                        requestController.requestsModel.value
                                            .newData = lastName2;
                                      }
                                      if (email2 != null) {
                                        requestController.requestsModel.value
                                            .newData = email2;
                                        requestController.requestsModel.value
                                                .currentData =
                                            employee!.email!.emails!.last;
                                      }
                                      if (phone2 != null) {
                                        requestController.requestsModel.value
                                            .newData = phone2!.completeNumber;
                                        requestController.requestsModel.value
                                                .currentData =
                                            employee!.mobilePhone?.phones?.lastOrNull;
                                      }
                                      if (address2 != null) {
                                        requestController.requestsModel.value
                                            .newData = address2;
                                        requestController.requestsModel.value
                                                .currentData =
                                            employee!
                                                .street?.street?.lastOrNull;
                                      }

                                      if (selectedGender != null) {
                                        requestController
                                                .requestsModel.value.newData =
                                            selectedGender?.toLowerCase();
                                        requestController.requestsModel.value
                                                .currentData =
                                            employee!
                                                .gender?.gender?.lastOrNull;
                                      }
                                      if (birthDate2 != null) {
                                        requestController.requestsModel.value
                                            .newData = birthDate2;
                                        requestController.requestsModel.value
                                                .currentData =
                                            employee!.birthDay?.birthDays
                                                ?.lastOrNull;
                                      }
                                      if (selectedMaritalStatus != null) {
                                        requestController
                                                .requestsModel.value.newData =
                                            selectedMaritalStatus
                                                ?.toLowerCase();
                                        requestController.requestsModel.value
                                                .currentData =
                                            employee!.maritalStatus
                                                ?.maritalStatus?.lastOrNull;
                                      }
                                      if (selectedNationality != null) {
                                        requestController
                                                .requestsModel.value.newData =
                                            selectedNationality?.toLowerCase();
                                        requestController.requestsModel.value
                                                .currentData =
                                            employee!.nationality?.nationality
                                                ?.lastOrNull;
                                      }

                                      if (insuranceName2 != null) {
                                        requestController.requestsModel.value
                                            .newData = insuranceName2;
                                        requestController.requestsModel.value
                                                .currentData =
                                            employee!.insuranceName
                                                ?.insuranceNames?.lastOrNull;
                                      }
                                      if (insurancePolice2 != null) {
                                        requestController.requestsModel.value
                                            .newData = insurancePolice2;
                                        requestController.requestsModel.value
                                                .currentData =
                                            employee!
                                                .insurancePoliceNumber
                                                ?.insurancePoliceNumber
                                                ?.lastOrNull;
                                      }
                                      if (insurancePhone2 != null) {
                                        requestController
                                                .requestsModel.value.newData =
                                            insurancePhone2!.completeNumber;
                                        requestController.requestsModel.value
                                                .currentData =
                                            employee!
                                                .insurancePhoneNumber
                                                ?.insurancePhoneNumber
                                                ?.lastOrNull;
                                      }
                                      if (connectionName2 != null) {
                                        requestController.requestsModel.value
                                            .newData = connectionName2;
                                        requestController.requestsModel.value
                                                .currentData =
                                            employee!.contactFirstName
                                                ?.contactFirstName?.lastOrNull;
                                      }
                                      if (connecntionRelation2 != null) {
                                        requestController.requestsModel.value
                                            .newData = connecntionRelation2;
                                        requestController.requestsModel.value
                                                .currentData =
                                            employee!.contactRelation
                                                ?.contactRelation?.lastOrNull;
                                      }
                                      if (connecntionPhone2 != null) {
                                        requestController
                                                .requestsModel.value.newData =
                                            connecntionPhone2!.completeNumber;
                                        requestController.requestsModel.value
                                                .currentData =
                                            employee!.contactNumber
                                                ?.contactNumber?.lastOrNull;
                                      }
                                      if (educationCertificate2 != null) {
                                        requestController.requestsModel.value
                                            .newData = educationCertificate2;
                                        requestController.requestsModel.value
                                                .currentData =
                                            employee!
                                                .educationCertificate
                                                ?.educationCertificate
                                                ?.lastOrNull;
                                      }
                                      if (idPhoto2 != null) {
                                        requestController.requestsModel.value
                                            .newData = idPhoto2;
                                        requestController.requestsModel.value
                                                .currentData =
                                            employee!
                                                .idPhoto?.idPhoto?.lastOrNull;
                                      }
                                      if (drivingLicense2 != null) {
                                        requestController.requestsModel.value
                                            .newData = drivingLicense2;
                                        requestController.requestsModel.value
                                                .currentData =
                                            employee!.drivingLicense
                                                ?.drivingLicense?.lastOrNull;
                                      }
                                      if (insuranceCard2 != null) {
                                        requestController.requestsModel.value
                                            .newData = insuranceCard2;
                                        requestController.requestsModel.value
                                                .currentData =
                                            employee!.insuranceCard
                                                ?.insuranceCard?.lastOrNull;
                                      }
                                      if (armyCertificate2 != null) {
                                        requestController.requestsModel.value
                                            .newData = armyCertificate2;
                                        requestController.requestsModel.value
                                                .currentData =
                                            employee!.armyCertificate
                                                ?.armyCertificate?.lastOrNull;
                                      }
                                      if (maritalCertificate2 != null) {
                                        requestController.requestsModel.value
                                            .newData = maritalCertificate2;
                                        requestController.requestsModel.value
                                                .currentData =
                                            employee!
                                                .maritalCertificate
                                                ?.maritalCertificate
                                                ?.lastOrNull;
                                      }

                                      await requestController.createRequest(
                                          requestController.requestsModel.value,
                                          requestController
                                              .requestsModel.value.requestId!);
                                    }

                                    Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const SuccessDialog(
                                          title: "Successful",
                                          subtitle:
                                              "You Successfully Sent This Request",
                                          lottieAsset:
                                              "assets/images/correct.json",
                                        );
                                      },
                                    );

                                    //setState(() {});
                                  },
                                );
                              },
                            );
                          }*/(){},
                          child: Text(
                            'Request to Change'.tr,
                            style: AppFontStyle.cairoRegularStyle.copyWith(
                              fontSize: orientation == Orientation.portrait
                                  ? FontConstants.fontSize020.h
                                  : FontConstants.fontSize025.h,
                              fontWeight: FontWeight.w500,
                              color: MyThemeData
                                  .colorWhite, //Theme.of(context).colorScheme.secondaryContainer,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            })
        : Scaffold(
            resizeToAvoidBottomInset: true,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBarMobile(
                  showIcon: true,
                  isHome: true,
                  showMoreIcon: false,
                  title: "Personal Information",
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 0.045.w, vertical: 0.01.w),
                      child: Column(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0.04.w, vertical: 0.01.h),
                                child: const PersonalInformationFields(),
                              )),
                          SizedBox(
                            height: 0.02.h,
                          ),
                          // Container(
                          //     decoration: BoxDecoration(
                          //       color: Theme.of(context)
                          //           .colorScheme
                          //           .inversePrimary,
                          //       borderRadius: BorderRadius.circular(8),
                          //     ),
                          //     child: Padding(
                          //       padding: EdgeInsets.symmetric(
                          //           horizontal: 0.04.w, vertical: 0.01.h),
                          //       child: const HealthInsuranceFields(),
                          //     )),
                          SizedBox(
                            height: 0.02.h,
                          ),
                          // Container(
                          //     decoration: BoxDecoration(
                          //       color: Theme.of(context)
                          //           .colorScheme
                          //           .inversePrimary,
                          //       borderRadius: BorderRadius.circular(8),
                          //     ),
                          //     child: Padding(
                          //       padding: EdgeInsets.symmetric(
                          //           horizontal: 0.04.w, vertical: 0.01.h),
                          //       child: const AdditionalFieldsContacts(),
                          //     )),
                          SizedBox(
                            height: 0.02.h,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyThemeData.signOut,
                              padding: EdgeInsets.symmetric(
                                vertical: orientation == Orientation.portrait
                                    ? 0.013.h
                                    : 0.015.h,
                                horizontal: orientation == Orientation.portrait
                                    ? 0.22.w
                                    : 0.155.w,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () {
                              hapticController.triggerHapticFeedback(
                                  vibration: VibrateType.heavyImpact,
                                  hapticFeedback: HapticFeedback.heavyImpact);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return RequestExcalateDialog(
                                    isSetting: true,
                                    title: "Request to Change",
                                    imageUrl: "assets/icons/reqToChange.svg",
                                    isExclate: false,
                                  );
                                },
                              );
                            },
                            child: Text(
                              'Request to Change'.tr,
                              style: TextStyle(
                                fontSize: FontConstants.fontSize022.h,

                                fontWeight: FontWeight.w500,
                                color: MyThemeData
                                    .colorBlack, //Theme.of(context).colorScheme.secondaryContainer,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 0.02.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}

/// Personal Information Fields

class PersonalInformationFields extends StatefulWidget {
  const PersonalInformationFields({super.key});

  @override
  State<PersonalInformationFields> createState() =>
      _PersonalInformationFieldsState();
}

class _PersonalInformationFieldsState extends State<PersonalInformationFields> {
  // Gender Drop down

  final List<String> gender = [
    'Male'.tr,
    'Female'.tr,
    'Rather Not Say'.tr,
  ];

  final List<String> maritalStatus = [
    "Single".tr,
    "Married".tr,
    "Divorced".tr,
    "Widowed".tr,
    "Separated".tr,
    "Engaged".tr
  ];

  @override
  Widget build(BuildContext context) {
    DateTime? selectedDate;
    List<DateTime?> rangeDatePickerValueWithDefaultValue = [];
    Future<void> _selectDate(BuildContext context) async {
      final List<DateTime?>? picked = await DatePicker().showDatePicker(
          context,
          rangeDatePickerValueWithDefaultValue,
          DateTime.now(),
          CalendarDatePicker2Type.single);

      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked[0];
          final DateFormat formatter = DateFormat('MM/dd/yyyy');
          String formattedDate = formatter.format(picked[0] as DateTime);

          birthDate.text = formattedDate;
          birthDate2 = formattedDate;
        });
      }
    }

    final orientation = MediaQuery.of(context).orientation;
    Color backColor = themeController.currentTheme == MyThemeData.lightTheme
        ? const Color(0xFFF6F6F6)
        : const Color(0xFF545454);

    Color buttonColor = themeController.currentTheme == MyThemeData.lightTheme
        ? const Color(0xFFF6F6F6)
        : const Color(0xFF545454);

    EdgeInsets dropdownPadding = EdgeInsets.symmetric(
      horizontal: orientation == Orientation.portrait ? 0.04.w : 0.01.w,
    );

    TextStyle dropDownTextStyle = AppFontStyle.cairoRegularStyle.copyWith(
      fontSize: orientation == Orientation.portrait
          ? FontConstants.fontSize016.h
          : FontConstants.fontSize023.h,
      color: MyThemeData.colorGrey,
      fontWeight: FontWeight.w400,
      height: orientation == Orientation.portrait ? 0.0014.h : 0.002.h,
    );

    double buttonWidth = MediaQuery.of(context).size.shortestSide > 600
        ? (orientation == Orientation.portrait ? 0.620.w : 0.850.h)
        : double.infinity;

    double dropdownWidth = MediaQuery.of(context).size.shortestSide > 600
        ? (orientation == Orientation.portrait ? 0.470.w : 0.390.h)
        : 0.820.w;

    double buttonHeight = MediaQuery.of(context).size.shortestSide > 600
        ? (orientation == Orientation.portrait ? 0.0 : 0.04.w)
        : 0.05.h;

    double? dropdownHeight =
        MediaQuery.of(context).size.shortestSide > 600 ? null : 0.2.h;

    EdgeInsets? itemPadding = MediaQuery.of(context).size.shortestSide > 600
        ? null
        : EdgeInsets.symmetric(vertical: 0.01.h);

    selectedGender != null
        ? selectedGender = selectedGender!.tr
        : selectedGender = null;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 0.012.h),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/PersonalCardBlack.svg',
                  height: MediaQuery.of(context).size.shortestSide > 600
                      ? null
                      : 0.03.h,
                  // ignore: deprecated_member_use
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.shortestSide > 600
                      ? 0.008.w
                      : 0.03.w,
                ),
                Text(
                  'Personal Information'.tr,
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: MediaQuery.of(context).size.shortestSide > 600
                          ? (orientation == Orientation.portrait
                              ? FontConstants.fontSize018.h
                              : FontConstants.fontSize028.h)
                          : FontConstants.fontSize020.h,
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      height: MediaQuery.of(context).size.shortestSide > 600
                          ? (orientation == Orientation.portrait
                              ? 0.0013.h
                              : 0.0016.h)
                          : 0.002.h,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          SizedBox(
            height:
                MediaQuery.of(context).size.shortestSide > 600 ? 0 : 0.005.h,
          ),
          // Divider(
          //   color: Color(0xFF959090),
          //   thickness: 0.0004.h,
          // ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          right:
                              Get.locale.toString().contains('en') ? 0.02.h : 0,
                          left: Get.locale.toString().contains('ar')
                              ? 0.02.h
                              : 0),
                      child: textfieled(
                        context,
                        (value) {
                          firstName2 = value.trim().toLowerCase();
                        },
                        (value) {
                          return Validator.name(
                            value,
                            Get.locale.toString().contains('en')
                                ? "Invalid First Name"
                                : "الاسم الأول غير صالح",
                          );
                        },
                        'Enter Your First Name'.tr, // hintText
                        capitalize('${employee!.firstName!.last}'),
                        //  null,
                        null, // prefixIcon
                        controller: null,
                        isReadOnly: false,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          right:
                              Get.locale.toString().contains('en') ? 0.02.h : 0,
                          left: Get.locale.toString().contains('ar')
                              ? 0.02.h
                              : 0),
                      child: textfieled(
                        context,
                        (value) {
                          middleName2 = value.trim().toLowerCase();
                        },
                        (value) {
                          return Validator.name(
                              value,
                              Get.locale.toString().contains('en')
                                  ? "Invalid Middle Name"
                                  : "الاسم الاوسط غير صالح");
                        },
                        'Enter Your Middle Name'.tr, // hintText
                        capitalize('${employee!.middleName!.last}'),
                        null, // prefixIcon
                        controller: null,
                        isReadOnly: false,
                      ),
                    ),
                  ),
                  Expanded(
                    child: textfieled(
                      context,
                      (value) {
                        lastName2 = value.trim().toLowerCase();
                      },
                      (value) {
                        return Validator.name(
                            value,
                            Get.locale.toString().contains('en')
                                ? "Invalid Last Name"
                                : "اسم العائلة غير صالح");
                      },
                      'Enter Your Last Name'.tr, // hintText
                      capitalize('${employee!.lastName!.last}'),
                      null, // prefixIcon
                      controller: null,
                      isReadOnly: false,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          right:
                              Get.locale.toString().contains('en') ? 0.02.h : 0,
                          left: Get.locale.toString().contains('ar')
                              ? 0.02.h
                              : 0),
                      child: CustomDropdownButton2(
                       
                        dropdownPadding: dropdownPadding,
                        dropDownTextStyle: dropDownTextStyle,
     
                        buttonWidth: buttonWidth,
                        dropdownWidth: dropdownWidth,
                        buttonHeight: buttonHeight,
                        dropdownHeight: dropdownHeight,
                        itemPadding: itemPadding,
                        hint: 'Nationality'.tr,
                        borded: true,
                        dropdownItems: nationality,
                        buttonPadding: EdgeInsets.symmetric(
                            horizontal: orientation == Orientation.landscape
                                ? 0.022.h
                                : 0.015.h),
                        value: selectedNationality == null &&
                                employee!
                                        .nationality?.lastOrNull !=
                                    null
                            ? capitalize(employee!
                                        .nationality?.lastOrNull ??
                                    '')
                                .tr
                            : selectedNationality?.tr,
                        onChanged: (value) {
                          setState(() {
                            selectedNationality = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: textfieled(
                      isReadOnly: false,
                      context,
                      (value) async {
                        await _selectDate(context);
                      },
                      (value) {
                        return Validator.date(value);
                      },
                      'Enter Your Birth Date'.tr,
                      birthDate.text.isEmpty
                          ? employee!.birthDay?.lastOrNull
                          : birthDate.text,
                      null,
                      controller: null,
                      suffixIcon: InkWell(
                        onTap: () {
                          _selectDate(context);
                          hapticController.triggerHapticFeedback(
                              vibration: VibrateType.lightImpact,
                              hapticFeedback: HapticFeedback.lightImpact);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: Get.locale.toString().contains('en')
                                  ? 0.022.h
                                  : 0,
                              left: Get.locale.toString().contains('ar')
                                  ? 0.022.h
                                  : 0,
                              top: 0.012.h,
                              bottom: 0.012.h),
                          child: Image.asset(
                            'assets/images/calendar.png',
                            color: themeController.currentTheme ==
                                    MyThemeData.lightTheme
                                ? MyThemeData.colorBlack
                                : MyThemeData.colorWhite,
                            height: 0.022.h,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 6,
                          right:
                              Get.locale.toString().contains('en') ? 0.02.h : 0,
                          left: Get.locale.toString().contains('ar')
                              ? 0.02.h
                              : 0),
                      child: CustomDropdownButton2(
                   
                        dropdownPadding: dropdownPadding,
                        dropDownTextStyle: dropDownTextStyle,
                        buttonWidth: buttonWidth,
                        dropdownWidth: dropdownWidth,
                        buttonHeight: buttonHeight,
                        dropdownHeight: dropdownHeight,
                        itemPadding: itemPadding,
                        hint: 'Select Gender'.tr,
                        borded: true,
                        dropdownItems: gender,
                        buttonPadding: EdgeInsets.symmetric(
                            horizontal: orientation == Orientation.landscape
                                ? 0.022.h
                                : 0.015.h),
                        value: selectedGender == null &&
                                employee!.gender?.lastOrNull != null
                            ? capitalize(
                                employee!.gender?.lastOrNull ?? '')
                            : selectedGender.toString().tr,
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: CustomDropdownButton2(
                  
                      dropdownPadding: dropdownPadding,
                      dropDownTextStyle: dropDownTextStyle,
        
                      buttonWidth: buttonWidth,
                      dropdownWidth: dropdownWidth,
                      buttonHeight: buttonHeight,
                      dropdownHeight: dropdownHeight,
                      itemPadding: itemPadding,
                      hint: 'Marital Status'.tr,
                      borded: true,
                      dropdownItems: maritalStatus,
                      buttonPadding: EdgeInsets.symmetric(
                          horizontal: orientation == Orientation.landscape
                              ? 0.022.h
                              : 0.015.h),
                      value: selectedMaritalStatus == null &&
                              employee!.maritalStatus
                                      ?.lastOrNull !=
                                  null
                          ? capitalize(employee!
                                  .maritalStatus?.lastOrNull ??
                              '')
                          : capitalize(selectedMaritalStatus!.tr),
                      onChanged: (value) {
                        setState(() {
                          selectedMaritalStatus = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 6,
                          right:
                              Get.locale.toString().contains('en') ? 0.02.h : 0,
                          left: Get.locale.toString().contains('ar')
                              ? 0.02.h
                              : 0),
                      child: IntlPhoneField(
                        textAlign: TextAlign.start,
                        // autovalidateMode: AutovalidateMode.always,
                        pickerDialogStyle: PickerDialogStyle(
                            searchFieldInputDecoration: InputDecoration(
                              enabled: true,
                              hintText: 'search',
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.scrim,
                                    width: 1.0,
                                  )),
                              fillColor:
                                  Theme.of(context).colorScheme.inversePrimary,
                              hintStyle: TextStyle(
                                fontSize: FontConstants.fontSize020.h,
                                fontWeight: FontWeight.w400,
                                color: themeController.currentTheme ==
                                        MyThemeData.lightTheme
                                    ? Theme.of(context).colorScheme.scrim
                                    : MyThemeData.colorWhite,
                              ),
                            ),
                            width: .45.w,
                            backgroundColor: Colors.white,
                            countryCodeStyle: TextStyle(
                              fontSize: FontConstants.fontSize020.h,
                              fontWeight: FontWeight.w400,
                              color: themeController.currentTheme ==
                                      MyThemeData.lightTheme
                                  ? MyThemeData.colorBlack
                                  : MyThemeData.colorWhite,
                            ),
                            countryNameStyle: TextStyle(
                              fontSize: FontConstants.fontSize020.h,
                              fontWeight: FontWeight.w400,
                              color: themeController.currentTheme ==
                                      MyThemeData.lightTheme
                                  ? MyThemeData.colorBlack
                                  : MyThemeData.colorWhite,
                            )),
                        flagsButtonPadding: const EdgeInsets.only(left: 5),
                        showDropdownIcon: false,
                        disableLengthCheck: true,
                        style: AppFontStyle.cairoRegularStyle.copyWith(
                            fontSize: FontConstants.fontSize020.h,
                            color: themeController.currentTheme ==
                                    MyThemeData.lightTheme
                                ? MyThemeData.colorBlack
                                : MyThemeData.colorWhite,
                            fontWeight: FontWeight.w400),
                        dropdownTextStyle: AppFontStyle.cairoRegularStyle
                            .copyWith(
                                fontSize: FontConstants.fontSize020.h,
                                color: themeController.currentTheme ==
                                        MyThemeData.lightTheme
                                    ? MyThemeData.colorBlack
                                    : MyThemeData.colorWhite,
                                fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          filled: true,
                          contentPadding: Get.locale.toString().contains('en')
                              ? const EdgeInsets.only(left: 10, top: 10)
                              : const EdgeInsets.only(right: 10, top: 10),
                          focusColor: const Color.fromRGBO(246, 246, 246, 1),
                          hoverColor: const Color.fromRGBO(246, 246, 246, 1),
                          hintText: 'Enter The Phone Number'.tr,
                          prefix: const SizedBox(
                            height: 12,
                          ),
                          hintStyle: AppFontStyle.cairoRegularStyle.copyWith(
                              fontSize: FontConstants.fontSize020.h,
                              height: 2.6,
                              color: MyThemeData.colorGrey,
                              fontWeight: FontWeight.w400),
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
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          fillColor: themeController.currentTheme ==
                                  MyThemeData.lightTheme
                              ? const Color(0xFFF6F6F6)
                              : const Color(0xFF545454),
                        ),
                        onCountryChanged: (value) {},
                        initialCountryCode:
                            "${employee!.mobilePhone?.lastOrNull}",
                        initialValue: "$employee!.mobilePhone?.lastOrNull}",
                        onChanged: (value) {
                          print('countryISOCode ${value.countryISOCode}');
                          print('number ${value.number}');
                          print('countryCode ${value.countryCode}');
                          print('completeNumber ${value.completeNumber}');
                          phone2 = value;
                        },
                        validator: (value) {
                          return Validator.number(value!.completeNumber);
                        },
                      ),
                      //  textfieled(
                      //   context,
                      //   (value) {
                      //     phone2 = value.trim();
                      //   },
                      //   (value) {
                      //     return Validator.number(value!);
                      //   },
                      //   'Enter Your Phone'.tr, // hintText
                      //   employee!.phone?.phones?.lastOrNull,
                      //   null, // prefixIcon
                      //   controller: null,
                      //   isReadOnly: false,
                      // ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 0),
                      child: textfieled(
                        context,
                        (value) {
                          email2 = value.trim();
                        },
                        (value) {
                          return Validator.email(value);
                        },
                        'Enter Your Email'.tr, // hintText
                        employee!.email!.last,
                        null, // prefixIcon
                        controller: null,
                        isReadOnly: false,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          right:
                              Get.locale.toString().contains('en') ? 0.02.h : 0,
                          left: Get.locale.toString().contains('ar')
                              ? 0.02.h
                              : 0),
                      child: Stack(
                        children: [
                          textfieled(
                            context,
                            (value) async {
                              country2 = value.toLowerCase();
                            },
                            (value) {
                              return Validator.text(
                                  value,
                                  Get.locale.toString().contains('en')
                                      ? "Invalid Country"
                                      : "عنوان الدولة غير صحيح");
                            },
                            'Enter Your Country'.tr,
                            capitalize(
                                '${employee!.country?.lastOrNull}'),
                            null, // prefixIcon
                            controller: null,
                            isReadOnly: false,
                          ),
                          InkWell(
                              onTap: (() async {
                                setState(() {
                                  //    showLoadingIndicator();
                                });
                                //    address = await getUserLocation();
                                setState(() {
                                  //      hideLoadingIndicator();
                                });

                                //    country = address?.country;
                              }),
                              child: Container(
                                width: double.infinity,
                                height: 46,
                                color: Colors.transparent,
                              )),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        textfieled(
                          context,
                          (value) async {
                            city2 = value.toLowerCase();
                          },
                          (value) {
                            return Validator.text(
                                value,
                                Get.locale.toString().contains('en')
                                    ? "Invalid City"
                                    : "عنوان المدينه غير صحيح");
                          },
                          'Enter Your City'.tr,
                          capitalize('${employee!.city?.lastOrNull}'),
                          null, // prefixIcon
                          controller: null,
                          isReadOnly: false,
                        ),
                        InkWell(
                            onTap: (() async {
                              setState(() {
                                //    showLoadingIndicator();
                              });
                              //    address = await getUserLocation();
                              setState(() {
                                //      hideLoadingIndicator();
                              });
                              //     city = address?.subAdministrativeArea;
                            }),
                            child: Container(
                              width: double.infinity,
                              height: 46,
                              color: Colors.transparent,
                            )),
                        textfieled(
                          context,
                          (value) async {
                            province2 = value.toLowerCase();
                          },
                          (value) {
                            return Validator.text(
                                value,
                                Get.locale.toString().contains('en')
                                    ? "Invalid Province"
                                    : "عنوان الحي غير صحيح");
                          },
                          'Enter Your State Or Province'.tr,
                          capitalize(
                              '${employee!.province?.lastOrNull}'),
                          null,
                          controller: null,
                          isReadOnly: false,
                        ),
                        InkWell(
                            onTap: (() async {
                              setState(() {
                                //     showLoadingIndicator();
                              });
                              //    address = await getUserLocation();
                              setState(() {
                                //      hideLoadingIndicator();
                              });

                              //     state = address!.administrativeArea;
                            }),
                            child: Container(
                              width: double.infinity,
                              height: 46,
                              color: Colors.transparent,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          right:
                              Get.locale.toString().contains('en') ? 0.02.h : 0,
                          left: Get.locale.toString().contains('ar')
                              ? 0.02.h
                              : 0),
                      child: Stack(
                        children: [
                          textfieled(
                            context,
                            (value) async {
                              city2 = value.toLowerCase();
                            },
                            (value) {
                              return Validator.text(
                                  value,
                                  Get.locale.toString().contains('en')
                                      ? "Invalid City"
                                      : "عنوان المدينه غير صحيح");
                            },
                            'Enter Your City'.tr,
                            // (address != null
                            //         ? address!.subAdministrativeArea
                            //         : widget.userProfile.city!.cities!.lastOrNull !=
                            //                 null
                            //             ? capitalize(
                            //                 '${widget.userProfile.city!.cities!.lastOrNull}')
                            //             : widget
                            //                 .userProfile.city!.cities!.lastOrNull) ??
                            capitalize('${employee!.city?.lastOrNull}'),
                            null, // prefixIcon
                            controller: null,
                            isReadOnly: false,
                          ),
                          InkWell(
                              onTap: (() async {
                                setState(() {
                                  //    showLoadingIndicator();
                                });
                                //    address = await getUserLocation();
                                setState(() {
                                  //      hideLoadingIndicator();
                                });
                                //     city = address?.subAdministrativeArea;
                              }),
                              child: Container(
                                width: double.infinity,
                                height: 46,
                                color: Colors.transparent,
                              )),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: textfieled(
                      context,
                      (value) {
                        address2 = value.toLowerCase();
                      },
                      (value) {
                        return Validator.text(
                            value,
                            Get.locale.toString().contains('en')
                                ? "Invalid Street Address"
                                : "عنوان الشارع غير صحيح");
                      },
                      'Enter Your Street Address'.tr, // hintText
                      capitalize('${employee!.street?.lastOrNull}'),
                      null, // prefixIcon
                      controller: null,
                      isReadOnly: false,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 0.01.h,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Health Insurance Fields

class HealthInsuranceFields extends StatefulWidget {
  const HealthInsuranceFields({super.key});

  @override
  State<HealthInsuranceFields> createState() => _HealthInsuranceFieldsState();
}

class _HealthInsuranceFieldsState extends State<HealthInsuranceFields> {
  String? selectedContact;

  final List<String> contact = [];

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return /*Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 0.012.h),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/Hospital.svg',
                // ignore: deprecated_member_use
                height: MediaQuery.of(context).size.shortestSide > 600
                    ? null
                    : 0.03.h,
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.shortestSide > 600
                    ? 0.008.w
                    : 0.03.w,
              ),
              Text(
                'Health Insurance'.tr,
                style: AppFontStyle.cairoRegularStyle.copyWith(
                    fontSize: MediaQuery.of(context).size.shortestSide > 600
                        ? (orientation == Orientation.portrait
                            ? FontConstants.fontSize018.h
                            : FontConstants.fontSize028.h)
                        : FontConstants.fontSize020.h,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    height: MediaQuery.of(context).size.shortestSide > 600
                        ? (orientation == Orientation.portrait
                            ? 0.0013.h
                            : 0.002.h)
                        : 0.0025.h,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.shortestSide > 600 ? 0 : 0.005.h,
        ),
        // Divider(
        //   color: Color(0xFF959090),
        //   thickness: 0.0004.h,
        // ),
*//*        textfieled(
          isReadOnly: false,
          context,
          (value) {
            insuranceName2 = value.trim().toLowerCase();
          },
          (value) {
            return Validator.text(
                value,
                Get.locale.toString().contains('en')
                    ? "Invalid Insurance Name"
                    : "اسم التأمين غير صالح");
          },
          'Enter Insurance Name'.tr, // hintText
          employee!.insuranceName?.insuranceNames?.lastOrNull,
          null, // prefixIcon
          controller: null,
        )*//*
*//*        textfieled(
          isReadOnly: false,
          context,
          (value) {
            insurancePolice2 = value.trim();
          },
          (value) {
            return Validator.insurancePolicyNumber(
                value,
                Get.locale.toString().contains('en')
                    ? "Invalid Insurance Police Number"
                    : "رقم بوليصة التأمين غير صالحة");
          },
          'Enter Insurance Police Number'.tr, // hintText
          employee!.insurancePoliceNumber?.insurancePoliceNumber?.lastOrNull,
          null, // prefixIcon
          controller: null,
        )*//*        IntlPhoneField(
          textAlign: TextAlign.start,
          // autovalidateMode: AutovalidateMode.always,
          pickerDialogStyle: PickerDialogStyle(
              searchFieldInputDecoration: InputDecoration(
                enabled: true,
                hintText: 'search',
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.scrim,
                      width: 1.0,
                    )),
                fillColor: Theme.of(context).colorScheme.inversePrimary,
                hintStyle: TextStyle(
                  fontSize: FontConstants.fontSize020.h,
                  fontWeight: FontWeight.w400,
                  color: themeController.currentTheme == MyThemeData.lightTheme
                      ? Theme.of(context).colorScheme.scrim
                      : MyThemeData.colorWhite,
                ),
              ),
              width: .45.w,
              backgroundColor: Colors.white,
              countryCodeStyle: TextStyle(
                fontSize: FontConstants.fontSize020.h,
                fontWeight: FontWeight.w400,
                color: themeController.currentTheme == MyThemeData.lightTheme
                    ? MyThemeData.colorBlack
                    : MyThemeData.colorWhite,
              ),
              countryNameStyle: TextStyle(
                fontSize: FontConstants.fontSize020.h,
                fontWeight: FontWeight.w400,
                color: themeController.currentTheme == MyThemeData.lightTheme
                    ? MyThemeData.colorBlack
                    : MyThemeData.colorWhite,
              )),
          flagsButtonPadding: const EdgeInsets.only(left: 5),
          showDropdownIcon: false,
          disableLengthCheck: true,
          style: AppFontStyle.cairoRegularStyle.copyWith(
              fontSize: FontConstants.fontSize020.h,
              color: themeController.currentTheme == MyThemeData.lightTheme
                  ? MyThemeData.colorBlack
                  : MyThemeData.colorWhite,
              fontWeight: FontWeight.w400),
          dropdownTextStyle: AppFontStyle.cairoRegularStyle.copyWith(
              fontSize: FontConstants.fontSize020.h,
              color: themeController.currentTheme == MyThemeData.lightTheme
                  ? MyThemeData.colorBlack
                  : MyThemeData.colorWhite,
              fontWeight: FontWeight.w400),
          decoration: InputDecoration(
            filled: true,
            contentPadding: Get.locale.toString().contains('en')
                ? const EdgeInsets.only(left: 10, top: 10)
                : const EdgeInsets.only(right: 10, top: 10),
            focusColor: const Color.fromRGBO(246, 246, 246, 1),
            hoverColor: const Color.fromRGBO(246, 246, 246, 1),
            hintText: 'Enter The Phone Number'.tr,
            prefix: const SizedBox(
              height: 12,
            ),
            hintStyle: AppFontStyle.cairoRegularStyle.copyWith(
                fontSize: FontConstants.fontSize020.h,
                height: 2.2,
                color: MyThemeData.colorGrey,
                fontWeight: FontWeight.w400),
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
              borderSide: const BorderSide(color: Colors.red, width: 1.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8.0),
            ),
            fillColor: themeController.currentTheme == MyThemeData.lightTheme
                ? const Color(0xFFF6F6F6)
                : const Color(0xFF545454),
          ),
          onCountryChanged: (value) {},
          initialCountryCode:
              employee!.insurancePhoneNumber?.countryCode?.lastOrNull,
          initialValue:
              employee!.insurancePhoneNumber?.insurancePhoneNumber?.lastOrNull,
          onChanged: (value) {
            print('countryISOCode ${value.countryISOCode}');
            print('number ${value.number}');
            print('countryCode ${value.countryCode}');
            print('completeNumber ${value.completeNumber}');
            insurancePhone2 = value;
          },
          validator: (value) {
            return Validator.number(value!.completeNumber);
          },
        ),
        // textfieled(
        //   isReadOnly: false,
        //   context,
        //   (value) {
        //     insurancePhone2 = value.trim();
        //   },
        //   (value) {
        //     return Validator.number(
        //       value,
        //     );
        //   },
        //   'Enter Insurance Phone Number'.tr, // hintText
        //   employee!.insurancePhoneNumber?.insurancePhoneNumber?.lastOrNull,
        //   null, // prefixIcon
        //   controller: null,
        // ),
        Padding(
          padding: EdgeInsets.only(
              top: orientation == Orientation.portrait ? 0.012.h : 0.025.h),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/UsersGroup.svg',
                height: MediaQuery.of(context).size.shortestSide > 600
                    ? null
                    : 0.03.h,
                // ignore: deprecated_member_use
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.shortestSide > 600
                    ? 0.008.w
                    : 0.03.w,
              ),
              Text(
                'Emergency Contact Information'.tr,
                style: AppFontStyle.cairoRegularStyle.copyWith(
                    fontSize: MediaQuery.of(context).size.shortestSide > 600
                        ? (orientation == Orientation.portrait
                            ? FontConstants.fontSize018.h
                            : FontConstants.fontSize028.h)
                        : FontConstants.fontSize020.h,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    height: MediaQuery.of(context).size.shortestSide > 600
                        ? (orientation == Orientation.portrait
                            ? 0.0013.h
                            : 0.002.h)
                        : 0.002.h,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.shortestSide > 600 ? 0 : 0.008.h,
        ),
        // Divider(
        //   color: Color(0xFF959090),
        //   thickness: 0.0004.h,
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: Get.locale.toString().contains('en') ? 0.02.h : 0,
                    left: Get.locale.toString().contains('ar') ? 0.02.h : 0),
                child: textfieled(
                  context,
                  (value) {
                    connectionName2 = value.trim().toLowerCase();
                  },
                  (value) {
                    return Validator.name(
                      value,
                      Get.locale.toString().contains('en')
                          ? "Invalid First Name"
                          : "الاسم الأول غير صالح",
                    );
                  },
                  'Enter First Name'.tr, // hintText
                  capitalize(
                      '${employee!.contactFirstName?.contactFirstName?.lastOrNull}'),
                  null, // prefixIcon
                  controller: null,
                  isReadOnly: false,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: Get.locale.toString().contains('en') ? 0.02.h : 0,
                    left: Get.locale.toString().contains('ar') ? 0.02.h : 0),
                child: textfieled(
                  context,
                  (value) {
                    connectionMiddleName2 = value.trim().toLowerCase();
                  },
                  (value) {
                    return Validator.name(
                        value,
                        Get.locale.toString().contains('en')
                            ? "Invalid Middle Name"
                            : "اسم الاوسط غير صالح");
                  },
                  'Enter Middle Name'.tr, // hintText

                  capitalize(
                      '${employee!.contactMiddleName?.contactMiddleName?.lastOrNull}'),
                  null,
                  controller: null,
                  isReadOnly: false,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: textfieled(
                  context,
                  (value) {
                    connectionLastName2 = value.trim().toLowerCase();
                  },
                  (value) {
                    return Validator.name(
                        value,
                        Get.locale.toString().contains('en')
                            ? "Invalid Last Name"
                            : "اسم العائلة غير صالح");
                  },
                  'Enter Last Name'.tr, // hintText
                  capitalize(
                      '${employee!.contactLastName?.contactLastName?.lastOrNull}'),
                  null, // prefixIcon
                  controller: null,
                  isReadOnly: false,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: Get.locale.toString().contains('en') ? 0.02.h : 0,
                    left: Get.locale.toString().contains('ar') ? 0.02.h : 0),
                child: textfieled(
                  context,
                  (value) {
                    connecntionRelation2 = value.trim().toLowerCase();
                  },
                  (value) {
                    return Validator.name(
                      value,
                      Get.locale.toString().contains('en')
                          ? "Invalid Name"
                          : "الاسم غير صالح",
                    );
                  },
                  'Enter Contact Relation'.tr, // hintText
                  capitalize(
                      '${employee!.contactRelation?.contactRelation?.lastOrNull}'),
                  //  null,
                  null, // prefixIcon
                  controller: null,
                  isReadOnly: false,
                ),
              ),
            ),

            /// Come back
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: Get.locale.toString().contains('en') ? 0.02.h : 0,
                    left: Get.locale.toString().contains('ar') ? 0.02.h : 0),
                child: IntlPhoneField(
                  textAlign: TextAlign.start,
                  // autovalidateMode: AutovalidateMode.always,
                  pickerDialogStyle: PickerDialogStyle(
                      searchFieldInputDecoration: InputDecoration(
                        enabled: true,
                        hintText: 'search',
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.scrim,
                              width: 1.0,
                            )),
                        fillColor: Theme.of(context).colorScheme.inversePrimary,
                        hintStyle: TextStyle(
                          fontSize: FontConstants.fontSize020.h,
                          fontWeight: FontWeight.w400,
                          color: themeController.currentTheme ==
                                  MyThemeData.lightTheme
                              ? Theme.of(context).colorScheme.scrim
                              : MyThemeData.colorWhite,
                        ),
                      ),
                      width: .45.w,
                      backgroundColor: Colors.white,
                      countryCodeStyle: TextStyle(
                        fontSize: FontConstants.fontSize020.h,
                        fontWeight: FontWeight.w400,
                        color: themeController.currentTheme ==
                                MyThemeData.lightTheme
                            ? MyThemeData.colorBlack
                            : MyThemeData.colorWhite,
                      ),
                      countryNameStyle: TextStyle(
                        fontSize: FontConstants.fontSize020.h,
                        fontWeight: FontWeight.w400,
                        color: themeController.currentTheme ==
                                MyThemeData.lightTheme
                            ? MyThemeData.colorBlack
                            : MyThemeData.colorWhite,
                      )),
                  flagsButtonPadding: const EdgeInsets.only(left: 5),
                  showDropdownIcon: false,
                  disableLengthCheck: true,
                  style: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: FontConstants.fontSize020.h,
                      color:
                          themeController.currentTheme == MyThemeData.lightTheme
                              ? MyThemeData.colorBlack
                              : MyThemeData.colorWhite,
                      fontWeight: FontWeight.w400),
                  dropdownTextStyle: AppFontStyle.cairoRegularStyle.copyWith(
                      fontSize: FontConstants.fontSize020.h,
                      color:
                          themeController.currentTheme == MyThemeData.lightTheme
                              ? MyThemeData.colorBlack
                              : MyThemeData.colorWhite,
                      fontWeight: FontWeight.w400),
                  decoration: InputDecoration(
                    filled: true,
                    contentPadding: Get.locale.toString().contains('en')
                        ? const EdgeInsets.only(left: 10, top: 10)
                        : const EdgeInsets.only(right: 10, top: 10),
                    focusColor: const Color.fromRGBO(246, 246, 246, 1),
                    hoverColor: const Color.fromRGBO(246, 246, 246, 1),
                    hintText: 'Enter The Phone Number'.tr,
                    prefix: const SizedBox(
                      height: 12,
                    ),
                    hintStyle: AppFontStyle.cairoRegularStyle.copyWith(
                        fontSize: isPortrait
                            ? FontConstants.fontSize016.h
                            : FontConstants.fontSize020.h,
                        height: 2.2,
                        color: MyThemeData.colorGrey,
                        fontWeight: FontWeight.w400),
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
                      borderSide:
                          const BorderSide(color: Colors.red, width: 1.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    fillColor:
                        themeController.currentTheme == MyThemeData.lightTheme
                            ? const Color(0xFFF6F6F6)
                            : MyThemeData.colorBlack,
                  ),
                  onCountryChanged: (value) {},
                  initialCountryCode:
                      employee!.contactNumber?.countryCode?.lastOrNull,
                  initialValue:
                      employee!.contactNumber?.contactNumber?.lastOrNull,
                  onChanged: (value) {
                    print('countryISOCode ${value.countryISOCode}');
                    print('number ${value.number}');
                    print('countryCode ${value.countryCode}');
                    print('completeNumber ${value.completeNumber}');
                    connecntionPhone2 = value;
                  },
                  validator: (value) {
                    return Validator.number(value!.completeNumber);
                  },
                ),
                // textfieled(
                //   context,
                //   (value) {
                //     connecntionPhone2 = value.trim();
                //   },
                //   (value) {
                //     return Validator.number(value!);
                //   },
                //   'Enter Your Phone'.tr, // hintText
                //   employee!.contactNumber?.contactNumber?.lastOrNull,
                //   null, // prefixIcon
                //   controller: null,
                //   isReadOnly: false,
                // ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: textfieled(
                  context,
                  (value) {
                    connecntionEmail2 = value.trim();
                  },
                  (value) {
                    return Validator.email(value);
                  },
                  'Enter Your Email'.tr, // hintText
                  '${employee!.contactEmail?.contactEmail?.lastOrNull}',
                  null, // prefixIcon
                  controller: null,
                  isReadOnly: false,
                ),
              ),
            ),
          ],
        ),

        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: Get.locale.toString().contains('en') ? 0.02.h : 0,
                    left: Get.locale.toString().contains('ar') ? 0.02.h : 0),
                child: Stack(
                  children: [
                    textfieled(
                      context,
                      (value) async {
                        connecntionCountry2 = value.toLowerCase();
                      },
                      (value) {
                        return Validator.text(
                            value,
                            Get.locale.toString().contains('en')
                                ? "Invalid Country"
                                : "عنوان الدولة غير صحيح");
                      },
                      'Enter Your Country'.tr,
                      // (address != null
                      //         ? address!.country
                      //         : widget.userProfile.country!.countries!
                      //                     .lastOrNull !=
                      //                 null
                      //             ? capitalize(
                      //                 '${widget.userProfile.country!.countries!.lastOrNull}')
                      //             : widget.userProfile.country!.countries!
                      //                 .lastOrNull) ??
                      capitalize(
                          '${employee!.contactCountry?.contactCountry?.lastOrNull}'),
                      null, // prefixIcon
                      controller: null,
                      isReadOnly: false,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  textfieled(
                    context,
                    (value) async {
                      connecntionCity2 = value.toLowerCase();
                    },
                    (value) {
                      return Validator.text(
                          value,
                          Get.locale.toString().contains('en')
                              ? "Invalid City"
                              : "عنوان المدينة غير صحيح");
                    },
                    'Enter Your City'.tr,

                    capitalize(
                        '${employee!.contactCity?.contactCity?.lastOrNull}'),
                    null, // prefixIcon
                    controller: null,
                    isReadOnly: false,
                  ),
                  textfieled(
                    context,
                    (value) async {
                      connecntionProvince2 = value.toLowerCase();
                    },
                    (value) {
                      return Validator.text(
                          value,
                          Get.locale.toString().contains('en')
                              ? "Invalid Province"
                              : "عنوان الحي غير صحيح");
                    },
                    'Enter Your State Or Province'.tr,

                    capitalize(
                        '${employee!.contactProvince?.contactProvince?.lastOrNull}'),
                    null, // prefixIcon
                    controller: null,
                    isReadOnly: false,
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: Get.locale.toString().contains('en') ? 0.02.h : 0,
                    left: Get.locale.toString().contains('ar') ? 0.02.h : 0),
                child: Stack(
                  children: [
                    textfieled(
                      context,
                      (value) async {
                        connecntionCity2 = value.toLowerCase();
                      },
                      (value) {
                        return Validator.text(
                            value,
                            Get.locale.toString().contains('en')
                                ? "Invalid City"
                                : "عنوان المدينة غير صحيح");
                      },
                      'Enter Your City'.tr,

                      capitalize(
                          '${employee!.contactCity?.contactCity?.lastOrNull}'),
                      null, // prefixIcon
                      controller: null,
                      isReadOnly: false,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: textfieled(
                context,
                (value) {
                  connecntionAddress2 = value.toLowerCase();
                },
                (value) {
                  return Validator.text(
                      value,
                      Get.locale.toString().contains('en')
                          ? "Invalid Street Address"
                          : "عنوان الشارع غير صحيح");
                },
                'Enter Your Street Address'.tr, // hintText
                capitalize(
                    '${employee!.contactAddress?.contactAddress?.lastOrNull}'),
                null, // prefixIcon
                controller: null,
                isReadOnly: false,
              ),
            ),
          ],
        )

        // Padding(
        //   padding: EdgeInsets.only(top: 0.02.h),
        //   child: CustomBlackButton(
        //     buttonText: 'Add Contact'.tr,
        //     onPressed: () {
        //       // Add your functionality here
        //     },
        //   ),
        // ),
      ],
    );*/Container();
  }
}

/// additional info

class AdditionalFieldsContacts extends StatefulWidget {
  const AdditionalFieldsContacts({super.key});

  @override
  State<AdditionalFieldsContacts> createState() =>
      _AdditionalFieldsContactsState();
}

class _AdditionalFieldsContactsState extends State<AdditionalFieldsContacts> {
  @override
  void initState() {
    educationFileName = null;
    idPhotoFileName = null;
    armyFileName = null;
    driveFileName = null;
    maritalFileName = null;
    insuranceFileName = null;
    super.initState();
  }

  String? educationFileName;
  String? idPhotoFileName;
  String? armyFileName;
  String? driveFileName;
  String? maritalFileName;
  String? insuranceFileName;
  Connectiontype selectedCommunication = Connectiontype.text;
  List<String> imageExtentions = [
    ".PSD",
    ".XCF",
    ".AI",
    ".CDR",
    ".tif",
    ".tiff",
    ".bmp",
    ".jpg",
    ".jpeg",
    ".gif",
    ".png",
    ".eps",
    ".raw",
    ".cr2",
    ".nef",
    ".orf",
    ".sr2"
  ];
  String getFileNameFromPath(String path) {
    List<String> splitedPath = path.split('/');
    String fileName = splitedPath.last;
    return fileName;
  }

  bool isImage(String filePath) {
    bool flag = false;
    for (String imageExtention in imageExtentions) {
      if (filePath.contains(imageExtention)) {
        return true;
      }
    }
    return flag;
  }

  Future<void> pickAndUploadFile(int index, String name) async {
    FilePickerResult? pickedPdf = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (pickedPdf != null) {
      showLoadingIndicator();
      final file = File(pickedPdf.files.single.path!);
      String filePath = pickedPdf.files.single.path!;
      setState(() {
        index == 0
            ? educationFileName = getFileNameFromPath(filePath)
            : index == 1
                ? idPhotoFileName = getFileNameFromPath(filePath)
                : index == 2
                    ? armyFileName = getFileNameFromPath(filePath)
                    : index == 3
                        ? driveFileName = getFileNameFromPath(filePath)
                        : index == 4
                            ? maritalFileName = getFileNameFromPath(filePath)
                            : insuranceFileName = getFileNameFromPath(filePath);
      });

      if (isImage(filePath)) {
        Reference ref = FirebaseStorage.instance.ref().child(
            'employee/$name/${index == 0 ? "education_certificate_photo" : index == 1 ? "id_photo" : index == 2 ? "army_certificate_photo" : index == 3 ? "driving_license_photo" : index == 4 ? "marital_certificate_photo" : "insurance_card_photo"}_${DateTime.now()}.png');
        final metadata = SettableMetadata(contentType: 'image/jpeg');
        final TaskSnapshot task = await ref.putFile(file, metadata);
        index == 0
            ? educationCertificate2 = await task.ref.getDownloadURL()
            : index == 1
                ? idPhoto2 = await task.ref.getDownloadURL()
                : index == 2
                    ? armyCertificate2 = await task.ref.getDownloadURL()
                    : index == 3
                        ? drivingLicense2 = await task.ref.getDownloadURL()
                        : index == 4
                            ? maritalCertificate2 =
                                await task.ref.getDownloadURL()
                            : insuranceCard2 = await task.ref.getDownloadURL();
      } else {
        final Reference storageRef = FirebaseStorage.instance.ref().child(
            'employee/$name/${index == 0 ? "education_certificate_file" : index == 1 ? "id_file" : index == 2 ? "army_certificate_file" : index == 3 ? "driving_license_file" : index == 4 ? "marital_certificate_file" : "insurance_card_file"}_${DateTime.now()}.pdf');
        final metadata = SettableMetadata(contentType: 'application/pdf');
        final TaskSnapshot task = await storageRef.putFile(file, metadata);
        index == 0
            ? educationCertificate2 = await task.ref.getDownloadURL()
            : index == 1
                ? idPhoto2 = await task.ref.getDownloadURL()
                : index == 2
                    ? armyCertificate2 = await task.ref.getDownloadURL()
                    : index == 3
                        ? drivingLicense2 = await task.ref.getDownloadURL()
                        : index == 4
                            ? maritalCertificate2 =
                                await task.ref.getDownloadURL()
                            : insuranceCard2 = await task.ref.getDownloadURL();
      }
      setState(() {});
      hideLoadingIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return /*Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 0.02.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              employee!.educationCertificate?.educationCertificate
                          ?.lastOrNull ==
                      null
                  ? Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            right: Get.locale.toString().contains('en')
                                ? 0.02.h
                                : 0,
                            left: Get.locale.toString().contains('ar')
                                ? 0.02.h
                                : 0),
                        child: CustomBlackButton(
                          buttonText: educationFileName ??
                              'Add Education Certificate'.tr,
                          onPressed: () async {
                             hapticController.triggerHapticFeedback(
                                        vibration: VibrateType.lightImpact,
                                        hapticFeedback:
                                            HapticFeedback.lightImpact);
                            await pickAndUploadFile(0,
                                '${employee!.firstName!.firstNames!.last!}_${employee!.lastName!.lastNames!.last!}');
                          },
                        ),
                      ),
                    )
                  : Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            right: Get.locale.toString().contains('en')
                                ? 0.02.h
                                : 0,
                            left: Get.locale.toString().contains('ar')
                                ? 0.02.h
                                : 0),
                        child: CustomIconContainer(
                          text: 'Education Certificate'.tr,
                          image: isImage(employee!.educationCertificate!
                                  .educationCertificate!.lastOrNull!)
                              ? employee!.educationCertificate!
                                  .educationCertificate!.lastOrNull!
                              : null,
                          onPressed: () async {
                            var link = Uri.parse(employee!.educationCertificate!
                                .educationCertificate!.lastOrNull!);
                            isImage(employee!.educationCertificate!
                                    .educationCertificate!.lastOrNull!)
                                ? showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return RequestExcalateDialog(
                                        isSetting: true,
                                        title: "",
                                        imageUrl: employee!
                                            .educationCertificate!
                                            .educationCertificate!
                                            .lastOrNull!,
                                        isExclate: false,
                                        isToShowImage: true,
                                      );
                                    },
                                  )
                                : await launchUrl(
                                    link,
                                    mode: LaunchMode.externalApplication,
                                  );
                          },
                        ),
                      ),
                    ),
              employee!.idPhoto?.idPhoto?.lastOrNull == null
                  ? Expanded(
                      child: CustomBlackButton(
                        buttonText: idPhotoFileName ?? 'Add ID Photo'.tr,
                        onPressed: () async {
                           hapticController.triggerHapticFeedback(
                                        vibration: VibrateType.lightImpact,
                                        hapticFeedback:
                                            HapticFeedback.lightImpact);
                          await pickAndUploadFile(1,
                              '${employee!.firstName!.firstNames!.last!}_${employee!.lastName!.lastNames!.last!}');
                        },
                      ),
                    )
                  : Expanded(
                      child: CustomIconContainer(
                        text: 'ID Photo'.tr,
                        image: isImage(employee!.idPhoto!.idPhoto!.lastOrNull!)
                            ? employee!.idPhoto!.idPhoto!.lastOrNull!
                            : null,
                        onPressed: () async {
                          var link = Uri.parse(
                              employee!.idPhoto!.idPhoto!.lastOrNull!);
                          isImage(employee!.idPhoto!.idPhoto!.lastOrNull!)
                              ? showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return RequestExcalateDialog(
                                      isSetting: true,
                                      title: "",
                                      imageUrl: employee!
                                          .idPhoto!.idPhoto!.lastOrNull!,
                                      isExclate: false,
                                      isToShowImage: true,
                                    );
                                  },
                                )
                              : await launchUrl(
                                  link,
                                  mode: LaunchMode.externalApplication,
                                );
                        },
                      ),
                    ),
            ],
          ),
        ),
        SizedBox(
          height: 0.03.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            employee!.drivingLicense?.drivingLicense?.lastOrNull == null
                ? Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          right:
                              Get.locale.toString().contains('en') ? 0.02.h : 0,
                          left: Get.locale.toString().contains('ar')
                              ? 0.02.h
                              : 0),
                      child: CustomBlackButton(
                        buttonText: driveFileName ?? 'Add Driving License'.tr,
                        onPressed: () async {
                           hapticController.triggerHapticFeedback(
                                        vibration: VibrateType.lightImpact,
                                        hapticFeedback:
                                            HapticFeedback.lightImpact);
                          await pickAndUploadFile(3,
                              '${employee!.firstName!.firstNames!.last!}_${employee!.lastName!.lastNames!.last!}');
                        },
                      ),
                    ),
                  )
                : Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          right:
                              Get.locale.toString().contains('en') ? 0.02.h : 0,
                          left: Get.locale.toString().contains('ar')
                              ? 0.02.h
                              : 0),
                      child: CustomIconContainer(
                        text: 'Driving License'.tr,
                        image: isImage(employee!
                                .drivingLicense!.drivingLicense!.lastOrNull!)
                            ? employee!
                                .drivingLicense!.drivingLicense!.lastOrNull!
                            : null,
                        onPressed: () async {
                          var link = Uri.parse(employee!
                              .drivingLicense!.drivingLicense!.lastOrNull!);
                          isImage(employee!
                                  .drivingLicense!.drivingLicense!.lastOrNull!)
                              ? showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return RequestExcalateDialog(
                                      isSetting: true,
                                      title: "",
                                      imageUrl: employee!.drivingLicense!
                                          .drivingLicense!.lastOrNull!,
                                      isExclate: false,
                                      isToShowImage: true,
                                    );
                                  },
                                )
                              : await launchUrl(
                                  link,
                                  mode: LaunchMode.externalApplication,
                                );
                        },
                      ),
                    ),
                  ),
            employee!.maritalCertificate?.maritalCertificate?.lastOrNull == null
                ? Expanded(
                    child: CustomBlackButton(
                      buttonText:
                          maritalFileName ?? 'Add Martial Service Proof'.tr,
                      onPressed: () async {
                         hapticController.triggerHapticFeedback(
                                        vibration: VibrateType.lightImpact,
                                        hapticFeedback:
                                            HapticFeedback.lightImpact);
                        await pickAndUploadFile(4,
                            '${employee!.firstName!.firstNames!.last!}_${employee!.lastName!.lastNames!.last!}');
                      },
                    ),
                  )
                : Expanded(
                    child: CustomIconContainer(
                      text: 'Martial Service Proof'.tr,
                      image: isImage(employee!.maritalCertificate!
                              .maritalCertificate!.lastOrNull!)
                          ? employee!.maritalCertificate!.maritalCertificate!
                              .lastOrNull!
                          : null,
                      onPressed: () async {
                        var link = Uri.parse(employee!.maritalCertificate!
                            .maritalCertificate!.lastOrNull!);
                        isImage(employee!.maritalCertificate!
                                .maritalCertificate!.lastOrNull!)
                            ? showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return RequestExcalateDialog(
                                    isSetting: true,
                                    title: "",
                                    imageUrl: employee!.maritalCertificate!
                                        .maritalCertificate!.lastOrNull!,
                                    isExclate: false,
                                    isToShowImage: true,
                                  );
                                },
                              )
                            : await launchUrl(
                                link,
                                mode: LaunchMode.externalApplication,
                              );
                      },
                    ),
                  ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            employee!.insuranceCard?.insuranceCard?.lastOrNull == null
                ? Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          right:
                              Get.locale.toString().contains('en') ? 0.02.h : 0,
                          left: Get.locale.toString().contains('ar')
                              ? 0.02.h
                              : 0),
                      child: CustomBlackButton(
                        buttonText:
                            insuranceFileName ?? 'Add Life Insurance Card'.tr,
                        onPressed: () async {
                           hapticController.triggerHapticFeedback(
                                        vibration: VibrateType.lightImpact,
                                        hapticFeedback:
                                            HapticFeedback.lightImpact);
                          await pickAndUploadFile(5,
                              '${employee!.firstName!.firstNames!.last!}_${employee!.lastName!.lastNames!.last!}');
                        },
                      ),
                    ),
                  )
                : Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          right:
                              Get.locale.toString().contains('en') ? 0.02.h : 0,
                          left: Get.locale.toString().contains('ar')
                              ? 0.02.h
                              : 0),
                      child: CustomIconContainer(
                        text: 'Life Insurance Card'.tr,
                        image: isImage(employee!
                                .insuranceCard!.insuranceCard!.lastOrNull!)
                            ? employee!
                                .insuranceCard!.insuranceCard!.lastOrNull!
                            : null,
                        onPressed: () async {
                          var link = Uri.parse(employee!
                              .insuranceCard!.insuranceCard!.lastOrNull!);
                          isImage(employee!
                                  .insuranceCard!.insuranceCard!.lastOrNull!)
                              ? showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return RequestExcalateDialog(
                                      isSetting: true,
                                      title: "",
                                      imageUrl: employee!.insuranceCard!
                                          .insuranceCard!.lastOrNull!,
                                      isExclate: false,
                                      isToShowImage: true,
                                    );
                                  },
                                )
                              : await launchUrl(
                                  link,
                                  mode: LaunchMode.externalApplication,
                                );
                        },
                      ),
                    ),
                  ),
            employee!.armyCertificate?.armyCertificate?.lastOrNull == null
                ? Expanded(
                    child: CustomBlackButton(
                      buttonText: armyFileName ?? 'Add Marital Certificate'.tr,
                      onPressed: () async {
                         hapticController.triggerHapticFeedback(
                                        vibration: VibrateType.lightImpact,
                                        hapticFeedback:
                                            HapticFeedback.lightImpact);
                        await pickAndUploadFile(2,
                            '${employee!.firstName!.firstNames!.last!}_${employee!.lastName!.lastNames!.last!}');
                      },
                    ),
                  )
                : Expanded(
                    child: CustomIconContainer(
                      text: 'Marital Certificate'.tr,
                      image: isImage(employee!
                              .armyCertificate!.armyCertificate!.lastOrNull!)
                          ? employee!
                              .armyCertificate!.armyCertificate!.lastOrNull!
                          : null,
                      onPressed: () async {
                        var link = Uri.parse(employee!
                            .armyCertificate!.armyCertificate!.lastOrNull!);
                        isImage(employee!
                                .armyCertificate!.armyCertificate!.lastOrNull!)
                            ? showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return RequestExcalateDialog(
                                    isSetting: true,
                                    title: "",
                                    imageUrl: employee!.armyCertificate!
                                        .armyCertificate!.lastOrNull!,
                                    isExclate: false,
                                    isToShowImage: true,
                                  );
                                },
                              )
                            : await launchUrl(
                                link,
                                mode: LaunchMode.externalApplication,
                              );
                      },
                    ),
                  ),
          ],
        ),
        SizedBox(
          height: 0.03.h,
        ),
        CustomBlackButton(
          buttonText: 'Add Something Else'.tr,
          isYellow: true,
          onPressed: () {
             hapticController.triggerHapticFeedback(
                                        vibration: VibrateType.lightImpact,
                                        hapticFeedback:
                                            HapticFeedback.lightImpact);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddSomethingDialog();
              },
            );
          },
        ),
      ],
    );*/
    Container();
  }
}
