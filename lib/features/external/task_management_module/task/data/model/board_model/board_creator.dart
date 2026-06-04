import 'package:cloud_firestore/cloud_firestore.dart';

class BoardCreator {
  List<String>? boardCreator;
  List<Timestamp>? timestamp;

  BoardCreator({
    this.boardCreator,
    this.timestamp,
  });

  BoardCreator.fromJson(dynamic json) {
    boardCreator = json['Board_Creator'] != null
        ? json['Board_Creator'].cast<String>()
        : [];
    timestamp =
        json['Timestamp'] != null ? json['Timestamp'].cast<Timestamp>() : [];
  }

  BoardCreator copyWith({
    List<String>? boardCreator,
    List<Timestamp>? timestamp,
  }) =>
      BoardCreator(
        boardCreator: boardCreator ?? this.boardCreator,
        timestamp: timestamp ?? this.timestamp,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Board_Creator'] = boardCreator;
    map['Timestamp'] = timestamp;
    return map;
  }
}
