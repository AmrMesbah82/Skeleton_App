import 'package:cloud_firestore/cloud_firestore.dart';

class IssuingAuthority {
  final List<String>? issuingAuthority;
  final List<Timestamp>? timestamp;

  IssuingAuthority({this.issuingAuthority, this.timestamp});

  factory IssuingAuthority.fromJson(dynamic json) {
    return IssuingAuthority(
      issuingAuthority: json['Issuing_Authority'] != null ? List<String>.from(json['Issuing_Authority']) : null,
      timestamp: json['Timestamp'] != null ? List<Timestamp>.from(json['Timestamp']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Issuing_Authority'] = issuingAuthority;
    map['Timestamp'] = timestamp;
    return map;
  }
}
