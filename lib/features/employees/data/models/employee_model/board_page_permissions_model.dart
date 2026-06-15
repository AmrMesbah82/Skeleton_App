import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// date:January/7/2024
// by:MohamedFouad
// lastUpdate:January/7/2024
class BoardPagePermissions {
  List<String?>? boardPagePermissions;
  List<Timestamp?>? timestamps;
  BoardPagePermissions({
    this.boardPagePermissions,
    this.timestamps,
  });

  BoardPagePermissions copyWith({
    List<String?>? boardPagePermissions,
    List<Timestamp?>? timestamps,
  }) {
    return BoardPagePermissions(
      boardPagePermissions: boardPagePermissions ?? this.boardPagePermissions,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Board_Page_Permissions': boardPagePermissions,
      'Timestamp': timestamps,
    };
  }

  factory BoardPagePermissions.fromMap(Map<String, dynamic> map) {
    return BoardPagePermissions(
      boardPagePermissions: map['Board_Page_Permissions'] != null
          ? List<String?>.from(
              (map['Board_Page_Permissions']),
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

  factory BoardPagePermissions.fromJson(String source) =>
      BoardPagePermissions.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'BoardPagePermissions(Board_Page_Permissions: $boardPagePermissions, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant BoardPagePermissions other) {
    if (identical(this, other)) return true;

    return listEquals(other.boardPagePermissions, boardPagePermissions) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => boardPagePermissions.hashCode ^ timestamps.hashCode;
}
