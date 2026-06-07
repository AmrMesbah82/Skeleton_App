import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class EventDateModel {
  List<String?>? eventDate;
  List<Timestamp?>? timestamps;
  EventDateModel({
    this.eventDate,
    this.timestamps,
  });

  EventDateModel copyWith({
    List<String?>? eventDate,
    List<Timestamp?>? timestamps,
  }) {
    return EventDateModel(
      eventDate: eventDate ?? this.eventDate,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Event_Date': eventDate,
      'Timestamp': timestamps,
    };
  }

  factory EventDateModel.fromMap(Map<String, dynamic> map) {
    return EventDateModel(
      eventDate: map['Event_Date'] != null
          ? List<String?>.from(
              (map['Event_Date']),
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

  factory EventDateModel.fromJson(String source) =>
      EventDateModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'EventDateModel(EventDate: $eventDate, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant EventDateModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.eventDate, eventDate) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => eventDate.hashCode ^ timestamps.hashCode;
}
