import 'package:cloud_firestore/cloud_firestore.dart';

class Date {
  Date({
    this.date,
    this.timestamp,
  });

  Date.fromJson(dynamic json) {
    date = json['Date'] != null ? json['Date'].cast<String>() : [];
    timestamp =
        json['Timestamp'] != null ? json['Timestamp'].cast<Timestamp>() : [];
  }
  List<String>? date;
  List<Timestamp>? timestamp;
  Date copyWith({
    List<String>? date,
    List<Timestamp>? timestamp,
  }) =>
      Date(
        date: date ?? this.date,
        timestamp: timestamp ?? this.timestamp,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Date'] = date;
    map['Timestamp'] = timestamp;
    return map;
  }
}
