import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class HasReminder {
  List<bool?>? hasReminder;
  List<Timestamp?>? timestamps;

  HasReminder({
    this.hasReminder,
    this.timestamps,
  });

  HasReminder copyWith({
    List<bool?>? hasReminder,
    List<Timestamp?>? timestamps,
  }) {
    return HasReminder(
      hasReminder: hasReminder ?? this.hasReminder,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Has_Reminder': hasReminder,
      'Timestamp': timestamps,
    };
  }

  factory HasReminder.fromMap(Map<String, dynamic> map) {
    return HasReminder(
      hasReminder: map['Has_Reminder'] != null
          ? List<bool?>.from(
              (map['Has_Reminder']),
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

  factory HasReminder.fromJson(String source) =>
      HasReminder.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'HasReminder(hasReminder: $hasReminder ,Timestamp: $timestamps)';

  @override
  bool operator ==(covariant HasReminder other) {
    if (identical(this, other)) return true;

    return listEquals(other.hasReminder, hasReminder) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => hasReminder.hashCode ^ timestamps.hashCode;
}
