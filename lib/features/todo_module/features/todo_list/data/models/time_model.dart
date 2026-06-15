import 'package:cloud_firestore/cloud_firestore.dart';

/// Developer Name : Mohamed Hussien
/// Date of Last Edit :12/May/2024 By Mohamed
class TimeModel {
  static const String fieldTime = 'Time';
  static const String fieldTimestamp = 'Timestamp';

  List<String?>? time;
  List<Timestamp?> timestamps;

  TimeModel({
    this.time,
    required this.timestamps,
  });

  TimeModel copyWith({
    List<String?>? time,
    List<Timestamp?>? timestamps,
  }) {
    return TimeModel(
      time: time ?? this.time,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      fieldTime: convertToLowercase(time),
      fieldTimestamp: timestamps,
    };
  }

  factory TimeModel.fromMap(Map<String, dynamic> map) {
    return TimeModel(
      time: map[fieldTime] != null
          ? List<String?>.from(map[fieldTime])
          : null,
      timestamps: map[fieldTimestamp] != null
          ? List<Timestamp?>.from(map[fieldTimestamp])
          : [],
    );
  }

  List<String?>? convertToLowercase(List<String?>? name) {
    if (name != null) {
      return name.map((item) => item?.toLowerCase()).toList();
    }
    return null;
  }
}
