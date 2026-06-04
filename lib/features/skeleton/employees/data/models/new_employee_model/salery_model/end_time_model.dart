import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// date:January/7/2024
// by:MohamedFouad
// lastUpdate:January/7/2024
class EndTime {
  List<String?>? endTimes;
  List<Timestamp?>? timestamps;
  EndTime({
    this.endTimes,
    this.timestamps,
  });

  EndTime copyWith({
    List<String?>? endTimes,
    List<Timestamp?>? timestamps,
  }) {
    return EndTime(
      endTimes: endTimes ?? this.endTimes,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'End_Time': endTimes,
      'Timestamp': timestamps,
    };
  }

  factory EndTime.fromMap(Map<String, dynamic> map) {
    return EndTime(
      endTimes: map['End_Time'] != null
          ? List<String?>.from(
              (map['End_Time']),
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

  factory EndTime.fromJson(String source) =>
      EndTime.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'EndTime(End_Time: $endTimes, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant EndTime other) {
    if (identical(this, other)) return true;

    return listEquals(other.endTimes, endTimes) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => endTimes.hashCode ^ timestamps.hashCode;
}
