import 'package:cloud_firestore/cloud_firestore.dart';

class DocumentURL {
  final List<String>? documentURL;
  final List<Timestamp>? timestamp;

  DocumentURL({this.documentURL, this.timestamp});

  factory DocumentURL.fromJson(dynamic json) {
    return DocumentURL(
      documentURL: json['Document_URL'] != null ? List<String>.from(json['Document_URL']) : null,
      timestamp: json['Timestamp'] != null ? List<Timestamp>.from(json['Timestamp']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Document_URL'] = documentURL;
    map['Timestamp'] = timestamp;
    return map;
  }
}
