import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:demo_app/features/skeleton/employees/presentation/ui/pages/add_new_employee_person_info.dart';
import 'package:demo_app/components/employees_components/employees_hr_components/employee_hr_profile_components/Permissions.dart';
import 'package:demo_app/components/employees_components/employees_hr_components/employee_hr_profile_components/additional_information.dart';
import 'package:demo_app/components/employees_components/employees_hr_components/employee_hr_profile_components/custom_expandable_container.dart';
import 'package:demo_app/components/employees_components/employees_hr_components/employee_hr_profile_components/health_insurance_view.dart';
import 'package:demo_app/components/employees_components/employees_hr_components/employee_hr_profile_components/position_details.dart';
import 'package:demo_app/components/employees_components/employees_hr_components/employees_hr_subwidgets/permissions_container.dart';
import 'package:demo_app/components/lib/phone_number.dart';
import 'package:demo_app/core/enumeration/enum.dart';
import 'package:demo_app/core/helper/haptic_controller.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/constants/nationalities_list.dart';
import 'package:demo_app/core/theme/screen_size.dart';

// ignore: must_be_immutable
class PreviewView extends StatefulWidget {
  PreviewView({
    required this.departmentState,
    required this.roleState,
    required this.typeState,
    required this.currencyState,
    required this.jobCombensationState,
    required this.jobLocationState,
    required this.salaryState,
    required this.daysState,
    required this.weekEndsState,
    required this.assetState,
    required this.assetDescriptionState,
    required this.assetIdState,
    required this.assetNameState,
    super.key,
    required this.additionalInfo,
    required this.country,
    required this.city,
    required this.address,
    required this.province,
    required this.email,
    required this.firstName,
    required this.gender,
    required this.healthInsuranceValue,
    required this.language,
    required this.lastName,
    required this.maritalStatus,
    required this.nation,
    required this.permissions,
    required this.personalInfoValue,
    required this.phone,
    required this.preview,
    required this.psitionDetailsValue,
    required this.contactName,
    required this.contactNumber,
    required this.contactRelation,
    required this.insuranceName,
    required this.insurancePoliceName,
    required this.phoneNumberInsu,
    required this.asset,
    required this.assetDescription,
    required this.assetId,
    required this.assetName,
    required this.currency,
    required this.days,
    required this.department,
    required this.jobCompensation,
    required this.jobLocation,
    required this.role,
    required this.salary,
    required this.type,
    required this.weekends,
    required this.emailState,
    required this.phoneState,
    required this.countryState,
    required this.provinceState,
    required this.cityState,
    required this.addressState,
    required this.nationaldState,
    required this.firstNameState,
    required this.lastNameState,
    required this.genderState,
    required this.nationState,
    required this.maritalStatusState,
    required this.languageState,
    required this.insuranceNameState,
    required this.insurancePoliceNameState,
    required this.phoneNumberInsuState,
    required this.contactNameState,
    required this.contactNumberState,
    required this.contactRelationState,
    required this.birthdate,
    required this.birthdateState,
    required this.middleName,
    required this.nationalId,
    required this.assetsCount,
  });
  TextEditingController firstName;
  TextEditingController lastName;
  TextEditingController middleName;
  TextEditingController email;
  TextEditingController phone;
  TextEditingController country;
  TextEditingController city;
  TextEditingController address;
  TextEditingController province;
  TextEditingController birthdate;
  TextEditingController nationalId;
  ValueChanged<TextEditingController> birthdateState;
  ValueChanged<TextEditingController> contactNumberState;
  ValueChanged<TextEditingController> contactRelationState;
  ValueChanged<TextEditingController> contactNameState;
  ValueChanged<TextEditingController> phoneNumberInsuState;
  ValueChanged<TextEditingController> insurancePoliceNameState;
  ValueChanged<TextEditingController> insuranceNameState;
  ValueChanged<TextEditingController> assetDescriptionState;
  ValueChanged<TextEditingController> assetIdState;
  ValueChanged<TextEditingController> assetNameState;
  ValueChanged<String?> assetState;
  ValueChanged<String?> weekEndsState;
  ValueChanged<String?> daysState;
  ValueChanged<TextEditingController> salaryState;
  ValueChanged<String?> departmentState;
  ValueChanged<String?> roleState;
  ValueChanged<String?> typeState;
  ValueChanged<String?> jobLocationState;
  ValueChanged<String?> jobCombensationState;
  ValueChanged<String?> currencyState;
  ValueChanged<TextEditingController> emailState;
  ValueChanged<TextEditingController> phoneState;
  ValueChanged<TextEditingController> countryState;
  ValueChanged<TextEditingController> cityState;
  ValueChanged<TextEditingController> nationaldState;
  ValueChanged<TextEditingController> addressState;
  ValueChanged<TextEditingController> provinceState;
  ValueChanged<TextEditingController> firstNameState;
  ValueChanged<TextEditingController> lastNameState;
  ValueChanged<String?> genderState;
  ValueChanged<String?> nationState;
  ValueChanged<String?> maritalStatusState;
  ValueChanged<String?> languageState;
  double personalInfoValue;
  double healthInsuranceValue;
  double psitionDetailsValue;
  double additionalInfo;
  double permissions;
  double preview;
  String? gender;
  String? nation;
  String? maritalStatus;
  String? language;
  TextEditingController insuranceName;
  TextEditingController insurancePoliceName;
  TextEditingController phoneNumberInsu;
  List<TextEditingController> contactName;
  List<TextEditingController> contactRelation;
  List<TextEditingController> contactNumber;
  // position Details
  String? department;
  String? role;
  String? type;
  String? jobLocation;
  String? jobCompensation;
  String? currency;
  TextEditingController salary;
  String? days;
  String? weekends;
  String? asset;
  TextEditingController assetName;
  TextEditingController assetId;
  TextEditingController assetDescription;
  int assetsCount;

