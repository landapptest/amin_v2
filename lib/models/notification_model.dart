import 'package:flutter/foundation.dart';

class NotificationModel {
  final String id;
  final String type;
  final String fromUserUid;
  final String toUserUid;
  final String title;
  final String message;
  final int timestamp;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.type,
    required this.fromUserUid,
    required this.toUserUid,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      fromUserUid: json['fromUserUid'] ?? '',
      toUserUid: json['toUserUid'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      timestamp: json['timestamp'] is int ? json['timestamp'] : 0,
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'fromUserUid': fromUserUid,
      'toUserUid': toUserUid,
      'title': title,
      'message': message,
      'timestamp': timestamp,
      'isRead': isRead,
    };
  }
}
