import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:demo_app/feature/events/models/constants_methods.dart';

class SurveyDescription {
  List<String?>? description;
  List<Timestamp?>? timestamps;
  SurveyDescription({
    required this.description,
    required this.timestamps,
  });

  SurveyDescription copyWith({
    List<String?>? description,
    List<Timestamp?>? timestamps,
  }) {
    return SurveyDescription(
      description: description ?? this.description,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Description':ConstantsMethods.convertToLowercase(description),
      'Timestamp': timestamps,
    };
  }

  factory SurveyDescription.fromMap(Map<String, dynamic> map) {
    return SurveyDescription(
      description:
          map['Description'] != null
          ? List<String?>.from(map['Description']).map((description) {
              if (description != null && description.isNotEmpty) {
                return ConstantsMethods.capitalizeFirstChar(description);
              } else {
                return description;
              }
            }).toList()
          : null,
      timestamps: map['Timestamp'] != null
          ? List<Timestamp?>.from(
              (map['Timestamp']),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SurveyDescription.fromJson(String source) =>
      SurveyDescription.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Description(Description: $description, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant SurveyDescription other) {
    if (identical(this, other)) return true;

    return listEquals(other.description, description) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => description.hashCode ^ timestamps.hashCode;
}
