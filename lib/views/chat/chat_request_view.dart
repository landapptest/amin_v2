import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatting_1/view_models/chat_request_view_model.dart';

class ChatRequestView extends ConsumerStatefulWidget {
  final void Function(bool) toggleRequest;
  const ChatRequestView({Key? key, required this.toggleRequest}) : super(key: key);

  @override
  ConsumerState<ChatRequestView> createState() => _ChatRequestViewState();
}

class _ChatRequestViewState extends ConsumerState<ChatRequestView> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //처음 진입 시 "status=='requested'"인 채팅방들만 가져오기
      ref.read(chatRequestViewModelProvider.notifier).fetchRequestedRooms();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatRequestState = ref.watch(chatRequestViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Requests"),
        backgroundColor: const Color(0xFF262626),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => widget.toggleRequest(false),
        ),
      ),
      body: chatRequestState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(chatRequestState),
    );
  }

  Widget _buildBody(ChatRequestState state) {
    if (state.requestedRooms.isEmpty) {
      return const Center(child: Text("채팅 요청이 없습니다."));
    }
    return ListView.builder(
      itemCount: state.requestedRooms.length,
      itemBuilder: (context, index) {
        final req = state.requestedRooms[index];
        return ListTile(
          // 프로필 이미지: 추후 클릭 시 상세 페이지 보여주기
          leading: CircleAvatar(
            backgroundImage: (req.otherUser.profileImageUrls.isNotEmpty)
                ? NetworkImage(req.otherUser.profileImageUrls.first)
                : const AssetImage('assets/default_profile.png') as ImageProvider,
          ),
          title: Text(req.otherUser.userName),
          subtitle: Text("요청 상태: ${req.status}"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () async {
                  // 수락
                  await ref
                      .read(chatRequestViewModelProvider.notifier)
                      .acceptChatRequest(req.chatRoomId);
                },
                child: const Text("수락", style: TextStyle(color: Colors.blue)),
              ),
              TextButton(
                onPressed: () async {
                  // 거절
                  await ref
                      .read(chatRequestViewModelProvider.notifier)
                      .rejectChatRequest(req.chatRoomId);
                },
                child: const Text("거절", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
    );
  }
}
