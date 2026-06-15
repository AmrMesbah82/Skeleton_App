import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// date:January/7/2024
// by:MohamedFouad
// lastUpdate:January/7/2024
class SettingPagePermissions {
  List<String?>? settingPagePermissions;
  List<Timestamp?>? timestamps;
  SettingPagePermissions({
    this.settingPagePermissions,
    this.timestamps,
  });

  SettingPagePermissions copyWith({
    List<String?>? settingPagePermissions,
    List<Timestamp?>? timestamps,
  }) {
    return SettingPagePermissions(
      settingPagePermissions:
          settingPagePermissions ?? this.settingPagePermissions,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Setting_Page_Permissions': settingPagePermissions,
      'Timestamp': timestamps,
    };
  }

  factory SettingPagePermissions.fromMap(Map<String, dynamic> map) {
    return SettingPagePermissions(
      settingPagePermissions: map['Setting_Page_Permissions'] != null
          ? List<String?>.from(
              (map['Setting_Page_Permissions']),
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

  factory SettingPagePermissions.fromJson(String source) =>
      SettingPagePermissions.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SettingPagePermissions(Setting_Page_Permissions: $settingPagePermissions, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant SettingPagePermissions other) {
    if (identical(this, other)) return true;

    return listEquals(other.settingPagePermissions, settingPagePermissions) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => settingPagePermissions.hashCode ^ timestamps.hashCode;
}
