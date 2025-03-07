import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatting_1/models/notification_model.dart';
import 'package:chatting_1/providers/notification_provider.dart';

class NotificationCard extends ConsumerWidget {
  final NotificationModel notification;
  const NotificationCard({Key? key, required this.notification}) : super(key: key);

  IconData _getIconForType(String type) {
    switch (type) {
      case 'friend_request':
        return Icons.person_add;
      case 'chat_request':
        return Icons.chat;
      case 'friend_accepted':
        return Icons.check_circle;
      case 'chat_accepted':
        return Icons.check_circle_outline;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Icon(
          _getIconForType(notification.type),
          size: 30,
          color: Colors.blue,
        ),
        title: Text(
          notification.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.message),
            const SizedBox(height: 4),
            Text(
              _formatTimestamp(notification.timestamp),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: notification.isRead
            ? null
            : IconButton(
          icon: const Icon(Icons.mark_email_read, color: Colors.green),
          onPressed: () {
            ref
                .read(notificationViewModelProvider.notifier)
                .markAsRead(notification.id);
          },
        ),
        onLongPress: () {
          // 길게 누르면 삭제 (테스트용으로 구현)
          ref
              .read(notificationViewModelProvider.notifier)
              .deleteNotification(notification.id);
        },
      ),
    );
  }

  String _formatTimestamp(int timestamp) {
    final dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${dt.year}-${_twoDigits(dt.month)}-${_twoDigits(dt.day)} ${_twoDigits(dt.hour)}:${_twoDigits(dt.minute)}';
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');
}
