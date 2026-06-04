import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class IsRemoteModel {
  List<bool?>? isRemote;
  List<Timestamp?>? timestamps;

  IsRemoteModel({
    this.isRemote,
    this.timestamps,
  });

  IsRemoteModel copyWith({
    List<bool?>? isRemote,
    List<Timestamp?>? timestamps,
  }) {
    return IsRemoteModel(
      isRemote: isRemote ?? this.isRemote,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Is_Remote': isRemote,
      'Timestamp': timestamps,
    };
  }

  factory IsRemoteModel.fromMap(Map<String, dynamic> map) {
    return IsRemoteModel(
      isRemote: map['Is_Remote'] != null
          ? List<bool?>.from(
              (map['Is_Remote']),
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

  factory IsRemoteModel.fromJson(String source) =>
      IsRemoteModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'IsRemoteModel(isRemote: $isRemote ,Timestamp: $timestamps)';

  @override
  bool operator ==(covariant IsRemoteModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.isRemote, isRemote) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => isRemote.hashCode ^ timestamps.hashCode;
}
