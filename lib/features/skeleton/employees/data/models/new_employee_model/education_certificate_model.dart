import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// date:January/7/2024
// by:MohamedFouad
// lastUpdate:January/7/2024
class EducationCertificate {
  List<String?>? educationCertificate;
  List<Timestamp?>? timestamps;
  EducationCertificate({
    this.educationCertificate,
    this.timestamps,
  });

  EducationCertificate copyWith({
    List<String?>? educationCertificate,
    List<Timestamp?>? timestamps,
  }) {
    return EducationCertificate(
      educationCertificate: educationCertificate ?? this.educationCertificate,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Education_Certificate': educationCertificate,
      'Timestamp': timestamps,
    };
  }

  factory EducationCertificate.fromMap(Map<String, dynamic> map) {
    return EducationCertificate(
      educationCertificate: map['Education_Certificate'] != null
          ? List<String?>.from(
              (map['Education_Certificate']),
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

  factory EducationCertificate.fromJson(String source) =>
      EducationCertificate.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'EducationCertificate(Education_Certificate: $educationCertificate, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant EducationCertificate other) {
    if (identical(this, other)) return true;

    return listEquals(other.educationCertificate, educationCertificate) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => educationCertificate.hashCode ^ timestamps.hashCode;
}
