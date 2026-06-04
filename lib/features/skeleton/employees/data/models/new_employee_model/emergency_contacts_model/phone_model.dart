import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Phone {
  List<String?>? phones;
  List<String?>? countryCode;
  List<String?>? countryApp;
  List<Timestamp?>? timestamps;
  Phone({
    this.phones,
    this.countryCode,
    this.countryApp,
    this.timestamps,
  });

  Phone copyWith({
    List<String?>? phones,
    List<String?>? countryCode,
    List<String?>? countryApp,
    List<Timestamp?>? timestamps,
  }) {
    return Phone(
      phones: phones ?? this.phones,
      countryCode: countryCode ?? this.countryCode,
      countryApp: countryApp ?? this.countryApp,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Phone': phones,
      'Country_Code': countryCode,
      'Country_App': countryApp,
      'Timestamp': timestamps,
    };
  }

  factory Phone.fromMap(Map<String, dynamic> map) {
    return Phone(
      phones: map['Phone'] != null
          ? List<String?>.from(
              (map['Phone']),
            )
          : null,
      countryCode: map['Country_Code'] != null
          ? List<String?>.from(
              (map['Country_Code']),
            )
          : null,
      countryApp: map['Country_App'] != null
          ? List<String?>.from(
              (map['Country_App']),
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

  factory Phone.fromJson(String source) =>
      Phone.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'phone(Phone: $phones,Country_Code: $countryCode,Country_App: $countryApp,, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant Phone other) {
    if (identical(this, other)) return true;

    return listEquals(other.phones, phones) &&
        listEquals(other.countryCode, countryCode) &&
        listEquals(other.countryApp, countryApp) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode =>
      phones.hashCode ^
      countryCode.hashCode ^
      countryApp.hashCode ^
      timestamps.hashCode;
}
