import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AssignedId {
  List<String?>? id;
  List<Timestamp?>? timestamps;
  AssignedId({
    required this.id,
    required this.timestamps,
  });

  AssignedId copyWith({
    List<String?>? eventId,
    List<Timestamp?>? timestamps,
  }) {
    return AssignedId(
      id: eventId ?? id,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Id': id,
      'Timestamp': timestamps,
    };
  }

  factory AssignedId.fromMap(Map<String, dynamic> map) {
    return AssignedId(
      id: map['Id'] != null
          ? List<String?>.from(
              (map['Id']),
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

  factory AssignedId.fromJson(String source) =>
      AssignedId.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AssignedId(Id: $id, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant AssignedId other) {
    if (identical(this, other)) return true;

    return listEquals(other.id, id) && listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => id.hashCode ^ timestamps.hashCode;
}
