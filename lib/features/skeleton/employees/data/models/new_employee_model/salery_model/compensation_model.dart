import 'package:cloud_firestore/cloud_firestore.dart';

class Compensation {
  List<String?>? compensation;
  List<Timestamp?>? timestamps;
  Compensation({
    this.compensation,
    this.timestamps,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Compensation': compensation,
      'Timestamp': timestamps,
    };
  }

  factory Compensation.fromMap(Map<String, dynamic> map) {
    return Compensation(
      compensation: map['Compensation'] != null
          ? List<String?>.from(
              (map['Compensation']),
            )
          : null,
      timestamps: map['Timestamp'] != null
          ? List<Timestamp?>.from(
              (map['Timestamp']),
            )
          : null,
    );
  }
}
