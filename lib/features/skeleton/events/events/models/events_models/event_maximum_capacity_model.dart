import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class EventMaximumCapacityModel {
  List<String?>? maximumCapacity;
  List<Timestamp?>? timestamps;
  EventMaximumCapacityModel({
    this.maximumCapacity,
    this.timestamps,
  });

  EventMaximumCapacityModel copyWith({
    List<String?>? maximumCapacity,
    List<Timestamp?>? timestamps,
  }) {
    return EventMaximumCapacityModel(
      maximumCapacity: maximumCapacity ?? this.maximumCapacity,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Maximum_Capacity': maximumCapacity,
      'Timestamp': timestamps,
    };
  }

  factory EventMaximumCapacityModel.fromMap(Map<String, dynamic> map) {
    return EventMaximumCapacityModel(
      maximumCapacity: map['Maximum_Capacity'] != null
          ? List<String?>.from(
              (map['Maximum_Capacity']),
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

  factory EventMaximumCapacityModel.fromJson(String source) =>
      EventMaximumCapacityModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'MaximumCapacityModel(MaximumCapacity: $maximumCapacity, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant EventMaximumCapacityModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.maximumCapacity, maximumCapacity) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => maximumCapacity.hashCode ^ timestamps.hashCode;
}
