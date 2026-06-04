import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:demo_app/core/widgets/custom_checkbox.dart';
import 'package:demo_app/core/widgets/custom_drop_down_menu.dart';
import 'package:demo_app/components/home_components/custom_create_task_container.dart';
import 'package:demo_app/core/widgets/country_picker_dialog.dart';
import 'package:demo_app/core/widgets/intl_phone_field.dart';
import 'package:demo_app/components/lib/phone_number.dart';
import 'package:demo_app/components/start_sign_in_components/custom_textfield.dart';
import 'package:demo_app/components/start_sign_in_components/terms_dialog.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/core/helper/validator.dart';
import 'package:demo_app/feature/settings_screen/views/terms_and_conditions.dart';
import 'package:demo_app/features/skeleton/onboarding/presentation/ui/pages/onboarding.dart';
import 'package:demo_app/nav_bar_package.dart/functions.dart';

// ignore: must_be_immutable
class ContactInfoView extends StatefulWidget {
  ContactInfoView({
    super.key,
    required this.contactInformation,
    required this.contactInfoState,
    required this.firstState,
    required this.lastState,
    required this.emailState,
    required this.phoneState,
    required this.role,
    required this.roleState,
  });
  double contactInformation;
  ValueChanged<double> contactInfoState;
  ValueChanged<String> firstState;
  ValueChanged<String> lastState;
  ValueChanged<String> emailState;
  ValueChanged<PhoneNumber> phoneState;
  String? role;
  ValueChanged<String?> roleState;

  @override
  State<ContactInfoView> createState() => _ContactInfoViewState();
}

