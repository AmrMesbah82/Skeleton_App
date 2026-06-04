import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class EventIdModel {
  List<String?>? eventId;
  List<Timestamp?>? timestamps;
  EventIdModel({
    this.eventId,
    this.timestamps,
  });

  EventIdModel copyWith({
    List<String?>? eventId,
    List<Timestamp?>? timestamps,
  }) {
    return EventIdModel(
      eventId: eventId ?? this.eventId,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Event_Id': eventId,
      'Timestamp': timestamps,
    };
  }

  factory EventIdModel.fromMap(Map<String, dynamic> map) {
    return EventIdModel(
      eventId: map['Event_Id'] != null
          ? List<String?>.from(
              (map['Event_Id']),
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

  factory EventIdModel.fromJson(String source) =>
      EventIdModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'EventIdModel(eventId: $eventId, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant EventIdModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.eventId, eventId) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => eventId.hashCode ^ timestamps.hashCode;
}
