///************************** FILE INFO **************************///
/// File Name: company_information_model.dart
/// Purpose: Contains the model for holding company information over time.
/// Author: Mohamed Elrashidy
/// Created At: 31/12/2024

import 'package:demo_app/features/onboarding/helper/enum_single_value_tracking_model.dart';

import '../../../../../core/enums/company_size_list.dart';
import '../../../../../core/enums/industry.dart';
import 'package:demo_app/core/helper/main_helper/single_value_tracking_model.dart';

class CompanyInformationModel {
  SingleValueTrackingModel<String> companyName;
  SingleValueTrackingModel<String> companyAddress;
  SingleValueTrackingModel<String> taxNumber;
  SingleValueTrackingModel<String> country;
  SingleValueTrackingModel<String> city;
  SingleValueTrackingModel<String> province;
  SingleValueTrackingModel<String> zipCode;
  EnumSingleValueTrackingModel<Industry> companyIndustry;
  EnumSingleValueTrackingModel<CompanySize> companySize;

  CompanyInformationModel({
    required this.companyName,
    required this.companyAddress,
    required this.taxNumber,
    required this.country,
    required this.city,
    required this.province,
    required this.zipCode,
    required this.companyIndustry,
    required this.companySize,
  });

  static const String COMPANY_NAME = 'Company_Name';
  static const String COMPANY_ADDRESS = 'Company_Address';
  static const String TAX_NUMBER = 'Tax_Number';
  static const String COUNTRY = 'Country';
  static const String CITY = 'City';
  static const String PROVINCE = 'Province';
  static const String ZIP_CODE = 'Zip_Code';
  static const String COMPANY_INDUSTRY = 'Company_Industry';
  static const String COMPANY_SIZE = 'Company_Size';

  Map<String, dynamic> toMap() {
    return {
      COMPANY_NAME: companyName.toMap(),
      COMPANY_ADDRESS: companyAddress.toMap(),
      TAX_NUMBER: taxNumber.toMap(),
      COUNTRY: country.toMap(),
      CITY: city.toMap(),
      PROVINCE: province.toMap(),
      ZIP_CODE: zipCode.toMap(),
      COMPANY_INDUSTRY: companyIndustry.toMap(),
      COMPANY_SIZE: companySize.toMap(),
    };
  }

  factory CompanyInformationModel.fromMap(Map<String, dynamic> map) {
    return CompanyInformationModel(
      companyName: SingleValueTrackingModel<String>.fromMap(map[COMPANY_NAME]),
      companyAddress:
          SingleValueTrackingModel<String>.fromMap(map[COMPANY_ADDRESS]),
      taxNumber: SingleValueTrackingModel<String>.fromMap(map[TAX_NUMBER]),
      country: SingleValueTrackingModel<String>.fromMap(map[COUNTRY]),
      city: SingleValueTrackingModel<String>.fromMap(map[CITY]),
      province: SingleValueTrackingModel<String>.fromMap(map[PROVINCE]),
      zipCode: SingleValueTrackingModel<String>.fromMap(map[ZIP_CODE]),
      companyIndustry:
          EnumSingleValueTrackingModel<Industry>.fromMap(map[COMPANY_INDUSTRY]),
      companySize:
          EnumSingleValueTrackingModel<CompanySize>.fromMap(map[COMPANY_SIZE]),
    );
  }
}
