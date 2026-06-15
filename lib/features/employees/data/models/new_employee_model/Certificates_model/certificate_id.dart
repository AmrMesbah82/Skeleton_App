import 'package:cloud_firestore/cloud_firestore.dart';

class CertificateID {
  final List<String>? certificateID;
  final List<Timestamp>? timestamp;

  CertificateID({this.certificateID, this.timestamp});

  factory CertificateID.fromJson(dynamic json) {
    return CertificateID(
      certificateID: json['Certificate_ID'] != null ? List<String>.from(json['Certificate_ID']) : null,
      timestamp: json['Timestamp'] != null ? List<Timestamp>.from(json['Timestamp']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Certificate_ID'] = certificateID;
    map['Timestamp'] = timestamp;
    return map;
  }
}
