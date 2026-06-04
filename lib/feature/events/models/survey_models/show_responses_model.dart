import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ShowResponses {
  List<bool?>? showResponse;
  List<Timestamp?>? timestamps;

  ShowResponses({
    this.showResponse,
    this.timestamps,
  });

  ShowResponses copyWith({
    List<bool?>? showResponse,
    List<Timestamp?>? timestamps,
  }) {
    return ShowResponses(
      showResponse: showResponse ?? showResponse,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Show_Response': showResponse,
      'Timestamp': timestamps,
    };
  }

  factory ShowResponses.fromMap(Map<String, dynamic> map) {
    return ShowResponses(
      showResponse: map['Show_Response'] != null
          ? List<bool?>.from(
              (map['Show_Response']),
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

  factory ShowResponses.fromJson(String source) =>
      ShowResponses.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ShowResponses(showResponse: $showResponse ,Timestamp: $timestamps)';

  @override
  bool operator ==(covariant ShowResponses other) {
    if (identical(this, other)) return true;

    return listEquals(other.showResponse, showResponse) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => showResponse.hashCode ^ timestamps.hashCode;
}
