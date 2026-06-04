import 'package:cloud_firestore/cloud_firestore.dart';

class CommentIsDone {
  bool commentIsDone;
  Timestamp timestamps;

  CommentIsDone({
    required this.commentIsDone,
    required this.timestamps,
  });

  CommentIsDone copyWith({
    bool? commentIsDone,
    Timestamp? timestamp,
  }) {
    return CommentIsDone(
      commentIsDone: commentIsDone ?? this.commentIsDone,
      timestamps: timestamp ?? timestamps,
    );
  }

  static const String fieldCommentIsDone = 'Comment_Is_Done';
  static const String fieldTimestamp = 'Timestamp';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      fieldCommentIsDone: commentIsDone,
      fieldTimestamp: timestamps,
    };
  }

  factory CommentIsDone.fromMap(Map<String, dynamic> map) {
    return CommentIsDone(
      commentIsDone: map[fieldCommentIsDone] as bool,
      timestamps: map[fieldTimestamp] as Timestamp,
    );
  }
}
