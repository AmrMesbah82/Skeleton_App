import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// date:January/7/2024
// by:MohamedFouad
// lastUpdate:January/7/2024
class ContactRelation {
  List<String?>? contactRelation;
  List<Timestamp?>? timestamps;
  ContactRelation({
    this.contactRelation,
    this.timestamps,
  });

  ContactRelation copyWith({
    List<String?>? contactRelation,
    List<Timestamp?>? timestamps,
  }) {
    return ContactRelation(
      contactRelation: contactRelation ?? this.contactRelation,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Contact_Relation': contactRelation,
      'Timestamp': timestamps,
    };
  }

  factory ContactRelation.fromMap(Map<String, dynamic> map) {
    return ContactRelation(
      contactRelation: map['Contact_Relation'] != null
          ? List<String?>.from(
              (map['Contact_Relation']),
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

  factory ContactRelation.fromJson(String source) =>
      ContactRelation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ContactRelation(Contact_Relation: $contactRelation, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant ContactRelation other) {
    if (identical(this, other)) return true;

    return listEquals(other.contactRelation, contactRelation) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => contactRelation.hashCode ^ timestamps.hashCode;
}
