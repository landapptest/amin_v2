import 'package:flutter/material.dart';
import 'package:chatting_1/models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;
  final VoidCallback? onMarkAsRead;
  final VoidCallback? onDelete;

  const NotificationCard({
    Key? key,
    required this.notification,
    this.onTap,
    this.onMarkAsRead,
    this.onDelete,
  }) : super(key: key);

  Color _getBackgroundColor(String type) {
    switch (type) {
      case 'chat_request':
      case 'chat_accepted':
        return const Color(0xCCFF8000);
      case 'friend_request':
      case 'friend_accepted':
        return const Color(0xCC68C7F3);
      default:
        return Colors.grey.shade200;
    }
  }

  String _buildSubtitle(String type, String senderName) {
    switch (type) {
      case 'chat_request':
      case 'chat_accepted':
        return "$senderName이 채팅 요청을 보냈습니다.";
      case 'friend_request':
      case 'friend_accepted':
        return "$senderName이 친구 요청을 보냈습니다.";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _getBackgroundColor(notification.type);
    final subtitleText = _buildSubtitle(notification.type, notification.senderUsername);

    return InkWell(
      onTap: onTap,
      onLongPress: onDelete,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              backgroundImage: notification.senderProfileImageUrl.isNotEmpty
                  ? NetworkImage(notification.senderProfileImageUrl)
                  : const AssetImage('assets/default_profile.png') as ImageProvider,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitleText,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (!notification.isRead)
              IconButton(
                icon: const Icon(Icons.mark_email_read, color: Colors.green),
                onPressed: onMarkAsRead,
              ),
          ],
        ),
      ),
    );
  }
}
