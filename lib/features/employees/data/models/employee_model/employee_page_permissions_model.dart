import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// date:January/7/2024
// by:MohamedFouad
// lastUpdate:January/7/2024
class EmployeePagePermissions {
  List<String?>? employeePagePermissions;
  List<Timestamp?>? timestamps;
  EmployeePagePermissions({
    this.employeePagePermissions,
    this.timestamps,
  });

  EmployeePagePermissions copyWith({
    List<String?>? employeePagePermissions,
    List<Timestamp?>? timestamps,
  }) {
    return EmployeePagePermissions(
      employeePagePermissions:
          employeePagePermissions ?? this.employeePagePermissions,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Employee_Page_Permissions': employeePagePermissions,
      'Timestamp': timestamps,
    };
  }

  factory EmployeePagePermissions.fromMap(Map<String, dynamic> map) {
    return EmployeePagePermissions(
      employeePagePermissions: map['Employee_Page_Permissions'] != null
          ? List<String?>.from(
              (map['Employee_Page_Permissions']),
            )
          : null,
      timestamps: map['Timestamp'] != null
          ? List<Timestamp?>.from(
              (map['Timestamp']),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EmployeePagePermissions.fromJson(String source) =>
      EmployeePagePermissions.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'EmployeePagePermissions(Employee_Page_Permissions: $employeePagePermissions, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant EmployeePagePermissions other) {
    if (identical(this, other)) return true;

    return listEquals(other.employeePagePermissions, employeePagePermissions) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => employeePagePermissions.hashCode ^ timestamps.hashCode;
}
