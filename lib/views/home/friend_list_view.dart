import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'friend_request_view.dart';
import 'package:chatting_1/models/user_model.dart';
import 'package:chatting_1/widgets/user_tile.dart';
import 'package:chatting_1/view_models/friend_view_model.dart';

//FriendGate: 친구 목록<-> 친구 요청 전환 컨테이너
class FriendGate extends StatefulWidget {
  const FriendGate({Key? key}) : super(key: key);

  @override
  State<FriendGate> createState() => _FriendGateState();
}

class _FriendGateState extends State<FriendGate> {
  bool isRequest = false;

  void toggleRequest(bool value) {
    setState(() {
      isRequest = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return !isRequest
        ? FriendListView(toggleRequest: toggleRequest)
        : FriendRequestView(toggleRequest: toggleRequest);
  }
}

//실제 친구 목록 화면: 'accepted' 상태인 친구들 표시
class FriendListView extends ConsumerStatefulWidget {
  final void Function(bool) toggleRequest;
  const FriendListView({Key? key, required this.toggleRequest}) : super(key: key);

  @override
  ConsumerState<FriendListView> createState() => _FriendListViewState();
}

class _FriendListViewState extends ConsumerState<FriendListView> {
  @override
  void initState() {
    super.initState();
    // 화면 들어오면 'accepted' 친구들 목록 fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(friendViewModelProvider.notifier).fetchAcceptedFriends();
    });
  }

  @override
  Widget build(BuildContext context) {
    final friendState = ref.watch(friendViewModelProvider);

    return Scaffold(
      appBar: _buildAppBar3(context),
      body: friendState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(friendState),
    );
  }

  PreferredSizeWidget _buildAppBar3(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF262626),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('assets/amin_icon.png', fit: BoxFit.contain),
      ),
      centerTitle: false,
      title: const Row(
        children: [
          Text(
            "My friends",
            style: TextStyle(
              color: Color(0xFFFCFCFC),
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      actions: [
        Tooltip(
          message: "Friend requests",
          child: IconButton(
            icon: const Icon(
              PhosphorIconsRegular.handWaving,
              color: Color(0xFFFCFCFC),
              size: 25,
            ),
            onPressed: () {
              //친구 요청 화면으로 전환
              widget.toggleRequest(true);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBody(FriendState friendState) {
    final friends = friendState.acceptedFriends;
    if (friends.isEmpty) {
      return const Center(child: Text("아직 수락된 친구가 없습니다."));
    }
    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final user = friends[index];
        return _friendTile(user);
      },
    );
  }

  Widget _friendTile(UserModel friendUser) {
    return UserTile(
      user: friendUser,
      subtitle: friendUser.introduce,
      onTap: () {
        //친구 상세 페이지로 이동 추가
        debugPrint("Clicked friend: ${friendUser.userName}");
      },
    );
  }
}
