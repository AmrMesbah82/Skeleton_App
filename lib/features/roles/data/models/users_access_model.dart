///********************** FILE INFO ********************///
/// File_Name: users_access_model.dart
/// Purpose: holds user permissions data model.
/// Author: Mohamed Elrashidy
/// Created at: 20/1/2025
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/generic_models/single_value_tracking_model.dart';

class UserPermissionModel {
  SingleValueTrackingModel<String> role;
  SingleValueTrackingModel<String> fromDate;
  SingleValueTrackingModel<String> toDate;
  SingleValueTrackingModel<String> editBy;
  String employeeId;
  UserPermissionModel({
    required this.employeeId,
    required this.role,
    required this.fromDate,
    required this.toDate,
    required this.editBy,
  }){
    _updateEditBy();
  }

  static const String EMPLOYEE_ID = "Employee_Id";
  static const String ROLE = "Role";
  static const String CREATED_BY = "Created_By";
  static const String FROM_DATE = "From_Date";
  static const String TO_DATE = "To_Date";
  static const String EDIT_BY = "Edit_By";
  static const String TIMESTAMP = "Timestamp";


  Map<String,dynamic> toMap() {
    return {
      EMPLOYEE_ID: employeeId,
      ROLE: role.toMap(),
      FROM_DATE: fromDate.toMap(),
      TO_DATE: toDate.toMap(),
      EDIT_BY: editBy.toMap(),
    };
  }

  factory UserPermissionModel.fromMap(Map<String,dynamic> map) {
    return UserPermissionModel(
      employeeId: map[EMPLOYEE_ID],
      role: SingleValueTrackingModel<String>.fromMap(map[ROLE]),
      fromDate: SingleValueTrackingModel<String>.fromMap(map[FROM_DATE]),
      toDate: SingleValueTrackingModel<String>.fromMap(map[TO_DATE]),
      editBy: SingleValueTrackingModel<String>.fromMap(map[EDIT_BY]),

    );
  }

  void _updateEditBy() {
    if(editBy.values.lastOrNull == 'admin@bayanatz.com'||editBy.values.lastOrNull == 'admin@baynatz.com'||editBy.values.isEmpty)
     {
       editBy.values.add('ibrahim_saeed_1702@bayanatz.com');
       editBy.timestamps.add(Timestamp.now());
     }
  }





}
