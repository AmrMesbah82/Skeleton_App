import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// date:January/7/2024
// by:MohamedFouad
// lastUpdate:January/7/2024
class DrivingLicense {
  List<String?>? drivingLicense;
  List<Timestamp?>? timestamps;
  DrivingLicense({
    this.drivingLicense,
    this.timestamps,
  });

  DrivingLicense copyWith({
    List<String?>? drivingLicense,
    List<Timestamp?>? timestamps,
  }) {
    return DrivingLicense(
      drivingLicense: drivingLicense ?? this.drivingLicense,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Driving_License': drivingLicense,
      'Timestamp': timestamps,
    };
  }

  factory DrivingLicense.fromMap(Map<String, dynamic> map) {
    return DrivingLicense(
      drivingLicense: map['Driving_License'] != null
          ? List<String?>.from(
              (map['Driving_License']),
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

  factory DrivingLicense.fromJson(String source) =>
      DrivingLicense.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'DrivingLicense(Driving_License: $drivingLicense, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant DrivingLicense other) {
    if (identical(this, other)) return true;

    return listEquals(other.drivingLicense, drivingLicense) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => drivingLicense.hashCode ^ timestamps.hashCode;
}
