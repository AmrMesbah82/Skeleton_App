import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class EventFlyerModel {
  List<String?>? eventFlyer;
  List<String?>? flyerName;
  List<Timestamp?>? timestamps;
  EventFlyerModel({
    this.flyerName,
    this.eventFlyer,
    this.timestamps,
  });

  EventFlyerModel copyWith({
    List<String?>? flyerName,
    List<String?>? eventFlyer,
    List<Timestamp?>? timestamps,
  }) {
    return EventFlyerModel(
      flyerName: flyerName ?? this.flyerName,
      eventFlyer: eventFlyer ?? this.eventFlyer,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Flyer_Name': flyerName,
      'Event_Flyer': eventFlyer,
      'Timestamp': timestamps,
    };
  }

  factory EventFlyerModel.fromMap(Map<String, dynamic> map) {
    return EventFlyerModel(
      flyerName: map['Flyer_Name'] != null
          ? List<String?>.from(
              (map['Flyer_Name']),
            )
          : null,
      eventFlyer: map['Event_Flyer'] != null
          ? List<String?>.from(
              (map['Event_Flyer']),
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

  factory EventFlyerModel.fromJson(String source) =>
      EventFlyerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'EventFlyerModel(Flyer_Name: $flyerName, EventFlyer: $eventFlyer, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant EventFlyerModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.flyerName, flyerName) &&
        listEquals(other.eventFlyer, eventFlyer) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode =>
      flyerName.hashCode ^ eventFlyer.hashCode ^ timestamps.hashCode;
}
