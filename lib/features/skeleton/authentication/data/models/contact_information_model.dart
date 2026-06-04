import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../core/generic_models/single_value_tracking_model.dart';
import 'phone_model.dart';

class ContactInformationModel {
  SingleValueTrackingModel<String> firstName;
  SingleValueTrackingModel<String> lastName;
  SingleValueTrackingModel<String> email;
  PhoneModel phone;
  Timestamp approvalDate;

  ContactInformationModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.approvalDate,
  });

  static const String FIRST_NAME = 'First_Name';
  static const String LAST_NAME = 'Last_Name';
  static const String EMAIL = 'Email';
  static const String PHONE = 'Phone';
  static const String APPROVAL_DATE = 'Approval_Date';

  Map<String, dynamic> toMap() {
    return {
      FIRST_NAME: firstName.toMap(),
      LAST_NAME: lastName.toMap(),
      EMAIL: email.toMap(),
      PHONE: phone.toMap(),
      APPROVAL_DATE: approvalDate,
    };
  }

  factory ContactInformationModel.fromMap(Map<String, dynamic> map) {
    return ContactInformationModel(
      firstName: SingleValueTrackingModel<String>.fromMap(map[FIRST_NAME]),
      lastName: SingleValueTrackingModel<String>.fromMap(map[LAST_NAME]),
      email: SingleValueTrackingModel<String>.fromMap(map[EMAIL]),
      phone: PhoneModel.fromMap(map[PHONE]),
      approvalDate: map[APPROVAL_DATE],
    );
  }
}
