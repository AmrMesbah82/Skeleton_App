import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';
import 'package:demo_app/core/widgets/country_picker_dialog.dart';
import 'package:demo_app/core/widgets/intl_phone_field.dart';
import 'package:demo_app/components/lib/phone_number.dart';
import 'package:demo_app/core/widgets/column_request_data.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/core/helper/validator.dart';
import 'package:demo_app/features/skeleton/onboarding/presentation/ui/pages/onboarding.dart';

// ignore: must_be_immutable
class HealthInsuranceView extends StatefulWidget {
  HealthInsuranceView({
    super.key,
    required this.widthOfData,
    required this.insuranceName,
    required this.insuranceNameState,
    required this.insuranceNamefinishState,
    required this.helthInsurance,
    required this.healthInsuranceState,
    required this.contactName,
    required this.contactMiddleName,
    required this.contactLastName,
    required this.contactEmail,
    required this.contactAddress,
    required this.contactCity,
    required this.contactPostalCode,
    required this.contactCountry,
    required this.contactProvince,
    required this.contactNameState,
    required this.contactMiddleNameState,
    required this.contactLastNameState,
    required this.contactEmailState,
    required this.contactAddressState,
    required this.contactCityState,
    required this.contactPostalCodeState,
    required this.contactCountryState,
    required this.contactProvinceState,
    required this.contactNamefinishState,
    required this.contactNumber,
    required this.contactNumberState,
    required this.contactNumberfinishState,
    required this.contactRelation,
    required this.contactRelationState,
    required this.contactRelationfinishState,
    required this.insurancePoliceName,
    required this.insurancePoliceNameState,
    required this.insurancePoliceNamefinishState,
    required this.phoneNumberInsu,
    required this.phoneNumberInsuState,
    required this.phoneNumberInsufinishState,
    required this.secondContactNameState,
    required this.secondContactMiddleNameState,
    required this.secondContactLastNameState,
    required this.secondContactEmailState,
    required this.secondContactAddressState,
    required this.secondContactCityState,
    required this.secondContactPostalCodeState,
    required this.secondContactCountryState,
    required this.secondContactProvinceState,
    required this.secondContactRelationState,
    required this.secondContactNumberState,
    this.isPreview = false,
  });
  final double widthOfData;
  double helthInsurance;

  ValueChanged<double> healthInsuranceState;
  TextEditingController insuranceName;
  ValueChanged<TextEditingController> insuranceNameState;
  ValueChanged? insuranceNamefinishState;
  TextEditingController insurancePoliceName;
  ValueChanged<TextEditingController> insurancePoliceNameState;
  ValueChanged? insurancePoliceNamefinishState;
  TextEditingController phoneNumberInsu;
  ValueChanged<PhoneNumber> phoneNumberInsuState;
  ValueChanged? phoneNumberInsufinishState;
  List<TextEditingController> contactName;
  List<TextEditingController> contactMiddleName;
  List<TextEditingController> contactLastName;
  List<TextEditingController> contactEmail;
  List<TextEditingController> contactAddress;
  List<TextEditingController> contactCity;
  List<TextEditingController> contactPostalCode;
  List<TextEditingController> contactCountry;
  List<TextEditingController> contactProvince;
  ValueChanged<TextEditingController> contactNameState;
  ValueChanged<TextEditingController> contactMiddleNameState;
  ValueChanged<TextEditingController> contactLastNameState;
  ValueChanged<TextEditingController> contactEmailState;
  ValueChanged<TextEditingController> contactAddressState;
  ValueChanged<TextEditingController> contactCityState;
  ValueChanged<TextEditingController> contactPostalCodeState;
  ValueChanged<TextEditingController> contactCountryState;
  ValueChanged<TextEditingController> contactProvinceState;
  ValueChanged<TextEditingController> contactRelationState;
  ValueChanged<PhoneNumber> contactNumberState;
  ValueChanged<TextEditingController> secondContactNameState;
  ValueChanged<TextEditingController> secondContactMiddleNameState;
  ValueChanged<TextEditingController> secondContactLastNameState;
  ValueChanged<TextEditingController> secondContactEmailState;
  ValueChanged<TextEditingController> secondContactAddressState;
  ValueChanged<TextEditingController> secondContactCityState;
  ValueChanged<TextEditingController> secondContactPostalCodeState;
  ValueChanged<TextEditingController> secondContactCountryState;
  ValueChanged<TextEditingController> secondContactProvinceState;
  ValueChanged<TextEditingController> secondContactRelationState;
  ValueChanged<PhoneNumber> secondContactNumberState;

