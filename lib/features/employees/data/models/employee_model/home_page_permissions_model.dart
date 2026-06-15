import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// date:January/7/2024
// by:MohamedFouad
// lastUpdate:January/7/2024
class HomePagePermissions {
  List<String?>? homePagePermissions;
  List<Timestamp?>? timestamps;
  HomePagePermissions({
    this.homePagePermissions,
    this.timestamps,
  });

  HomePagePermissions copyWith({
    List<String?>? homePagePermissions,
    List<Timestamp?>? timestamps,
  }) {
    return HomePagePermissions(
      homePagePermissions: homePagePermissions ?? this.homePagePermissions,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Home_Page_Permissions': homePagePermissions,
      'Timestamp': timestamps,
    };
  }

  factory HomePagePermissions.fromMap(Map<String, dynamic> map) {
    return HomePagePermissions(
      homePagePermissions: map['Home_Page_Permissions'] != null
          ? List<String?>.from(
              (map['Home_Page_Permissions']),
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

  factory HomePagePermissions.fromJson(String source) =>
      HomePagePermissions.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'HomePagePermissions(Home_Page_Permissions: $homePagePermissions, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant HomePagePermissions other) {
    if (identical(this, other)) return true;

    return listEquals(other.homePagePermissions, homePagePermissions) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => homePagePermissions.hashCode ^ timestamps.hashCode;
}
