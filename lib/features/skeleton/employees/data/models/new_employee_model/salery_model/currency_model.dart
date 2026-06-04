import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// date:January/7/2024
// by:MohamedFouad
// lastUpdate:January/7/2024
class Currency {
  List<String?>? currency;
  List<Timestamp?>? timestamps;
  Currency({
    this.currency,
    this.timestamps,
  });

  Currency copyWith({
    List<String?>? currency,
    List<Timestamp?>? timestamps,
  }) {
    return Currency(
      currency: currency ?? this.currency,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Currency': currency,
      'Timestamp': timestamps,
    };
  }

  factory Currency.fromMap(Map<String, dynamic> map) {
    return Currency(
      currency: map['Currency'] != null
          ? List<String?>.from(
              (map['Currency']),
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

  factory Currency.fromJson(String source) =>
      Currency.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Currency(Currency: $currency, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant Currency other) {
    if (identical(this, other)) return true;

    return listEquals(other.currency, currency) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => currency.hashCode ^ timestamps.hashCode;
}
