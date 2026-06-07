import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SurveyStatus {
  List<String?>? status;
  List<Timestamp?>? timestamps;
  SurveyStatus({
    required this.status,
    required this.timestamps,
  });

  SurveyStatus copyWith({
    List<String?>? status,
    List<Timestamp?>? timestamps,
  }) {
    return SurveyStatus(
      status: status ?? this.status,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Status': status,
      'Timestamp': timestamps,
    };
  }

  factory SurveyStatus.fromMap(Map<String, dynamic> map) {
    return SurveyStatus(
      status: map['Status'] != null
          ? List<String?>.from(
              (map['Status']),
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

  factory SurveyStatus.fromJson(String source) =>
      SurveyStatus.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Status(Status: $status, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant SurveyStatus other) {
    if (identical(this, other)) return true;

    return listEquals(other.status, status) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => status.hashCode ^ timestamps.hashCode;
}
