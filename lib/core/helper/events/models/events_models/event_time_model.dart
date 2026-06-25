import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class EventTimeModel {
  List<String?>? eventTime;
  List<Timestamp?>? timestamps;
  EventTimeModel({
    this.eventTime,
    this.timestamps,
  });

  EventTimeModel copyWith({
    List<String?>? eventTime,
    List<Timestamp?>? timestamps,
  }) {
    return EventTimeModel(
      eventTime: eventTime ?? this.eventTime,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Event_Time': eventTime,
      'Timestamp': timestamps,
    };
  }

  factory EventTimeModel.fromMap(Map<String, dynamic> map) {
    return EventTimeModel(
      eventTime: map['Event_Time'] != null
          ? List<String?>.from(
              (map['Event_Time']),
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

  factory EventTimeModel.fromJson(String source) =>
      EventTimeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'EventTimeModel(EventTime: $eventTime, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant EventTimeModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.eventTime, eventTime) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => eventTime.hashCode ^ timestamps.hashCode;
}
