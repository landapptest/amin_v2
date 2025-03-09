import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 숨기기
      title: 'Chat List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ChatListView(),
    );
  }
}

class ChatListView extends StatelessWidget {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar2(),
      body: Center(
          child: Container(
            color: Colors.white,
          )
      ),
    );
  }
}

AppBar _buildAppBar2() {
  return AppBar(
    backgroundColor: Colors.black,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    elevation: 0,
    leading: const Icon(Icons.chat, color: Color(0xFFCB9C5A)),
    centerTitle: false,
    title: const Row(
      children: [
        Text(
          "Chatting",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}