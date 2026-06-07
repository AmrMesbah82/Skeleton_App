import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DepartmentOwnerModel {
  List<String?>? departmentOwner;
  List<Timestamp?>? timestamps;
  DepartmentOwnerModel({
    this.departmentOwner,
    this.timestamps,
  });

  DepartmentOwnerModel copyWith({
    List<String?>? departmentOwner,
    List<Timestamp?>? timestamps,
  }) {
    return DepartmentOwnerModel(
      departmentOwner: departmentOwner ?? this.departmentOwner,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Department_Owner': departmentOwner,
      'Timestamp': timestamps,
    };
  }

  factory DepartmentOwnerModel.fromMap(Map<String, dynamic> map) {
    return DepartmentOwnerModel(
      departmentOwner: map['Department_Owner'] != null
          ? List<String?>.from(
              (map['Department_Owner']),
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

  factory DepartmentOwnerModel.fromJson(String source) =>
      DepartmentOwnerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Department_Owner_Model(DepartmentOwner: $departmentOwner, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant DepartmentOwnerModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.departmentOwner, departmentOwner) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => departmentOwner.hashCode ^ timestamps.hashCode;
}
