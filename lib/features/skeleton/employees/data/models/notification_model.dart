import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String title;
  final String titleArabic;
  final String body;
  final String bodyArabic;
  final String type;
  final bool seen;
  final Timestamp timestamp;
  final String? noteId,
      cardId,
      todoId,
      eventId,
      surveyId,
      boardId,
      serviceId,
      serviceRequestId;

  NotificationModel({
    required this.title,
    required this.titleArabic,
    required this.body,
    required this.bodyArabic,
    required this.type,
    required this.seen,
    required this.timestamp,
    this.noteId,
    this.cardId,
    this.todoId,
    this.eventId,
    this.surveyId,
    this.boardId,
    this.serviceId,
    this.serviceRequestId,
  });

  Map<String, dynamic> toMap() {
    return {
      'Title': title,
      'Title_Arabic': titleArabic,
      'Body': body,
      'Body_Arabic': bodyArabic,
      'Type': type,
      'Seen': seen,
      'Timestamp': timestamp,
      "Note_Id": noteId,
      "Card_Id": cardId,
      "Todo_Id": todoId,
      "Event_Id": eventId,
      "Survey_Id": surveyId,
      "Board_Id": boardId,
      "Service_Id": serviceId,
      "Service_Request_Id": serviceRequestId,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['Title'],
      titleArabic: map['Title_Arabic'],
      body: map['Body'],
      bodyArabic: map['Body_Arabic'],
      type: map['Type'],
      seen: map['Seen'],
      timestamp: map['Timestamp'],
      noteId: map["Note_Id"],
      cardId: map["Card_Id"],
      todoId: map["Todo_Id"],
      eventId: map["Event_Id"],
      surveyId: map["Survey_Id"],
      boardId: map["Board_Id"],
      serviceId: map["Service_Id"],
      serviceRequestId: map["Service_Request_Id"],
    );
  }
}
