///************************ FILES INFO ************************ ///
/// File Name: phone_model.dart
/// Purpose: Contains the model for tracking a phone number over time.
/// Author: Mohamed Elrashidy
/// Created At: 31/12/2024
import 'package:cloud_firestore/cloud_firestore.dart';

class PhoneModel {
  List<String> phoneNumber;
  List<String> countryCode;
  List<Timestamp> timestamps;

  PhoneModel({
    required this.phoneNumber,
    required this.countryCode,
    required this.timestamps,
  });

  static const String PHONE_NUMBER = 'Phone_Number';
  static const String COUNTRY_CODE = 'Country_Code';
  static const String TIMESTAMPS = 'Timestamps';

  Map<String, dynamic> toMap() {
    return {
      PHONE_NUMBER: phoneNumber,
      COUNTRY_CODE: countryCode,
      TIMESTAMPS: timestamps,
    };
  }

  factory PhoneModel.fromMap(Map<String, dynamic> map) {
    return PhoneModel(
      phoneNumber: List<String>.from(map[PHONE_NUMBER]),
      countryCode: List<String>.from(map[COUNTRY_CODE]),
      timestamps: List<Timestamp>.from(map[TIMESTAMPS]),
    );
  }
}
