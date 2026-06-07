import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class IsOnSiteModel {
  List<bool?>? isOnSite;
  List<Timestamp?>? timestamps;

  IsOnSiteModel({
    this.isOnSite,
    this.timestamps,
  });

  IsOnSiteModel copyWith({
    List<bool?>? isOnsite,
    List<Timestamp?>? timestamps,
  }) {
    return IsOnSiteModel(
      isOnSite: isOnsite ?? isOnSite,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Is_OnSite': isOnSite,
      'Timestamp': timestamps,
    };
  }

  factory IsOnSiteModel.fromMap(Map<String, dynamic> map) {
    return IsOnSiteModel(
      isOnSite: map['Is_OnSite'] != null
          ? List<bool?>.from(
              (map['Is_OnSite']),
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

  factory IsOnSiteModel.fromJson(String source) =>
      IsOnSiteModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'IsOnSiteModel(isOnSite: $isOnSite ,Timestamp: $timestamps)';

  @override
  bool operator ==(covariant IsOnSiteModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.isOnSite, isOnSite) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => isOnSite.hashCode ^ timestamps.hashCode;
}
