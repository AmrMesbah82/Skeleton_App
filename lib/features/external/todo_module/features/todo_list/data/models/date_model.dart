import 'package:cloud_firestore/cloud_firestore.dart';

/// Developer Name : Mohamed Hussien
/// Date of Last Edit :12/May/2024 By mohamed

class DateModel {
  List<String?>? date;
  List<Timestamp?> timestamps;
  DateModel({
    this.date,
    required this.timestamps,
  });

  DateModel copyWith({
    List<String?>? date,
    List<Timestamp?>? timestamps,
  }) {
    return DateModel(
      date: date ?? this.date,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  static const String fieldDate = 'Date';
  static const String fieldTimestamp = 'Timestamp';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      fieldDate: convertToLowercase(date),
      fieldTimestamp: timestamps,
    };
  }

  factory DateModel.fromMap(Map<String, dynamic> map) {
    return DateModel(
        date: map[fieldDate] != null
            ? List<String?>.from(
                (map[fieldDate]),
              )
            : null,
        timestamps: List<Timestamp?>.from((map[fieldTimestamp])));
  }
  List<String?>? convertToLowercase(List<String?>? list) {
    if (list != null) {
      return list.map((list) => list?.toLowerCase()).toList();
    }
    return null;
  }
}
