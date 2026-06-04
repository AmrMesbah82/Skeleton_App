import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class HasSurveyModel {
  List<bool?>? hasSurvey;
  List<Timestamp?>? timestamps;

  HasSurveyModel({
    this.hasSurvey,
    this.timestamps,
  });

  HasSurveyModel copyWith({
    List<bool?>? hasSurvey,
    List<Timestamp?>? timestamps,
  }) {
    return HasSurveyModel(
      hasSurvey: hasSurvey ?? this.hasSurvey,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Has_Survey': hasSurvey,
      'Timestamp': timestamps,
    };
  }

  factory HasSurveyModel.fromMap(Map<String, dynamic> map) {
    return HasSurveyModel(
      hasSurvey: map['Has_Survey'] != null
          ? List<bool?>.from(
              (map['Has_Survey']),
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

  factory HasSurveyModel.fromJson(String source) =>
      HasSurveyModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'HasSurveyModel(hasSurvey: $hasSurvey ,Timestamp: $timestamps)';

  @override
  bool operator ==(covariant HasSurveyModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.hasSurvey, hasSurvey) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => hasSurvey.hashCode ^ timestamps.hashCode;
}
