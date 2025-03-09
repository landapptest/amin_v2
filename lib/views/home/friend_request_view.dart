import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatting_1/view_models/friend_view_model.dart';
import 'package:chatting_1/models/user_model.dart';

class FriendRequestView extends ConsumerStatefulWidget {
  final void Function(bool) toggleRequest;
  const FriendRequestView({Key? key, required this.toggleRequest})
      : super(key: key);

  @override
  ConsumerState<FriendRequestView> createState() => _FriendRequestViewState();
}

class _FriendRequestViewState extends ConsumerState<FriendRequestView> {
  @override
  void initState() {
    super.initState();
    //화면 진입 시, 내가 받은 친구 요청 목록 불러오기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(friendViewModelProvider.notifier).fetchPendingRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final friendState = ref.watch(friendViewModelProvider);

    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Colors.white,
      body: friendState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(friendState),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF262626),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('assets/amin_icon.png', fit: BoxFit.contain),
      ),
      centerTitle: false,
      title: const Text(
        "Friend Requests",
        style: TextStyle(
          color: Color(0xFFFCFCFC),
          fontFamily: "Montserrat",
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        Tooltip(
          message: "Friends List",
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFFFCFCFC),
            ),
            onPressed: () => widget.toggleRequest(false),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(FriendState friendState) {
    if (friendState.pendingRequests.isEmpty) {
      return const Center(child: Text("받은 친구 요청이 없습니다."));
    }

    return ListView.builder(
      itemCount: friendState.pendingRequests.length,
      itemBuilder: (context, index) {
        final reqUser = friendState.pendingRequests[index];
        return _requestTile(reqUser);
      },
    );
  }

  Widget _requestTile(UserModel reqUser) {
    final friendVM = ref.read(friendViewModelProvider.notifier);

    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundImage: (reqUser.profileImageUrls.isNotEmpty)
            ? NetworkImage(reqUser.profileImageUrls.first)
            : const AssetImage('assets/default_profile.png') as ImageProvider,
      ),
      title: Text(reqUser.userName),
      subtitle: const Text("나에게 친구 요청을 보냈습니다."),

      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 수락
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: () async {
              await friendVM.acceptFriendRequest(reqUser.uid);
            },
          ),
          // 거절
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () async {
              await friendVM.rejectFriendRequest(reqUser.uid);
            },
          ),
        ],
      ),
    );
  }
}
