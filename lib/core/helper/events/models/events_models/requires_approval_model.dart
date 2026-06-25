import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class EventApprovalModel {
  List<bool?>? hasApproval;
  List<String?>? approval;
  List<Timestamp?>? timestamps;
  EventApprovalModel({
    this.approval,
    this.hasApproval,
    this.timestamps,
  });

  EventApprovalModel copyWith({
    List<bool?>? hasApproval,
    List<String?>? approval,
    List<Timestamp?>? timestamps,
  }) {
    return EventApprovalModel(
      hasApproval: hasApproval ?? this.hasApproval,
      approval: approval ?? this.approval,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Has_Approval': hasApproval,
      'Approval': approval,
      'Timestamp': timestamps,
    };
  }

  factory EventApprovalModel.fromMap(Map<String, dynamic> map) {
    return EventApprovalModel(
      hasApproval: map['Has_Approval'] != null
          ? List<bool?>.from(
              (map['Has_Approval']),
            )
          : null,
      approval: map['Approval'] != null
          ? List<String?>.from(
              (map['Approval']),
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

  factory EventApprovalModel.fromJson(String source) =>
      EventApprovalModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'EventApprovalModel(Approval: $approval, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant EventApprovalModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.approval, approval) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => approval.hashCode ^ timestamps.hashCode;
}
