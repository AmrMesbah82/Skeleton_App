import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// date:January/7/2024
// by:MohamedFouad
// lastUpdate:January/7/2024
class WorkDays {
  List<String?>? workDays;
  List<Timestamp?>? timestamps;
  WorkDays({
    this.workDays,
    this.timestamps,
  });

  WorkDays copyWith({
    List<String?>? workDays,
    List<Timestamp?>? timestamps,
  }) {
    return WorkDays(
      workDays: workDays ?? this.workDays,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Work_Days': workDays,
      'Timestamp': timestamps,
    };
  }

  factory WorkDays.fromMap(Map<String, dynamic> map) {
    return WorkDays(
      workDays: map['Work_Days'] != null
          ? List<String?>.from(
              (map['Work_Days']),
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

  factory WorkDays.fromJson(String source) =>
      WorkDays.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'WorkDays(Work_Days: $workDays, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant WorkDays other) {
    if (identical(this, other)) return true;

    return listEquals(other.workDays, workDays) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => workDays.hashCode ^ timestamps.hashCode;
}
