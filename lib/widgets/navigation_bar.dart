import 'package:flutter/material.dart';
import 'package:chatting_1/views/home/friend_list_view.dart';
import 'package:chatting_1/views/home/friend_search_view.dart';
import 'package:chatting_1/views/home/notification_list_view.dart';
import 'package:chatting_1/views/home/profile_view.dart';
import 'package:chatting_1/views/chat/chat_gate.dart';

class NavigationBar extends StatefulWidget {
  const NavigationBar({super.key});

  @override
  State<NavigationBar> createState() => _NavigationBarState();
}


class _NavigationBarState extends State<NavigationBar> {
  final List<Widget> _navigationItem = [
    Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(Icons.chat, color: Colors.white), // 아이콘
      ],
    ),
    Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(Icons.people, color: Colors.white),
      ],
    ),
    Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(Icons.public, color: Colors.white),
      ],
    ),
    Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(Icons.notifications, color: Colors.white),
      ],
    ),
    Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(Icons.person, color: Colors.white),
      ],
    ),
  ];

  final List<Widget> screens = [
    const ChatGate(),
    const FriendGate(),
    const FriendSearchView(),
    const NotificationListView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }}