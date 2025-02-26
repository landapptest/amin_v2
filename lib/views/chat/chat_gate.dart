import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'chat_list_view.dart';
import 'chat_request_view.dart';

//채팅 목록과 채팅 요청을 스위치 해서 보여주는 위젯
class ChatGate extends ConsumerStatefulWidget {
  const ChatGate({super.key});

  @override
  ConsumerState<ChatGate> createState() => _ChatGateState();
}

class _ChatGateState extends ConsumerState<ChatGate> {
  bool isRequest = false;// false: 목록, true: 요청

  void toggleRequest(bool value) {
    setState(() {
      isRequest = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return !isRequest
        ? ChatListView(toggleRequest: toggleRequest)
        : ChatRequestView(toggleRequest: toggleRequest);
  }
}
