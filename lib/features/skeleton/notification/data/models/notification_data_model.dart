import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModelSystem {
  final String? id; // Document ID in Firestore
  final String title;
  final String body;
  final String nameOfModule; // e.g., 'services', 'inventory', etc.
  final String senderEmail;
  final String receiverEmail;
  final String nameOfPage; // Widget name or page identifier
  final bool isPinned;
  final int timestamp; // Timestamp in milliseconds
  final bool isRead; // Track if notification has been read
  final bool isClean; // Track if notification has been read

  NotificationModelSystem({
    this.id,
    required this.title,
    required this.body,
    required this.nameOfModule,
    required this.senderEmail,
    required this.receiverEmail,
    required this.nameOfPage,
    this.isPinned = false,
    int? timestamp,
    this.isRead = false,
    this.isClean = false,
  }) : timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  // Convert NotificationModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'Name_of_module': nameOfModule,
      'Sender_Email': senderEmail,
      'Reciver_Email': receiverEmail,
      'name_of_page': nameOfPage,
      'Pin': isPinned,
      'timestamp': timestamp,
      'isRead': isRead,
      'isClean': isClean,
    };
  }

  // Create NotificationModel from Firestore DocumentSnapshot
  factory NotificationModelSystem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModelSystem(
      id: doc.id,
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      nameOfModule: data['Name_of_module'] ?? '',
      senderEmail: data['Sender_Email'] ?? '',
      receiverEmail: data['Reciver_Email'] ?? '',
      nameOfPage: data['name_of_page'] ?? '',
      isPinned: data['Pin'] ?? false,
      timestamp: data['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
      isRead: data['isRead'] ?? false,
      isClean: data['isClean'] ?? false,
    );
  }

  // Create NotificationModel from Map
  factory NotificationModelSystem.fromMap(Map<String, dynamic> map, {String? id}) {
    return NotificationModelSystem(
      id: id,
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      nameOfModule: map['Name_of_module'] ?? '',
      senderEmail: map['Sender_Email'] ?? '',
      receiverEmail: map['Reciver_Email'] ?? '',
      nameOfPage: map['name_of_page'] ?? '',
      isPinned: map['Pin'] ?? false,
      timestamp: map['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
      isRead: map['isRead'] ?? false,
      isClean: map['isClean'] ?? false,
    );
  }

  // Copy with method for updating specific fields
  NotificationModelSystem copyWith({
    String? id,
    String? title,
    String? body,
    String? nameOfModule,
    String? senderEmail,
    String? receiverEmail,
    String? nameOfPage,
    bool? isPinned,
    int? timestamp,
    bool? isRead,
    bool? isClean,
  }) {
    return NotificationModelSystem(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      nameOfModule: nameOfModule ?? this.nameOfModule,
      senderEmail: senderEmail ?? this.senderEmail,
      receiverEmail: receiverEmail ?? this.receiverEmail,
      nameOfPage: nameOfPage ?? this.nameOfPage,
      isPinned: isPinned ?? this.isPinned,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      isClean: isClean ?? this.isClean,
    );
  }

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, module: $nameOfModule, sender: $senderEmail, receiver: $receiverEmail, pinned: $isPinned, read: $isRead)';
  }
}