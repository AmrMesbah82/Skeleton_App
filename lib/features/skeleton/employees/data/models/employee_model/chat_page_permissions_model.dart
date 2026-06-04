import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// date:January/7/2024
// by:MohamedFouad
// lastUpdate:January/7/2024
class ChatPagePermissions {
  List<String?>? chatPagePermissions;
  List<Timestamp?>? timestamps;
  ChatPagePermissions({
    this.chatPagePermissions,
    this.timestamps,
  });

  ChatPagePermissions copyWith({
    List<String?>? chatPagePermissions,
    List<Timestamp?>? timestamps,
  }) {
    return ChatPagePermissions(
      chatPagePermissions: chatPagePermissions ?? this.chatPagePermissions,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Chat_Page_Permissions': chatPagePermissions,
      'Timestamp': timestamps,
    };
  }

  factory ChatPagePermissions.fromMap(Map<String, dynamic> map) {
    return ChatPagePermissions(
      chatPagePermissions: map['Chat_Page_Permissions'] != null
          ? List<String?>.from(
              (map['Chat_Page_Permissions']),
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

  factory ChatPagePermissions.fromJson(String source) =>
      ChatPagePermissions.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ChatPagePermissions(Chat_Page_Permissions: $chatPagePermissions, Timestamp: $timestamps)';

  @override
  bool operator ==(covariant ChatPagePermissions other) {
    if (identical(this, other)) return true;

    return listEquals(other.chatPagePermissions, chatPagePermissions) &&
        listEquals(other.timestamps, timestamps);
  }

  @override
  int get hashCode => chatPagePermissions.hashCode ^ timestamps.hashCode;
}