  ValueChanged? contactNamefinishState;
  List<TextEditingController> contactRelation;

  ValueChanged? contactRelationfinishState;
  List<TextEditingController> contactNumber;

  ValueChanged? contactNumberfinishState;
  bool isPreview;

  @override
  State<HealthInsuranceView> createState() => _HealthInsuranceViewState();
}

class _HealthInsuranceViewState extends State<HealthInsuranceView> {
  bool hasSuffix1 = false;
  bool hasSuffix2 = false;
  bool hasSuffix3 = false;
  bool hasSuffix4 = false;
  bool hasSuffix5 = false;
  bool hasSuffix6 = false;
  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Container();/*Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: widget.widthOfData,
              child: ColumnRequestData(isAddNew: true,
                title: "Insurance Provider Name",
                isTextField: true,
                hint: "Enter The Insurance Name",
                isOptional: false,
                textController: widget.insuranceName,
                validator: (value) {
                  return Validator.work(value, "Invalid Insurance Name".tr);
                },
                controllerfinishState: (value) {
                  setState(() {
                    widget.insuranceNameState(widget.insuranceName);
                    widget.helthInsurance +=
                        1 / ((widget.contactName.length * 3) + 3);
                    widget.healthInsuranceState(widget.helthInsurance);
                  });
                },
                controllerState: (value) {
                  setState(() {
                    widget.insuranceNameState(widget.insuranceName);
                  });
                },
                isExpanded: true,
                hasSuffix: hasSuffix1,
                hassSuffixState: (value) {
                  setState(() {
                    hasSuffix1 = value as bool;
                  });
                },
                fillColor: Theme.of(context).colorScheme.inversePrimary,
                suffixUrl: "assets/images/closefield.svg",
              ),
            ),
            SizedBox(
              width: widget.widthOfData,
              child: ColumnRequestData(isAddNew: true,
                title: "Insurance Police Number",
                isTextField: true,
                hint: "Enter The Insurance Police Number",
                textController: widget.insurancePoliceName,
                validator: (value) {
                  return Validator.insurancePolicyNumber(
                      value,
                      Get.locale.toString().contains('en')
                          ? "Invalid Number"
                          : "رقم غير صالح");
                },
                controllerfinishState: (value) {
                  setState(() {
                    widget.insurancePoliceNamefinishState!(
                        widget.insurancePoliceName);
                    widget.helthInsurance +=
                        1 / ((widget.contactName.length * 3) + 3);
                    widget.healthInsuranceState(widget.helthInsurance);
                  });
                },
                controllerState: (value) {
                  setState(() {
                    widget.insurancePoliceNameState(widget.insurancePoliceName);
                  });
                },
                isOptional: false,
                isExpanded: true,
                hasSuffix: hasSuffix2,
                hassSuffixState: (value) {
                  setState(() {
                    hasSuffix2 = value as bool;
                  });
                },
                fillColor: Theme.of(context).colorScheme.inversePrimary,
                suffixUrl: "assets/images/closefield.svg",
              ),
            ),
            SizedBox(
              width: widget.widthOfData,
               
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Insurance Phone Number'.tr,
                        style: AppFontStyle.cairoRegularStyle.copyWith(
                          fontSize: FontConstants.fontSize022.h,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.inverseSurface,
                          height: 1.6
                        ),
                      ),
                     
                      SizedBox(
                        height: 0.055.h,
                        child: IntlPhoneField(
                          textAlign: Get.locale.toString().contains('ar')
                              ? TextAlign.start
                              : TextAlign.start,
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
                            // contentPadding: Get.locale.toString().contains('en')
                            //     ? const EdgeInsets.only(left: 10, top: 27)
                            //     : const EdgeInsets.only(right: 10, top: 27),
                            focusColor: const Color.fromRGBO(246, 246, 246, 1),
                            hoverColor: const Color.fromRGBO(246, 246, 246, 1),
                            hintText: "Enter The Insurance Phone Number".tr,
                            prefix: const SizedBox(
                              height: 22,
                            ),
                            hintStyle: AppFontStyle.cairoRegularStyle.copyWith(
                                fontSize: FontConstants.fontSize020.h,
                                
                                color: MyThemeData.colorGrey,
                                fontWeight: FontWeight.w400),
                                 errorStyle: AppFontStyle.cairoRegularStyle.copyWith(
                              fontSize: isPortrait?FontConstants.fontSize012.h :FontConstants.fontSize025.h,
                              color: MyThemeData.colorRed,
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
                                  color:  Colors.transparent,
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
                                :  MyThemeData.dark,
                          ),
                          onCountryChanged: (value) {},
                          initialCountryCode: 'EG',
                          onChanged: (value) {
                            print('countryISOCode ${value.countryISOCode}');
                            print('number ${value.number}');
                            print('countryCode ${value.countryCode}');
                            print('completeNumber ${value.completeNumber}');
                            widget.phoneNumberInsuState(value);
                          },
                          validator: (value) {
                            return Validator.number(value!.completeNumber);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   width: widget.widthOfData,
            //   child: ColumnRequestData(isAddNew: true,
            //     title: "Insurance Phone Number",
            //     isTextField: true,
            //     hint: "Enter The Insurance Phone Number",
            //     validator: (value) {
            //       return Validator.number(
            //         value,
            //       );
            //     },
            //     textController: widget.phoneNumberInsu,
            //     controllerfinishState: (value) {
            //       setState(() {
            //         widget.phoneNumberInsufinishState!(widget.phoneNumberInsu);
            //         widget.helthInsurance +=
            //             1 / ((widget.contactName.length * 3) + 3);
            //         widget.healthInsuranceState(widget.helthInsurance);
            //       });
            //     },
            //     controllerState: (value) {
            //       setState(() {
            //         widget.phoneNumberInsuState(widget.phoneNumberInsu);
            //       });
            //     },
            //     isOptional: false,
            //     isExpanded: true,
            //     hasSuffix: hasSuffix3,
            //     hassSuffixState: (value) {
            //       setState(() {
            //         hasSuffix3 = value as bool;
            //       });
            //     },
            //     fillColor: Theme.of(context).colorScheme.inversePrimary,
            //     suffixUrl: "assets/images/closefield.svg",
            //   ),
            // ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 0.025.h),
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
                        ? (FontConstants.fontSize028.h)
                        : FontConstants.fontSize020.h,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    height: MediaQuery.of(context).size.shortestSide > 600
                        ? (0.002.h)
                        : 0.002.h,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        SizedBox(
          height: widget.isPreview
              ? 0.2.h
              : widget.contactName.length == 2
                  ? 1.2.h
                  : 0.6.h,
          child: ListView.builder(
padding: EdgeInsets.zero,
              itemCount: widget.contactName.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 18,
                    ),
                    Text(
                      i == 0
                          ? 'First Emergency Contact'.tr
                          : 'Second Emergency Contact'.tr,
                      style: AppFontStyle.cairoRegularStyle.copyWith(
                          fontSize:
                              MediaQuery.of(context).size.shortestSide > 600
                                  ? (FontConstants.fontSize026.h)
                                  : FontConstants.fontSize020.h,
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          height: MediaQuery.of(context).size.shortestSide > 600
                              ? (0.002.h)
                              : 0.002.h,
                          fontWeight: FontWeight.w400),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.02.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: widget.widthOfData,
                            child: ColumnRequestData(isAddNew: true,
                              title: "First Name",
                              isTextField: true,
                              controllerfinishState: (value) {
                                setState(() {
                                  widget.contactNamefinishState!(
                                      widget.contactName[i]);
                                  widget.helthInsurance +=
                                      1 / ((widget.contactName.length * 3) + 3);
                                  widget.healthInsuranceState(
                                      widget.helthInsurance);
                                });
                              },
                              hint: "Enter The First Name",
                              textController: widget.contactName[i],
                              controllerState: (value) {
                                setState(() {
                                  print('i==$i');
                                  i == 0
                                      ? widget.contactNameState(
                                          widget.contactName[i])
                                      : widget.secondContactNameState(
                                          widget.contactName[i]);
                                });
                              },
                              isOptional: false,
                              isExpanded: true,
                              hasSuffix: hasSuffix4,
                              hassSuffixState: (value) {
                                setState(() {
                                  hasSuffix4 = value as bool;
                                });
                              },
                              fillColor:
                                  Theme.of(context).colorScheme.inversePrimary,
                              suffixUrl: "assets/images/closefield.svg",
                            ),
                          ),
                          SizedBox(
                            width: widget.widthOfData,
                            child: ColumnRequestData(isAddNew: true,
                              title: "Middle Name",
                              isTextField: true,
                              controllerfinishState: (value) {
                                setState(() {
                                  widget.contactNamefinishState!(
                                      widget.contactMiddleName[i]);
                                  widget.helthInsurance += 1 /
                                      ((widget.contactMiddleName.length * 3) +
                                          3);
                                  widget.healthInsuranceState(
                                      widget.helthInsurance);
                                });
                              },
                              hint: "Enter The Middle Name",
                              textController: widget.contactMiddleName[i],
                              controllerState: (value) {
                                setState(() {
                                  i == 0
                                      ? widget.contactMiddleNameState(
                                          widget.contactMiddleName[i])
                                      : widget.secondContactMiddleNameState(
                                          widget.contactMiddleName[i]);
                                });
                              },
                              isOptional: false,
                              isExpanded: true,
                              hasSuffix: hasSuffix4,
                              hassSuffixState: (value) {
                                setState(() {
                                  hasSuffix4 = value as bool;
                                });
                              },
                              fillColor:
                                  Theme.of(context).colorScheme.inversePrimary,
                              suffixUrl: "assets/images/closefield.svg",
                            ),
                          ),
                          SizedBox(
                            width: widget.widthOfData,
                            child: ColumnRequestData(isAddNew: true,
                              title: "Last Name",
                              isTextField: true,
                              controllerfinishState: (value) {
                                setState(() {
                                  widget.contactNamefinishState!(
                                      widget.contactLastName[i]);
                                  widget.helthInsurance += 1 /
                                      ((widget.contactLastName.length * 3) + 3);
                                  widget.healthInsuranceState(
                                      widget.helthInsurance);
                                });
                              },
                              hint: "Enter The Last Name",
                              textController: widget.contactLastName[i],
                              controllerState: (value) {
                                setState(() {
                                  i == 0
                                      ? widget.contactLastNameState(
                                          widget.contactLastName[i])
                                      : widget.secondContactLastNameState(
                                          widget.contactLastName[i]);
                                });
                              },
                              isOptional: false,
                              isExpanded: true,
                              hasSuffix: hasSuffix4,
                              hassSuffixState: (value) {
                                setState(() {
                                  hasSuffix4 = value as bool;
                                });
                              },
                              fillColor:
                                  Theme.of(context).colorScheme.inversePrimary,
                              suffixUrl: "assets/images/closefield.svg",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: widget.widthOfData,
                          child: ColumnRequestData(isAddNew: true,
                            title: "Relationship",
                            isTextField: true,
                            hint: "Enter The Relationship",
                            textController: widget.contactRelation[i],
                            controllerfinishState: (value) {
                              setState(() {
                                widget.contactRelationfinishState!(
                                    widget.contactRelation[i]);
                                widget.helthInsurance +=
                                    1 / ((widget.contactName.length * 3) + 3);
                                widget.healthInsuranceState(
                                    widget.helthInsurance);
                              });
                            },
                            controllerState: (value) {
                              setState(() {
                                i == 0
                                    ? widget.contactRelationState(
                                        widget.contactRelation[i])
                                    : widget.secondContactRelationState(
                                        widget.contactRelation[i]);
                              });
                            },
                            isOptional: false,
                            isExpanded: true,
                            hasSuffix: hasSuffix5,
                            hassSuffixState: (value) {
                              setState(() {
                                hasSuffix5 = value as bool;
                              });
                            },
                            fillColor:
                                Theme.of(context).colorScheme.inversePrimary,
                            suffixUrl: "assets/images/closefield.svg",
                          ),
                        ),
                        SizedBox(
                          width: widget.widthOfData,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Phone Number'.tr,
                                    style:
                                        AppFontStyle.cairoRegularStyle.copyWith(
                                      fontSize: FontConstants.fontSize022.h,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inverseSurface,
                                          height: 1.6
                                    ),
                                  ),
                                   
                                  SizedBox(
                                    height: 0.055.h,
                                    child: IntlPhoneField(
                                      textAlign: TextAlign.start,
                                      // autovalidateMode: AutovalidateMode.always,
                                      pickerDialogStyle: PickerDialogStyle(
                                          searchFieldInputDecoration:
                                              InputDecoration(
                                            enabled: true,
                                            hintText: 'search',
                                            filled: true,
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .scrim,
                                                  width: 1.0,
                                                )),
                                            fillColor: Theme.of(context)
                                                .colorScheme
                                                .inversePrimary,
                                            hintStyle: TextStyle(
                                              fontSize:
                                                  FontConstants.fontSize020.h,
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  themeController.currentTheme ==
                                                          MyThemeData.lightTheme
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .scrim
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
                                      flagsButtonPadding:
                                          const EdgeInsets.only(left: 5),
                                      showDropdownIcon: false,
                                      disableLengthCheck: true,
                                      style: AppFontStyle.cairoRegularStyle
                                          .copyWith(
                                              fontSize:
                                                  FontConstants.fontSize020.h,
                                              color:
                                                  themeController.currentTheme ==
                                                          MyThemeData.lightTheme
                                                      ? MyThemeData.colorBlack
                                                      : MyThemeData.colorWhite,
                                              fontWeight: FontWeight.w400),
                                      dropdownTextStyle:
                                          AppFontStyle.cairoRegularStyle.copyWith(
                                              fontSize:
                                                  FontConstants.fontSize020.h,
                                              color:
                                                  themeController.currentTheme ==
                                                          MyThemeData.lightTheme
                                                      ? MyThemeData.colorBlack
                                                      : MyThemeData.colorWhite,
                                              fontWeight: FontWeight.w400),
                                      decoration: InputDecoration(
                                        filled: true,
                                        // contentPadding:
                                        //     Get.locale.toString().contains('en')
                                        //         ? const EdgeInsets.only(
                                        //             left: 10, top: 27)
                                        //         : const EdgeInsets.only(
                                        //             right: 10, top: 27),
                                        focusColor: const Color.fromRGBO(
                                            246, 246, 246, 1),
                                        hoverColor: const Color.fromRGBO(
                                            246, 246, 246, 1),
                                        hintText: 'Enter The Phone Number'.tr,
                                        prefix: const SizedBox(
                                          height: 22,
                                        ),
                                        hintStyle: AppFontStyle.cairoRegularStyle
                                            .copyWith(
                                                fontSize: isPortrait
                                                    ? FontConstants.fontSize016.h
                                                    : FontConstants.fontSize020.h,
                                                 
                                                color: MyThemeData.colorGrey,
                                                fontWeight: FontWeight.w400),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .scrim,
                                              width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .scrim,
                                              width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:Colors.transparent,
                                              width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.red, width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        fillColor: themeController.currentTheme ==
                                                MyThemeData.lightTheme
                                            ? Colors.white
                                            :  MyThemeData.dark,
                                      ),
                                      onCountryChanged: (value) {},
                                      initialCountryCode: 'EG',
                                      onChanged: (value) {
                                        print(
                                            'countryISOCode ${value.countryISOCode}');
                                        print('number ${value.number}');
                                        print('countryCode ${value.countryCode}');
                                        print(
                                            'completeNumber ${value.completeNumber}');
                                        i == 0
                                            ? widget.contactNumberState(value)
                                            : widget
                                                .secondContactNumberState(value);
                                      },
                                      validator: (value) {
                                        return Validator
                                            .number(value!.completeNumber);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   width: widget.widthOfData,
                        //   child: ColumnRequestData(isAddNew: true,
                        //     title: "Phone Number",
                        //     isTextField: true,
                        //     hint: "Enter The Phone Number",
                        //     textController: widget.contactNumber[i],
                        //     controllerfinishState: (value) {
                        //       setState(() {
                        //         widget.contactNumberfinishState!(
                        //             widget.contactNumber[i]);
                        //         widget.helthInsurance +=
                        //             1 / ((widget.contactName.length * 3) + 3);
                        //         widget.healthInsuranceState(
                        //             widget.helthInsurance);
                        //       });
                        //     },
                        //     controllerState: (value) {
                        //       setState(() {
                        //         i == 0
                        //             ? widget.contactNumberState(
                        //                 widget.contactNumber[i])
                        //             : widget.secondContactNumberState(
                        //                 widget.contactNumber[i]);
                        //       });
                        //     },
                        //     isOptional: false,
                        //     isExpanded: true,
                        //     hasSuffix: hasSuffix6,
                        //     hassSuffixState: (value) {
                        //       setState(() {
                        //         hasSuffix6 = value as bool;
                        //       });
                        //     },
                        //     fillColor:
                        //         Theme.of(context).colorScheme.inversePrimary,
                        //     suffixUrl: "assets/images/closefield.svg",
                        //   ),
                        // ),
                        SizedBox(
                          width: widget.widthOfData,
                          child: ColumnRequestData(isAddNew: true,
                            title: "Email",
                            isTextField: true,
                            hint: "Enter The Email",
                            textController: widget.contactEmail[i],
                            controllerfinishState: (value) {
                              setState(() {
                                widget.contactNumberfinishState!(
                                    widget.contactEmail[i]);
                                widget.helthInsurance +=
                                    1 / ((widget.contactName.length * 3) + 3);
                                widget.healthInsuranceState(
                                    widget.helthInsurance);
                              });
                            },
                            controllerState: (value) {
                              setState(() {
                                i == 0
                                    ? widget.contactEmailState(
                                        widget.contactEmail[i])
                                    : widget.secondContactEmailState(
                                        widget.contactEmail[i]);
                              });
                            },
                            isOptional: false,
                            isExpanded: true,
                            hasSuffix: hasSuffix6,
                            hassSuffixState: (value) {
                              setState(() {
                                hasSuffix6 = value as bool;
                              });
                            },
                            fillColor:
                                Theme.of(context).colorScheme.inversePrimary,
                            suffixUrl: "assets/images/closefield.svg",
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.02.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: widget.widthOfData,
                            child: ColumnRequestData(isAddNew: true,
                              title: "Country",
                              isTextField: true,
                              hint: "Enter The Country",
                              textController: widget.contactCountry[i],
                              controllerfinishState: (value) {
                                setState(() {
                                  widget.contactRelationfinishState!(
                                      widget.contactRelation[i]);
                                  widget.helthInsurance +=
                                      1 / ((widget.contactName.length * 3) + 3);
                                  widget.healthInsuranceState(
                                      widget.helthInsurance);
                                });
                              },
                              controllerState: (value) {
                                setState(() {
                                  i == 0
                                      ? widget.contactCountryState(
                                          widget.contactCountry[i])
                                      : widget.secondContactCountryState(
                                          widget.contactCountry[i]);
                                });
                              },
                              isOptional: false,
                              isExpanded: true,
                              hasSuffix: hasSuffix5,
                              hassSuffixState: (value) {
                                setState(() {
                                  hasSuffix5 = value as bool;
                                });
                              },
                              fillColor:
                                  Theme.of(context).colorScheme.inversePrimary,
                              suffixUrl: "assets/images/closefield.svg",
                            ),
                          ),
                          SizedBox(
                            width: widget.widthOfData,
                            child: ColumnRequestData(isAddNew: true,
                              title: "Province",
                              isTextField: true,
                              hint: "Enter The Province",
                              textController: widget.contactProvince[i],
                              controllerfinishState: (value) {
                                setState(() {
                                  widget.contactNumberfinishState!(
                                      widget.contactNumber[i]);
                                  widget.helthInsurance +=
                                      1 / ((widget.contactName.length * 3) + 3);
                                  widget.healthInsuranceState(
                                      widget.helthInsurance);
                                });
                              },
                              controllerState: (value) {
                                setState(() {
                                  i == 0
                                      ? widget.contactProvinceState(
                                          widget.contactProvince[i])
                                      : widget.secondContactProvinceState(
                                          widget.contactProvince[i]);
                                });
                              },
                              isOptional: false,
                              isExpanded: true,
                              hasSuffix: hasSuffix6,
                              hassSuffixState: (value) {
                                setState(() {
                                  hasSuffix6 = value as bool;
                                });
                              },
                              fillColor:
                                  Theme.of(context).colorScheme.inversePrimary,
                              suffixUrl: "assets/images/closefield.svg",
                            ),
                          ),
                          SizedBox(
                            width: widget.widthOfData,
                            child: ColumnRequestData(isAddNew: true,
                              title: "City",
                              isTextField: true,
                              hint: "Enter The City",
                              textController: widget.contactCity[i],
                              controllerfinishState: (value) {
                                setState(() {
                                  widget.contactNumberfinishState!(
                                      widget.contactNumber[i]);
                                  widget.helthInsurance +=
                                      1 / ((widget.contactName.length * 3) + 3);
                                  widget.healthInsuranceState(
                                      widget.helthInsurance);
                                });
                              },
                              controllerState: (value) {
                                setState(() {
                                  i == 0
                                      ? widget.contactCityState(
                                          widget.contactCity[i])
                                      : widget.secondContactCityState(
                                          widget.contactCity[i]);
                                });
                              },
                              isOptional: false,
                              isExpanded: true,
                              hasSuffix: hasSuffix6,
                              hassSuffixState: (value) {
                                setState(() {
                                  hasSuffix6 = value as bool;
                                });
                              },
                              fillColor:
                                  Theme.of(context).colorScheme.inversePrimary,
                              suffixUrl: "assets/images/closefield.svg",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: widget.widthOfData,
                          child: ColumnRequestData(isAddNew: true,
                            title: "Address",
                            isTextField: true,
                            hint: "Enter The Address",
                            textController: widget.contactAddress[i],
                            controllerfinishState: (value) {
                              setState(() {
                                widget.contactRelationfinishState!(
                                    widget.contactRelation[i]);
                                widget.helthInsurance +=
                                    1 / ((widget.contactName.length * 3) + 3);
                                widget.healthInsuranceState(
                                    widget.helthInsurance);
                              });
                            },
                            controllerState: (value) {
                              setState(() {
                                i == 0
                                    ? widget.contactAddressState(
                                        widget.contactAddress[i])
                                    : widget.secondContactAddressState(
                                        widget.contactAddress[i]);
                              });
                            },
                            isOptional: false,
                            isExpanded: true,
                            hasSuffix: hasSuffix5,
                            hassSuffixState: (value) {
                              setState(() {
                                hasSuffix5 = value as bool;
                              });
                            },
                            fillColor:
                                Theme.of(context).colorScheme.inversePrimary,
                            suffixUrl: "assets/images/closefield.svg",
                          ),
                        ),
                        SizedBox(
                          width: widget.widthOfData,
                        ),
                      ],
                    ),
                  ],
                );
              }),
        ),
        widget.isPreview || widget.contactName.length > 1
            ? const SizedBox.shrink()
            : Padding(
                padding: EdgeInsets.only(top: .01.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    MainCustomIconButton(
                      onPressed: () {
                        setState(() {
                          widget.contactName.add(TextEditingController());
                          widget.contactMiddleName.add(TextEditingController());
                          widget.contactLastName.add(TextEditingController());
                          widget.contactEmail.add(TextEditingController());
                          widget.contactCity.add(TextEditingController());
                          widget.contactPostalCode.add(TextEditingController());
                          widget.contactCountry.add(TextEditingController());
                          widget.contactProvince.add(TextEditingController());
                          widget.contactAddress.add(TextEditingController());

                          widget.contactNumber.add(TextEditingController());
                          widget.contactRelation.add(TextEditingController());
                        });
                      },
                      buttonText: "Add Contact".tr,
                  
                      buttonStyle: ElevatedButton.styleFrom(
                        minimumSize: Size(0.1.w, 0.058.h),
                        backgroundColor:
                            Theme.of(context).colorScheme.onTertiaryContainer,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        )),
                      ),
                    )
                  ],
                ),
              )
      ],
    );
 */ }
}
