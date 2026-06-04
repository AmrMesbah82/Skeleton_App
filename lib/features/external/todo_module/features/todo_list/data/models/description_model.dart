import 'package:cloud_firestore/cloud_firestore.dart';

/// Developer Name : Mohamed Hussien
/// Date of Last Edit :12/May/2024 By mohamed
class DescriptionModel {
  List<String?>? description;
  List<Timestamp?> timestamps;
  DescriptionModel({
    this.description,
    required this.timestamps,
  });

  DescriptionModel copyWith({
    List<String?>? description,
    List<Timestamp?>? timestamps,
  }) {
    return DescriptionModel(
      description: description ?? this.description,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  static const String fieldDescription = 'Description';
  static const String fieldTimestamp = 'Timestamp';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      fieldDescription: convertToLowercase(description),
      fieldTimestamp: timestamps,
    };
  }

  factory DescriptionModel.fromMap(Map<String, dynamic> map) {
    return DescriptionModel(
      description: map[fieldDescription] != null
          ? List<String?>.from(
              (map[fieldDescription]),
            )
          : null,
      timestamps: List<Timestamp?>.from((map[fieldTimestamp])),
    );
  }
  List<String?>? convertToLowercase(List<String?>? list) {
    if (list != null) {
      return list.map((list) => list?.toLowerCase()).toList();
    }
    return null;
  }
}
