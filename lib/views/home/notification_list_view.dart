import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatting_1/widgets/notification_card.dart';
import 'package:chatting_1/providers/notification_provider.dart';

class NotificationListView extends ConsumerWidget {
  const NotificationListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF262626),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/amin_icon.png', fit: BoxFit.contain),
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: Color(0xFFFCFCFC),
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: notificationState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : notificationState.errorMessage.isNotEmpty
          ? Center(child: Text("Error: ${notificationState.errorMessage}"))
          : notificationState.notifications.isEmpty
          ? const Center(child: Text("No notifications"))
          : ListView.builder(
        itemCount: notificationState.notifications.length,
        itemBuilder: (context, index) {
          final notification =
          notificationState.notifications[index];
          return NotificationCard(notification: notification);
        },
      ),
    );
  }
}