  @override
  State<PreviewView> createState() => _PreviewViewState();
}

class _PreviewViewState extends State<PreviewView> {
  bool expanded1 = false;
  bool expanded2 = false;
  bool expanded3 = false;
  bool expanded4 = false;
  bool expanded5 = false;
  double widthOfData = 0.27.w;
  Color containerColor = MyThemeData.signOut;
  Color textColor = MyThemeData.colorBlack;
  SizedBox space = SizedBox(
    height: 0.03.h,
  );
  final HapticController hapticController = Get.put(HapticController());
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          children: [
            GestureDetector(
              onTap: () {
                hapticController.triggerHapticFeedback(
                    vibration: VibrateType.lightImpact,
                    hapticFeedback: HapticFeedback.lightImpact);
                setState(() {
                  expanded1 = !expanded1;
                });
              },
              child: ExpandableContainer(
                expanded: expanded1,
                paddingV: 0.013.h,
                title: "Personal Information",
                color: containerColor,
                textColor: textColor,
              ),
            ),
            expanded1
                ? Padding(
                    padding: EdgeInsets.only(
                        top: 0.01.h, left: 0.015.w, right: 0.015.w),
                    child: AddNewEmployeePersonInfo(
                      addressState: (value) {
                        setState(() {
                          widget.addressState(widget.address);
                        });
                      },
                      nationalIdState: (value) {
                        setState(() {
                          widget.nationaldState(widget.nationalId);
                        });
                      },
                      addressfinishState: (value) {
                        setState(() {});
                      },
                      isPreview: true,
                      cityState: (value) {
                        setState(() {
                          widget.cityState(widget.city);
                        });
                      },
                      cityfinishState: (value) {
                        setState(() {});
                      },
                      provinceState: (value) {
                        setState(() {
                          widget.provinceState(widget.province);
                        });
                      },
                      provincefinishState: (value) {
                        setState(() {});
                      },
                      MiddleNameState: (value) {
                        setState(() {});
                      },
                      MiddlenNamefinishState: (value) {
                        setState(() {});
                      },
                      nationalIdfinishState: (value) {
                        setState(() {});
                      },
                      birthDateState: (value) {
                        setState(() {
                          widget.birthdateState(widget.birthdate);
                        });
                      },
                      birthDatefinishState: (value) {
                        setState(() {});
                      },
                      widthOfData: widthOfData,
                      personInfoCount: widget.personalInfoValue,
                      personInfoState: (value) {
                        setState(() {
                          widget.personalInfoValue = value;
                        });
                      },
                      firstNamefinishState: (value) {
                        setState(() {
                          //  firstName;
                          //  personalInfoValue += 1 / 9;
                        });
                      },
                      countryfinishState: (value) {
                        setState(() {});
                      },
                      emailfinishState: (value) {
                        setState(() {});
                      },
                      lastNamefinishState: (value) {
                        setState(() {});
                      },
                      phonefinishState: (value) {
                        setState(() {});
                      },
                      firstNameState: (value) {
                        setState(() {
                          widget.firstNameState(widget.firstName);
                        });
                      },
                      lastNameState: (value) {
                        setState(() {
                          widget.lastNameState(widget.lastName);
                        });
                      },
                      gender: widget.gender,
                      genderState: (value) {
                        setState(() {
                          widget.gender = value;
                          widget.genderState(widget.gender);
                        });
                        setState(() {});
                      },
                      emailState: (value) {
                        setState(() {
                          widget.emailState(widget.email);
                        });
                      },
                      phoneState: (value) {
                        setState(() {
                          widget.phoneState(widget.phone);
                        });
                      },
                      countryState: (value) {
                        setState(() {
                          widget.countryState(widget.country);
                        });
                      },
                      nation: widget.nation,
                      nationState: (value) {
                        setState(() {
                          widget.nation = value;
                          widget.nationState(widget.nation);
                        });
                        setState(() {});
                      },
                      maritalStatus: widget.maritalStatus,
                      maritalStatusState: (value) {
                        setState(() {
                          widget.maritalStatus = value;
                          widget.maritalStatusState(widget.maritalStatus);
                        });
                        setState(() {});
                      },
                      language: widget.language,
                      languageState: (value) {
                        setState(() {
                          widget.language = value;
                          widget.languageState(widget.language);
                        });
                        setState(() {});
                      },
                      passportNumberState: (value) {},
                      passportDateState: (String value) {},
                      postalState: (TextEditingController value) {},
                      nationalDateState: (String value) {},
                      firstNameStateInArabic: (value) {},
                      lastNameStateInArabic: (value) {},
                      MiddleNameStateInArabic: (value) {},
                    ), // const PermissionContainer(),
                  )
                : const SizedBox.shrink(),
          ],
        ),
        space,
        Column(
          children: [
            GestureDetector(
              onTap: () {
                hapticController.triggerHapticFeedback(
                    vibration: VibrateType.lightImpact,
                    hapticFeedback: HapticFeedback.lightImpact);
                setState(() {
                  expanded2 = !expanded2;
                });
              },
              child: ExpandableContainer(
                expanded: expanded2,
                title: "Health Insurance",
                paddingV: 0.013.h,
                color: containerColor,
                textColor: textColor,
              ),
            ),
            expanded2
                ? SizedBox(
                    height: 0.35.h,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 0.01.h, left: 0.015.w, right: 0.015.w),
                      child: HealthInsuranceView(
                        widthOfData: widthOfData,
                        isPreview: true,
                        insuranceName: widget.insuranceName,
                        insuranceNameState: (value) {
                          setState(() {
                            widget.insuranceNameState(widget.insuranceName);
                          });
                        },
                        insuranceNamefinishState: (value) {
                          setState(() {});
                        },
                        helthInsurance: widget.healthInsuranceValue,
                        healthInsuranceState: (value) {
                          setState(() {});
                        },
                        contactName: widget.contactName,
                        contactNameState: (value) {
                          setState(() {
                            widget.contactNameState(value);
                          });
                        },
                        contactNamefinishState: (value) {
                          setState(() {});
                        },
                        contactNumber: widget.contactNumber,
                        contactNumberState: (value) {
                          setState(() {});
                        },
                        contactNumberfinishState: (value) {
                          setState(() {});
                        },
                        contactRelation: widget.contactRelation,
                        contactRelationState: (value) {
                          setState(() {
                            widget.contactRelationState(value);
                          });
                        },
                        contactRelationfinishState: (value) {
                          setState(() {});
                        },
                        insurancePoliceName: widget.insurancePoliceName,
                        insurancePoliceNameState: (value) {
                          setState(() {
                            widget.insurancePoliceNameState(
                                widget.insurancePoliceName);
                          });
                        },
                        insurancePoliceNamefinishState: (value) {
                          setState(() {});
                        },
                        phoneNumberInsu: widget.phoneNumberInsu,
                        phoneNumberInsuState: (value) {
                          setState(() {
                            widget.phoneNumberInsuState(widget.phoneNumberInsu);
                          });
                        },
                        phoneNumberInsufinishState: (value) {
                          setState(() {});
                        },
                        contactMiddleName: [],
                        contactLastName: [],
                        contactEmail: [],
                        contactAddress: [],
                        contactCity: [],
                        contactCountry: [],
                        contactProvince: [],
                        contactMiddleNameState:
                            (TextEditingController value) {},
                        contactLastNameState: (TextEditingController value) {},
                        contactEmailState: (TextEditingController value) {},
                        contactAddressState: (TextEditingController value) {},
                        contactCityState: (TextEditingController value) {},
                        contactCountryState: (TextEditingController value) {},
                        contactProvinceState: (TextEditingController value) {},
                        secondContactNameState:
                            (TextEditingController value) {},
                        secondContactMiddleNameState:
                            (TextEditingController value) {},
                        secondContactLastNameState:
                            (TextEditingController value) {},
                        secondContactEmailState:
                            (TextEditingController value) {},
                        secondContactAddressState:
                            (TextEditingController value) {},
                        secondContactCityState:
                            (TextEditingController value) {},
                        secondContactCountryState:
                            (TextEditingController value) {},
                        secondContactProvinceState:
                            (TextEditingController value) {},
                        secondContactRelationState:
                            (TextEditingController value) {},
                        secondContactNumberState: (PhoneNumber value) {},
                        contactPostalCode: [],
                        contactPostalCodeState:
                            (TextEditingController value) {},
                        secondContactPostalCodeState:
                            (TextEditingController value) {},
                      ), // const PermissionContainer(),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
        space,
        Column(
          children: [
            GestureDetector(
              onTap: () {
                hapticController.triggerHapticFeedback(
                    vibration: VibrateType.lightImpact,
                    hapticFeedback: HapticFeedback.lightImpact);
                setState(() {
                  expanded3 = !expanded3;
                });
              },
              child: ExpandableContainer(
                expanded: expanded3,
                title: "Position Details",
                paddingV: 0.013.h,
                color: containerColor,
                textColor: textColor,
              ),
            ),
            expanded3
                ? Padding(
                    padding: EdgeInsets.only(
                        top: 0.01.h, left: 0.015.w, right: 0.015.w),
                    child: PositionDetailsView(
                      isPreview: true,
                      widthOfData: widthOfData,
                      departmentState: (value) {
                        setState(() {
                          widget.department = value;
                          widget.departmentState(widget.department);
                        });
                      },
                      role: widget.role,
                      roleState: (value) {
                        setState(() {
                          widget.role = value;
                          widget.roleState(widget.role);
                        });
                      },
                      type: widget.type,
                      typeState: (value) {
                        setState(() {
                          widget.type = value;
                          widget.typeState(widget.type);
                        });
                      },
                      currency: widget.currency,
                      currencyState: (value) {
                        setState(() {
                          widget.currency = value;
                          widget.currencyState(widget.currency);
                        });
                      },
                      department: widget.department,
                      jobCombensationState: (value) {
                        setState(() {
                          widget.jobCompensation = value;

                          widget.jobCombensationState(widget.jobCompensation);
                        });
                      },
                      jobCompensation: widget.jobCompensation,
                      jobLocation: widget.jobLocation,
                      jobLocationState: (value) {
                        setState(() {
                          widget.jobLocation = value;
                          widget.jobLocationState(widget.jobLocation);
                        });
                      },
                      salary: widget.salary,
                      salaryState: (value) {
                        setState(() {
                          widget.salaryState(widget.salary);
                        });
                      },
                      salaryfinishState: (value) {
                        setState(() {});
                      },
                      days: widget.days,
                      daysState: (value) {
                        setState(() {
                          widget.days = value;
                          widget.daysState(widget.days);
                        });
                      },
                      weekEndsState: (value) {
                        setState(() {
                          widget.weekEndsState(widget.weekends);
                        });
                      },
                      weekends: widget.weekends,
                      startTime: null,
                      startTimeState: (TimeOfDay value) {},
                      endTime: null,
                      endTimeState: (TimeOfDay value) {},
                      title: TextEditingController(),
                      titleState: (value) {},
                      titleInArabic: TextEditingController(),
                      titleStateInArabic: (value) {},
                    ) // const PermissionContainer(),
                    )
                : const SizedBox.shrink(),
          ],
        ),
        space,
        Column(
          children: [
            GestureDetector(
              onTap: () {
                hapticController.triggerHapticFeedback(
                    vibration: VibrateType.lightImpact,
                    hapticFeedback: HapticFeedback.lightImpact);
                setState(() {
                  expanded4 = !expanded4;
                });
              },
              child: ExpandableContainer(
                expanded: expanded4,
                title: "Additional Information",
                paddingV: 0.013.h,
                color: containerColor,
                textColor: textColor,
              ),
            ),
            expanded4
                ? Padding(
                    padding: EdgeInsets.only(
                        top: 0.01.h, left: 0.015.w, right: 0.015.w),
                    child: AdditionInformations(
                      name: "${widget.firstName.text}_${widget.lastName.text}",
                      isPreview: true,
                      addInfoState: (value) {
                        setState(() {
                          widget.additionalInfo = value;
                        });
                      },
                      additionalInfo: widget.additionalInfo,
                    ) // const PermissionContainer(),
                    )
                : const SizedBox.shrink(),
          ],
        ),
        space,
        Column(
          children: [
            GestureDetector(
              onTap: () {
                hapticController.triggerHapticFeedback(
                    vibration: VibrateType.lightImpact,
                    hapticFeedback: HapticFeedback.lightImpact);
                setState(() {
                  expanded5 = !expanded5;
                });
              },
              child: ExpandableContainer(
                expanded: expanded5,
                title: "Permissions",
                color: containerColor,
                paddingV: 0.013.h,
                textColor: textColor,
              ),
            ),
            expanded5
                ? Padding(
                    padding: EdgeInsets.only(
                        top: 0.01.h, left: 0.015.w, right: 0.015.w),
                    child: const PermissionsView(),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ],
    );
  }
}
