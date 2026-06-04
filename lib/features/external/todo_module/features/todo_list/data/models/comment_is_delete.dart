import 'package:cloud_firestore/cloud_firestore.dart';

/// Developer Name : Mohamed Hussien
/// Date of Last Edit :12/May/2024 By mohamed
class CommentIsDelete {
  bool commentIsDelete;
  Timestamp timestamp;

  CommentIsDelete({
    required this.commentIsDelete,
    required this.timestamp,
  });

  CommentIsDelete copyWith({
    bool? commentIsDelete,
    Timestamp? timestamp,
  }) {
    return CommentIsDelete(
      commentIsDelete: commentIsDelete ?? this.commentIsDelete,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  static const String fieldCommentIsDeleted = 'Comment_Is_Delete';
  static const String fieldTimeStamp = 'Timestamp';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      fieldCommentIsDeleted: commentIsDelete,
      fieldTimeStamp: timestamp,
    };
  }

  factory CommentIsDelete.fromMap(Map<String, dynamic> map) {
    return CommentIsDelete(
      commentIsDelete: map[fieldCommentIsDeleted] as bool,
      timestamp: map[fieldTimeStamp] as Timestamp,
    );
  }
}
