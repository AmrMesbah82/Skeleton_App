import 'package:cloud_firestore/cloud_firestore.dart';

/// Developer Name : Mohamed Hussien
/// Date of Last Edit :12/May/2024 By mohamed
class NameModel {
  static const String fieldName = 'Name';
  static const String fieldTimestamp = 'Timestamp';

  List<String?> name;
  List<Timestamp?> timestamps;

  NameModel({
    required this.name,
    required this.timestamps,
  });

  NameModel copyWith({
    List<String?>? name,
    List<Timestamp?>? timestamps,
  }) {
    return NameModel(
      name: name ?? this.name,
      timestamps: timestamps ?? this.timestamps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      fieldName: convertToLowercase(name),
      fieldTimestamp: timestamps,
    };
  }

  factory NameModel.fromMap(Map<String, dynamic> map) {
    List<String?>? nameList = map[fieldName] != null
        ? List<String?>.from(map[fieldName]).map((name) {
            if (name != null && name.isNotEmpty) {
              return name.substring(0, 1).toUpperCase() + name.substring(1);
            } else {
              return name;
            }
          }).toList()
        : null;

    return NameModel(
      name: nameList!,
      timestamps: List<Timestamp?>.from(map[fieldTimestamp]),
    );
  }

  List<String?>? convertToLowercase(List<String?>? name) {
    if (name != null) {
      return name.map((name) => name?.toLowerCase()).toList();
    }
    return null;
  }
}
