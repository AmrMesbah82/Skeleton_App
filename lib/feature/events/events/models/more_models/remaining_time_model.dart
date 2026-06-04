import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class TimeTakenModel {
  List<String?>? remainingTime;
  List<Timestamp?>? timestamps;

  TimeTakenModel({
    this.remainingTime,
    this.timestamps,
  });

  TimeTakenModel copyWith({
    List<String?>? remainingTime,
    List<Timestamp?>? timestamps,
  }) {
    return TimeTakenModel(
      remainingTime: remainingTime ?? this.remainingTime,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Remaining_Time': remainingTime ?? [null],
      'Timestamp': timestamps ?? [null],
    };
  }

  factory TimeTakenModel.fromMap(Map<String, dynamic> map) {
    return TimeTakenModel(
      remainingTime: map['Remaining_Time'] != null
          ? List<String?>.from((map['Remaining_Time']))
          : null,
      timestamps: map['Timestamp'] != null
          ? List<Timestamp?>.from(
              (map['Timestamp']),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TimeTakenModel.fromJson(String source) =>
      TimeTakenModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ExamRemainigTime(Remaining_Time: $remainingTime, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant TimeTakenModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.remainingTime, remainingTime) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => remainingTime.hashCode ^ timestamps.hashCode;
}
