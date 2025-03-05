import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatting_1/view_models/chat/chat_list_view_model.dart';
import 'package:chatting_1/widgets/user_tile.dart';
import 'package:chatting_1/views/chat/chat_view.dart';
import 'package:chatting_1/utils/route.dart';

class ChatListView extends ConsumerWidget {
  final void Function(bool) toggleRequest;

  const ChatListView({Key? key, required this.toggleRequest}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatListState = ref.watch(chatListViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chatting"),
        backgroundColor: const Color(0xFF262626),
        actions: [
          IconButton(
            onPressed: () => toggleRequest(true),
            icon: const Icon(Icons.chat_bubble_outline),
          ),
        ],
      ),
      body: chatListState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : chatListState.errorMessage.isNotEmpty
          ? Center(child: Text("오류: ${chatListState.errorMessage}"))
          : ListView.builder(
        itemCount: chatListState.roomItems.length,
        itemBuilder: (context, index) {
          final roomItem = chatListState.roomItems[index];
          final otherUser = roomItem.otherUser;
          final lastMsg = roomItem.lastMessage;

          return UserTile(
            user: otherUser,
            subtitle: lastMsg.isEmpty ? "(대화가 없습니다)" : "마지막 대화: $lastMsg",
            onTap: () {
              // 채팅방으로 이동할 때 AppRoutes.push() 사용 (뒤로가기를 허용)
              AppRoutes.push(
                context,
                ChatPage(
                  chatId: roomItem.chatRoomId,
                  otherUserUid: otherUser.uid,
                  otherUserName: otherUser.userName,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
