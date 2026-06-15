import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class EventVenueDataModel {
  List<String?>? venueData;
  List<Timestamp?>? timestamps;
  EventVenueDataModel({
    this.venueData,
    this.timestamps,
  });

  EventVenueDataModel copyWith({
    List<String?>? venueData,
    List<Timestamp?>? timestamps,
  }) {
    return EventVenueDataModel(
      venueData: venueData ?? this.venueData,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Venue_Data': venueData,
      'Timestamp': timestamps,
    };
  }

  factory EventVenueDataModel.fromMap(Map<String, dynamic> map) {
    return EventVenueDataModel(
      venueData: map['Venue_Data'] != null
          ? List<String?>.from(
              (map['Venue_Data']),
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

  factory EventVenueDataModel.fromJson(String source) =>
      EventVenueDataModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'EventVenueDataModel(Venue_Data: $venueData, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant EventVenueDataModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.venueData, venueData) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => venueData.hashCode ^ timestamps.hashCode;
}