class _ContactInfoViewState extends State<ContactInfoView> {
  bool isChecked = false;
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isTablet
            ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: isPortrait ? 0.42.w : 0.3.w,
                      child: CustomField(
                          controller: firstname,
                          validator: (value) {
                            return Validator
                                .name(value, "Invalid First Name".tr);
                          },
                          onfinishState: (value) {
                            setState(() {
                              widget.firstState(value.text);
                              widget.contactInformation += 1 / 4;
                              widget.contactInfoState(widget.contactInformation);
                            });
                          },
                          hintText: "First Name",
                          imagePath: "assets/images/user_inf.svg"),
                    ),
                  ),
                   SizedBox(width:isPortrait? 0.02.w : 0.01.w,),
                  Expanded(
                    child: SizedBox(
                      width: isPortrait ? 0.42.w : 0.3.w,
                      child: CustomField(
                          controller: lastname,
                          hintText: "Last Name",
                          validator: (value) {
                            return Validator
                                .name(value, "Invalid Last Name".tr);
                          },
                          onfinishState: (value) {
                            setState(() {
                              widget.lastState(value.text);
                              widget.contactInformation += 1 / 5;
                              widget.contactInfoState(widget.contactInformation);
                            });
                          },
                          imagePath: "assets/images/user_inf.svg"),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  SizedBox(
                    child: CustomField(
                        controller: firstname,
                        validator: (value) {
                          return Validator
                              .name(value, "Invalid First Name".tr);
                        },
                        onfinishState: (value) {
                          setState(() {
                            widget.firstState(value.text);
                            widget.contactInformation += 1 / 4;
                            widget.contactInfoState(widget.contactInformation);
                          });
                        },
                        hintText: "First Name",
                        imagePath: "assets/images/user_inf.svg"),
                  ),
                  SizedBox(
                    height: isTablet ? 0 : height,
                  ),
                  SizedBox(
                    child: CustomField(
                        controller: lastname,
                        hintText: "Last Name",
                        validator: (value) {
                          return Validator
                              .name(value, "Invalid Last Name".tr);
                        },
                        onfinishState: (value) {
                          setState(() {
                            widget.lastState(value.text);
                            widget.contactInformation += 1 / 5;
                            widget.contactInfoState(widget.contactInformation);
                          });
                        },
                        imagePath: "assets/images/user_inf.svg"),
                  ),
                  SizedBox(
                    height: isTablet ? 0 : height,
                  ),
                ],
              ),
        isTablet
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 0.015.h),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: isPortrait ? 0.42.w : 0.3.w,
                          child: CustomField(
                              controller: email,
                              hintText: "Enter Email",
                              validator: (value) {
                                return Validator.email(
                                  value,
                                );
                              },
                              onfinishState: (value) {
                                setState(() {
                                  widget.emailState(value.text);
                                  widget.contactInformation += 1 / 5;
                                  widget
                                      .contactInfoState(widget.contactInformation);
                                });
                              },
                              imagePath: "assets/icons/sms.svg"),
                        ),
                      ),
                       SizedBox(width:isPortrait? 0.02.w : 0.01.w,),
                      Expanded(
                        child: SizedBox(
                          width: isPortrait ? 0.42.w : 0.3.w,
                        
                          child: IntlPhoneField(
                             textAlign: Get.locale.toString().contains('ar')
                            ? TextAlign.start
                            : TextAlign.start,
                            // autovalidateMode: AutovalidateMode.always,
                            pickerDialogStyle: PickerDialogStyle(
                                searchFieldInputDecoration: InputDecoration(
                                  enabled: true,
                                  hintText: 'search',
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color:
                                            Theme.of(context).colorScheme.scrim,
                                        width: 1.0,
                                      )),
                                  fillColor: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  hintStyle: AppFontStyle.cairoRegularStyle.copyWith(
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
                            flagsButtonPadding:  EdgeInsets.only(left: 5,top: isPortrait? 0.0225.h : 0,bottom: isPortrait? 0.0225.h : 0),
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
                                  fontSize:isPortrait?FontConstants.fontSize016.h :FontConstants.fontSize020.h,
                                  height:isPortrait?1.1 :1.2,
                                  color: MyThemeData.colorGrey,
                                  fontWeight: FontWeight.w400),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.scrim,
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:  MyThemeData.lightPrimary,//Theme.of(context).colorScheme.scrim,
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, //Theme.of(context).colorScheme.scrim,
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 1.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              fillColor: themeController.currentTheme ==
                                      MyThemeData.lightTheme
                                  ? Colors.white
                                  : const Color(0xFF545454),
                            ),
                            onCountryChanged: (value) {},
                            initialCountryCode: 'EG',
                                        
                            onChanged: (value) {
                              print('countryISOCode ${value.countryISOCode}');
                              print('number ${value.number}');
                              print('countryCode ${value.countryCode}');
                              print('completeNumber ${value.completeNumber}');
                              widget.phoneState(value);
                              widget.contactInfoState(widget.contactInformation);
                            },
                            validator: (value) {
                              return Validator.number(value!.completeNumber);
                            },
                          ),
                          //  CustomField(
                          //     controller: phone,
                          //     onfinishState: (value) {
                          //       setState(() {
                          //         widget.phoneState(value.text);
                          //         widget.contactInformation += 1 / 5;
                          //         widget.contactInfoState(widget.contactInformation);
                          //       });
                          //     },
                          //     validator: (value) {
                          //       return Validator.number(
                          //         value,
                          //       );
                          //     },
                          //     hintText: "Enter Phone",
                          //     imagePath: "assets/images/call.svg"),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Column(
                children: [
                  SizedBox(
                    child: CustomField(
                        controller: email,
                        hintText: "Enter Email".tr,
                        validator: (value) {
                          return Validator.email(
                            value,
                          );
                        },
                        onfinishState: (value) {
                          setState(() {
                            widget.emailState(value.text);
                            widget.contactInformation += 1 / 5;
                            widget.contactInfoState(widget.contactInformation);
                          });
                        },
                        imagePath: "assets/icons/sms.svg"),
                  ),
                  SizedBox(
                    height: isTablet ? 0 : height,
                  ),
                  IntlPhoneField(
                     textAlign: Get.locale.toString().contains('ar')
                            ? TextAlign.start
                            : TextAlign.start,
                    // autovalidateMode: AutovalidateMode.always,
                    pickerDialogStyle: PickerDialogStyle(
                        searchFieldInputDecoration: InputDecoration(
                          enabled: true,
                          hintText: 'search',
                          filled: true,
                          constraints: BoxConstraints(maxHeight: 0.045.h),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.scrim,
                                width: 1.0,
                              )),
                          fillColor:
                              Theme.of(context).colorScheme.inversePrimary,
                          hintStyle: TextStyle(
                            fontSize: FontConstants.fontSize018.h,
                            fontWeight: FontWeight.w400,
                            color: themeController.currentTheme ==
                                    MyThemeData.lightTheme
                                ? Theme.of(context).colorScheme.scrim
                                : MyThemeData.colorWhite,
                          ),
                        ),
                        backgroundColor: Colors.white,
                        countryCodeStyle: TextStyle(
                          fontSize: FontConstants.fontSize018.h,
                          fontWeight: FontWeight.w400,
                          color: themeController.currentTheme ==
                                  MyThemeData.lightTheme
                              ? MyThemeData.colorBlack
                              : MyThemeData.colorWhite,
                        ),
                        countryNameStyle: TextStyle(
                          fontSize: FontConstants.fontSize018.h,
                          fontWeight: FontWeight.w400,
                          color: themeController.currentTheme ==
                                  MyThemeData.lightTheme
                              ? MyThemeData.colorBlack
                              : MyThemeData.colorWhite,
                        )),
                    flagsButtonPadding: EdgeInsets.only(left: 0.03.w),
                    showDropdownIcon: false,
                    disableLengthCheck: true,
                    style: AppFontStyle.cairoRegularStyle.copyWith(
                        fontSize: FontConstants.fontSize018.h,
                        color: themeController.currentTheme ==
                                MyThemeData.lightTheme
                            ? MyThemeData.colorBlack
                            : MyThemeData.colorWhite,
                        fontWeight: FontWeight.w400),
                    dropdownTextStyle: AppFontStyle.cairoRegularStyle
                        .copyWith(
                            fontSize: FontConstants.fontSize018.h,
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
                          fontSize: FontConstants.fontSize018.h,
                          height:isTablet? 1.6:1.1,
                          color: Theme.of(context).colorScheme.scrim,
                          fontWeight: FontWeight.w400),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.scrim,
                            width: 1.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.scrim,
                            width: 1.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.transparent,//Theme.of(context).colorScheme.scrim,
                            width: 1.0),
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
                      fillColor: themeController.currentTheme ==
                              MyThemeData.lightTheme
                          ? Colors.white
                          : const Color(0xFF545454),
                    ),
                    onCountryChanged: (value) {},
                    initialCountryCode: 'EG',
                  
                    onChanged: (value) {
                      print('countryISOCode ${value.countryISOCode}');
                      print('number ${value.number}');
                      print('countryCode ${value.countryCode}');
                      print('completeNumber ${value.completeNumber}');
                      widget.phoneState(value);
                      widget.contactInfoState(widget.contactInformation);
                    },
                    validator: (value) {
                      return Validator.number(value!.completeNumber);
                    },
                  ),
                  SizedBox(
                    height: isTablet ? 0 : height,
                  ),
                ],
              ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: !isTablet ? 0 : 0.015.h),
          child: CustomDropdownButton2(
              hint: "Role",
              buttonHeight: 0.066.h,
              buttonWidth: double.infinity,
              dropdownWidth: isTablet ? 0.88.w : 0.92.w,
              borded: false,
              // hasPrefix: true,
               itemPadding: isTablet ? null : EdgeInsets.symmetric(horizontal: 0.035.w),
              // prefixUrl: "assets/images/case2.svg",
              buttonPadding: isTablet
                  ? EdgeInsets.symmetric(
                  horizontal:isPortrait? 0.02.w : 0.012.w
                   )
                  : EdgeInsets.only(left: Get.locale.toString().contains('en')
                          ? 0.035.w : 0 , right:Get.locale.toString().contains('ar')
                          ? 0.035.w : 0 ),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              value: widget.role,
              dropdownItems: ["Manager".tr, "CEO".tr, "Employee".tr],
              onChanged: (value) {
                setState(() {
                  widget.role = value;
                  widget.roleState(widget.role);
                  widget.contactInformation += 1 / 5;
                  widget.contactInfoState(widget.contactInformation);
                });
              }),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0.015.h),
          child: Row(
            children: [
              CustomCheckbox(
                isChecked: isChecked,
                onCheckboxState: (value) {
                  setState(() {
                    isChecked = value;
                  });
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.01.w),
                child: RichText(
                  text: TextSpan(
                      text: "I have read and accepted the ".tr,
                      style: AppFontStyle.cairoRegularStyle.copyWith(
                        fontSize: isTablet
                            ? isPortrait
                                ? FontConstants.fontSize016.h
                                : FontConstants.fontSize015.w
                            : FontConstants.fontSize016.h,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                      children: [
                        TextSpan(
                            text: "Terms And Conditions".tr,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                !isTablet
                                    ? PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        withNavBar: false,
                                        screen: const TermsConditions(),
                                      )
                                    : showDialog(
                                        context: context,
                                        builder: (context) {
                                          return const TermsDialog();
                                        });
                              },
                            style: AppFontStyle.cairoRegularStyle.copyWith(
                                fontSize: isTablet
                                    ? isPortrait
                                        ? FontConstants.fontSize016.h
                                        : FontConstants.fontSize015.w
                                    : FontConstants.fontSize016.h,
                                fontWeight: FontWeight.w600,
                                color: MyThemeData.colorBlue,
                                decoration: TextDecoration.underline))
                      ]),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
