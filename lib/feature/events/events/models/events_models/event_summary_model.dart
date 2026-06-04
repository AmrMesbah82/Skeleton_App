import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class EventSummaryModel {
  List<String?>? summary;
  List<Timestamp?>? timestamps;
  EventSummaryModel({
    this.summary,
    this.timestamps,
  });

  EventSummaryModel copyWith({
    List<String?>? summary,
    List<Timestamp?>? timestamps,
  }) {
    return EventSummaryModel(
      summary: summary ?? this.summary,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Summary': summary,
      'Timestamp': timestamps,
    };
  }

  factory EventSummaryModel.fromMap(Map<String, dynamic> map) {
    return EventSummaryModel(
      summary: map['Summary'] != null
          ? List<String?>.from(
              (map['Summary']),
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

  factory EventSummaryModel.fromJson(String source) =>
      EventSummaryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'EventSummaryModel(Summary: $summary, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant EventSummaryModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.summary, summary) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => summary.hashCode ^ timestamps.hashCode;
}
