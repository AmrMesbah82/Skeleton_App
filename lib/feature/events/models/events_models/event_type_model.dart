import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class EventTypeModel {
  List<String?>? eventType;
  List<Timestamp?>? timestamps;
  EventTypeModel({
    this.eventType,
    this.timestamps,
  });

  EventTypeModel copyWith({
    List<String?>? eventType,
    List<Timestamp?>? timestamps,
  }) {
    return EventTypeModel(
      eventType: eventType ?? this.eventType,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Event_Type': eventType,
      'Timestamp': timestamps,
    };
  }

  factory EventTypeModel.fromMap(Map<String, dynamic> map) {
    return EventTypeModel(
      eventType: map['Event_Type'] != null
          ? List<String?>.from(
              (map['Event_Type']),
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

  factory EventTypeModel.fromJson(String source) =>
      EventTypeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'EventTypeModel(EventType: $eventType, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant EventTypeModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.eventType, eventType) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => eventType.hashCode ^ timestamps.hashCode;
}
