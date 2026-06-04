import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class EventReminderModel {
  List<String?>? reminderDate;
  List<String?>? reminderTime;
  List<Timestamp?>? timestamps;
  EventReminderModel({
    this.reminderDate,
    this.reminderTime,
    this.timestamps,
  });

  EventReminderModel copyWith({
    List<String?>? reminderDate,
    List<String?>? reminderTime,
    List<Timestamp?>? timestamps,
  }) {
    return EventReminderModel(
      reminderDate: reminderDate ?? this.reminderDate,
      reminderTime: reminderTime ?? this.reminderTime,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Reminder_Date': reminderDate,
      'Reminder_Time': reminderTime,
      'Timestamp': timestamps,
    };
  }

  factory EventReminderModel.fromMap(Map<String, dynamic> map) {
    return EventReminderModel(
      reminderDate: map['Reminder_Date'] != null
          ? List<String?>.from(
              (map['Reminder_Date']),
            )
          : null,
      reminderTime: map['Reminder_Time'] != null
          ? List<String?>.from(
              (map['Reminder_Time']),
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

  factory EventReminderModel.fromJson(String source) =>
      EventReminderModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'EventReminderModel(reminderDate: $reminderDate, reminderTime: $reminderTime)';

  @override
  bool operator ==(covariant EventReminderModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.reminderDate, reminderDate) &&
        listEquals(other.reminderTime, reminderTime);
  }

  @override
  int get hashCode => reminderDate.hashCode ^ reminderTime.hashCode;
}
