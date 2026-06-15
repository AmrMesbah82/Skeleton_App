import 'package:cloud_firestore/cloud_firestore.dart';

// date:March/3/2024
// by:Fouad
// lastUpdate:March/3/2024
// description: A class that represents a todo item.
class TodoItemModel {
  final List<String> items;
  final List<String> status;
  final List<Timestamp> timestamp;

  TodoItemModel({
    required this.items,
    required this.status,
    required this.timestamp,
  });

  static const String fieldItems = 'Items';
  static const String fieldStatus = 'Status';
  static const String fieldTimestamp = 'Timestamp';

  factory TodoItemModel.fromMap(Map<String, dynamic> data) {
    return TodoItemModel(
      items: List<String>.from(data[fieldItems]),
      status: List<String>.from(data[fieldStatus]),
      timestamp: List<Timestamp>.from(data[fieldTimestamp]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      fieldItems: items,
      fieldStatus: status,
      fieldTimestamp: timestamp,
    };
  }
}
