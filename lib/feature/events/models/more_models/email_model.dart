import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Email {
  List<String?>? employeeEmail;
  List<Timestamp?>? timestamps;

  Email({
    this.employeeEmail,
    this.timestamps,
  });

  Email copyWith({
    List<String?>? employeeEmail,
    List<Timestamp?>? timestamps,
  }) {
    return Email(
      employeeEmail: employeeEmail ?? this.employeeEmail,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Email': employeeEmail,
      'Timestamp': timestamps,
    };
  }

  factory Email.fromMap(Map<String, dynamic> map) {
    return Email(
      employeeEmail: map['Email'] != null
          ? List<String?>.from(
              (map['Email']),
            )
          : [],
      timestamps: map['Timestamp'] != null
          ? List<Timestamp?>.from(
              (map['Timestamp']),
            )
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Email.fromJson(String source) =>
      Email.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Email(Email: $employeeEmail, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant Email other) {
    if (identical(this, other)) return true;

    return listEquals(other.employeeEmail, employeeEmail) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => employeeEmail.hashCode ^ timestamps.hashCode;
}
