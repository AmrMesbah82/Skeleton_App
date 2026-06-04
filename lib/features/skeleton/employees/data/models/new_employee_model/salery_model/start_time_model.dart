import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// date:January/7/2024
// by:MohamedFouad
// lastUpdate:January/7/2024
class StartTime {
  List<String?>? startTimes;
  List<Timestamp?>? timestamps;
  StartTime({
    this.startTimes,
    this.timestamps,
  });

  StartTime copyWith({
    List<String?>? startTimes,
    List<Timestamp?>? timestamps,
  }) {
    return StartTime(
      startTimes: startTimes ?? this.startTimes,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Start_Time': startTimes,
      'Timestamp': timestamps,
    };
  }

  factory StartTime.fromMap(Map<String, dynamic> map) {
    return StartTime(
      startTimes: map['Start_Time'] != null
          ? List<String?>.from(
              (map['Start_Time']),
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

  factory StartTime.fromJson(String source) =>
      StartTime.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'StartTime(Start_Time: $startTimes, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant StartTime other) {
    if (identical(this, other)) return true;

    return listEquals(other.startTimes, startTimes) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => startTimes.hashCode ^ timestamps.hashCode;
}
