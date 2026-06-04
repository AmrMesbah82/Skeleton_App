import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// date:January/7/2024
// by:MohamedFouad
// lastUpdate:January/7/2024
class CheckInOutPagePermissions {
  List<String?>? checkInOutPagePermissions;
  List<Timestamp?>? timestamps;
  CheckInOutPagePermissions({
    this.checkInOutPagePermissions,
    this.timestamps,
  });

  CheckInOutPagePermissions copyWith({
    List<String?>? checkInOutPagePermissions,
    List<Timestamp?>? timestamps,
  }) {
    return CheckInOutPagePermissions(
      checkInOutPagePermissions:
          checkInOutPagePermissions ?? this.checkInOutPagePermissions,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Check_In_Out_Page_Permissions': checkInOutPagePermissions,
      'Timestamp': timestamps,
    };
  }

  factory CheckInOutPagePermissions.fromMap(Map<String, dynamic> map) {
    return CheckInOutPagePermissions(
      checkInOutPagePermissions: map['Check_In_Out_Page_Permissions'] != null
          ? List<String?>.from(
              (map['Check_In_Out_Page_Permissions']),
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

  factory CheckInOutPagePermissions.fromJson(String source) =>
      CheckInOutPagePermissions.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CheckInOutPagePermissions(Check_In_Out_Page_Permissions: $checkInOutPagePermissions, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant CheckInOutPagePermissions other) {
    if (identical(this, other)) return true;

    return listEquals(
            other.checkInOutPagePermissions, checkInOutPagePermissions) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => checkInOutPagePermissions.hashCode ^ timestamps.hashCode;
}
