import 'package:cloud_firestore/cloud_firestore.dart';

enum TodoStatus { todo, done, deleted, scheduled }

class StatusModel {
  static const String fieldStatus = 'Status';
  static const String fieldTimestamp = 'Timestamp';

  TodoStatus? status;
  Timestamp timestamp;

  StatusModel({
    this.status,
    required this.timestamp,
  });

  StatusModel copyWith({
    TodoStatus? status,
    Timestamp? timestamp,
  }) {
    return StatusModel(
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      fieldStatus: status?.toString().split('.').last,
      fieldTimestamp: timestamp,
    };
  }

  factory StatusModel.fromMap(Map<String, dynamic> map) {
    return StatusModel(
      status: statusFromString(map[fieldStatus]),
      timestamp: map[fieldTimestamp],
    );
  }

  // دالة مساعدة لتحويل String إلى Enum
  static TodoStatus statusFromString(String status) {
    return TodoStatus.values.firstWhere(
      (e) => e.toString().split('.').last == status,
      orElse: () =>
          TodoStatus.todo, // القيمة الافتراضية إذا لم يتم العثور على تطابق
    );
  }
}
