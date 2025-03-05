import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatting_1/view_models/chat/chat_view_model.dart';
import 'package:chatting_1/models/message_model.dart';
import 'package:chatting_1/widgets/chat_bubble.dart';
import 'package:chatting_1/widgets/mytextfield.dart';

class ChatPage extends ConsumerStatefulWidget {
  final String chatId;
  final String otherUserUid;
  final String otherUserName;

  const ChatPage({
    Key? key,
    required this.chatId,
    required this.otherUserUid,
    required this.otherUserName,
  }) : super(key: key);

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final chatVM = ref.read(chatViewModelProvider.notifier);
    final messageStream = chatVM.watchMessages(widget.chatId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF262626),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
        title: Text(widget.otherUserName, style: TextStyle(color: Colors.white)),
      ),

      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: messageStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text("메시지 구독 오류: ${snapshot.error}"),
                  );
                }
                final messages = snapshot.data ?? [];
                if (messages.isEmpty) {
                  return const Center(child: Text("메시지가 없습니다."));
                }

                //최신 메시지를 아래로 표시하기 위해 reverse
                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final realIndex = messages.length - 1 - index;
                    final msg = messages[realIndex];
                    return _buildMessageItem(msg);
                  },
                );
              },
            ),
          ),
          _buildUserInput(context),
        ],
      ),
    );
  }

  Widget _buildMessageItem(MessageModel msg) {
    final chatVM = ref.read(chatViewModelProvider.notifier);
    final isCurrentUser = (msg.senderUid == chatVM.currentUserUid());
    final alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChatBubble(
            message: msg.content,
            isCurrentUser: isCurrentUser,
          ),
        ],
      ),
    );
  }

  Widget _buildUserInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: "Type a message",
              obscureText: false,
            ),
          ),

          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: _sendMessage,
              icon: const Icon(Icons.arrow_upward, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    final chatVM = ref.read(chatViewModelProvider.notifier);
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    await chatVM.sendMessage(widget.chatId, text);
    _messageController.clear();
    FocusScope.of(context).unfocus();

    await Future.delayed(const Duration(milliseconds: 100));
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
    }
  }
}
