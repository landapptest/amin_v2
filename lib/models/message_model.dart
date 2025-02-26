import 'package:flutter/foundation.dart';

@immutable
class MessageModel {
  final String senderUid;
  final String content;
  final int timestamp;

  const MessageModel({
    required this.senderUid,
    required this.content,
    required this.timestamp,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderUid: json['senderUid'] ?? '',
      content: json['content'] ?? '',
      timestamp: json['timestamp'] ?? 0,
    );
  }
}
