import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class EventTitleModel {
  List<String?>? title;
  List<Timestamp?>? timestamps;
  EventTitleModel({
    this.title,
    this.timestamps,
  });

  EventTitleModel copyWith({
    List<String?>? title,
    List<Timestamp?>? timestamps,
  }) {
    return EventTitleModel(
      title: title ?? this.title,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Title': title,
      'Timestamp': timestamps,
    };
  }

  factory EventTitleModel.fromMap(Map<String, dynamic> map) {
    return EventTitleModel(
      title: map['Title'] != null
          ? List<String?>.from(
              (map['Title']),
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

  factory EventTitleModel.fromJson(String source) =>
      EventTitleModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Title(Title: $title, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant EventTitleModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.title, title) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => title.hashCode ^ timestamps.hashCode;
}
