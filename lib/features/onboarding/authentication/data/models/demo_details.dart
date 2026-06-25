///******************************** FILE INFO *******************************///
/// File Name: demo_details.dart
/// Purpose: Contains company demo details.
/// Author: Mohamed Elrashidy
/// Created At: 31/12/2024

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app/features/roles/role_management/domain/enums/modules_enum.dart';
import 'package:demo_app/core/helper/main_helper/single_value_tracking_model.dart';

class DemoDetails {
  String? reasonOfRejection;
  SingleValueTrackingModel<int>? numberOfUsers;
  SingleValueTrackingModel<Timestamp>? accessBegin;
  SingleValueTrackingModel<Timestamp>? accessEnd;
  SingleValueTrackingModel<String>? userName;
  SingleValueTrackingModel<String>? temporaryPassword;
  Timestamp responseTime;
  SingleValueTrackingModel<String> updatedBy;
  Map<Modules, SingleValueTrackingModel<bool>>? modules;
  DemoDetails({
    required this.reasonOfRejection,
    this.numberOfUsers,
    this.accessBegin,
    this.accessEnd,
    this.userName,
    this.temporaryPassword,
    required this.responseTime,
    required this.updatedBy,
    this.modules,
  });

  static const String REASON_OF_REJECTION = 'Reason_Of_Rejection';
  static const String NUMBER_OF_USERS = 'Number_Of_Users';
  static const String ACCESS_BEGIN = 'Access_Begin';
  static const String ACCESS = 'Access_End';
  static const String USER_NAME = 'User_Name';
  static const String TEMPORARY_PASSWORD = 'Temporary_Password';
  static const String RESPONSE_TIME = 'Response_Time';
  static const String UPDATED_BY = 'Updated_By';
  static const String MODULES = 'Modules';

  Map<String, dynamic> toMap() {
    return {
      REASON_OF_REJECTION: reasonOfRejection,
      NUMBER_OF_USERS: numberOfUsers?.toMap(),
      ACCESS_BEGIN: accessBegin?.toMap(),
      ACCESS: accessEnd?.toMap(),
      USER_NAME: userName?.toMap(),
      TEMPORARY_PASSWORD: temporaryPassword?.toMap(),
      RESPONSE_TIME: responseTime,
      UPDATED_BY: updatedBy.toMap(),
      MODULES: modules == null
          ? null
          : modules!.map((key, value) => MapEntry(key.name, value.toMap())),
    };
  }

  factory DemoDetails.fromMap(Map<String, dynamic> map) {
    return DemoDetails(
      reasonOfRejection: map[REASON_OF_REJECTION],
      numberOfUsers: map[NUMBER_OF_USERS] == null
          ? null
          : SingleValueTrackingModel.fromMap(map[NUMBER_OF_USERS]),
      accessBegin: map[ACCESS_BEGIN] == null
          ? null
          : SingleValueTrackingModel.fromMap(map[ACCESS_BEGIN]),
      accessEnd: map[ACCESS] == null
          ? null
          : SingleValueTrackingModel.fromMap(map[ACCESS]),
      userName: map[USER_NAME] == null
          ? null
          : SingleValueTrackingModel.fromMap(map[USER_NAME]),
      temporaryPassword: map[TEMPORARY_PASSWORD] == null
          ? null
          : SingleValueTrackingModel.fromMap(map[TEMPORARY_PASSWORD]),
      responseTime: map[RESPONSE_TIME],
      updatedBy: SingleValueTrackingModel.fromMap(map[UPDATED_BY]),
      modules: map[MODULES]?.map<Modules, SingleValueTrackingModel<bool>>(
              (key, value) => MapEntry(
                  Modules.values.firstWhere((element) => element.name == key),
                  SingleValueTrackingModel<bool>.fromMap(value)),
            ),
    );
  }
}
