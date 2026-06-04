import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// date:January/7/2024
// by:MohamedFouad
// lastUpdate:January/7/2024
class IdPhoto {
  List<String?>? idPhoto;
  List<Timestamp?>? timestamps;
  IdPhoto({
    this.idPhoto,
    this.timestamps,
  });

  IdPhoto copyWith({
    List<String?>? idPhoto,
    List<Timestamp?>? timestamps,
  }) {
    return IdPhoto(
      idPhoto: idPhoto ?? this.idPhoto,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Id_Photo': idPhoto,
      'Timestamp': timestamps,
    };
  }

  factory IdPhoto.fromMap(Map<String, dynamic> map) {
    return IdPhoto(
      idPhoto: map['Id_Photo'] != null
          ? List<String?>.from(
              (map['Id_Photo']),
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

  factory IdPhoto.fromJson(String source) =>
      IdPhoto.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'IdPhoto(Id_Photo: $idPhoto, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant IdPhoto other) {
    if (identical(this, other)) return true;

    return listEquals(other.idPhoto, idPhoto) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => idPhoto.hashCode ^ timestamps.hashCode;
}
