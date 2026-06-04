import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// date:January/7/2024
// by:MohamedFouad
// lastUpdate:January/7/2024
class Salary {
  List<String?>? salary;
  List<Timestamp?>? timestamps;
  Salary({
    this.salary,
    this.timestamps,
  });

  Salary copyWith({
    List<String?>? salary,
    List<Timestamp?>? timestamps,
  }) {
    return Salary(
      salary: salary ?? this.salary,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Salary': salary,
      'Timestamp': timestamps,
    };
  }

  factory Salary.fromMap(Map<String, dynamic> map) {
    return Salary(
      salary: map['Salary'] != null
          ? List<String?>.from(
              (map['Salary']),
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

  factory Salary.fromJson(String source) =>
      Salary.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Salary(Salary: $salary, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant Salary other) {
    if (identical(this, other)) return true;

    return listEquals(other.salary, salary) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => salary.hashCode ^ timestamps.hashCode;
}
