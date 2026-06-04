import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// date:January/7/2024
// by:MohamedFouad
// lastUpdate:January/7/2024
class MaritalCertificate {
  List<String?>? maritalCertificate;
  List<Timestamp?>? timestamps;
  MaritalCertificate({
    this.maritalCertificate,
    this.timestamps,
  });

  MaritalCertificate copyWith({
    List<String?>? maritalCertificate,
    List<Timestamp?>? timestamps,
  }) {
    return MaritalCertificate(
      maritalCertificate: maritalCertificate ?? this.maritalCertificate,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Marital_Certificate': maritalCertificate,
      'Timestamp': timestamps,
    };
  }

  factory MaritalCertificate.fromMap(Map<String, dynamic> map) {
    return MaritalCertificate(
      maritalCertificate: map['Marital_Certificate'] != null
          ? List<String?>.from(
              (map['Marital_Certificate']),
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

  factory MaritalCertificate.fromJson(String source) =>
      MaritalCertificate.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'MaritalCertificate(Marital_Certificate: $maritalCertificate, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant MaritalCertificate other) {
    if (identical(this, other)) return true;

    return listEquals(other.maritalCertificate, maritalCertificate) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => maritalCertificate.hashCode ^ timestamps.hashCode;
}
