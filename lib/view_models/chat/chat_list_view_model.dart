import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:chatting_1/models/user_model.dart';

// 채팅 목록 표현용 아이템
class ChatRoomItem {
  final String chatRoomId;
  final String lastMessage;
  final int lastMessageTime;
  final UserModel otherUser;
  final String status;

  ChatRoomItem({
    required this.chatRoomId,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.otherUser,
    required this.status,
  });
}

class ChatListState {
  final bool isLoading;
  final String errorMessage;
  final List<ChatRoomItem> roomItems;

  ChatListState({
    this.isLoading = false,
    this.errorMessage = '',
    this.roomItems = const [],
  });

  ChatListState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<ChatRoomItem>? roomItems,
  }) {
    return ChatListState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      roomItems: roomItems ?? this.roomItems,
    );
  }
}

class ChatListViewModel extends StateNotifier<ChatListState> {
  ChatListViewModel() : super(ChatListState()) {
    _subscribeToChatRooms();
  }

  final _dbRef = FirebaseDatabase.instance.ref();
  final _auth = FirebaseAuth.instance;

  /// 실시간 채팅방 변경사항 구독
  void _subscribeToChatRooms() {
    final myUid = _auth.currentUser?.uid;
    if (myUid == null || myUid.isEmpty) return;
    // 채팅방 데이터의 onValue 스트림 구독
    _dbRef.child('chatRooms').onValue.listen((event) async {
      if (event.snapshot.value == null) {
        state = state.copyWith(isLoading: false, roomItems: []);
        return;
      }
      final data = Map<dynamic, dynamic>.from(event.snapshot.value as Map);
      final List<ChatRoomItem> items = [];
      // 모든 채팅방 순회
      for (final entry in data.entries) {
        final chatRoomId = entry.key as String;
        final roomMap = Map<dynamic, dynamic>.from(entry.value);
        // 참여자 정보 확인
        final usersMap = roomMap['users'] as Map<dynamic, dynamic>?;
        if (usersMap == null) continue;
        if (!usersMap.containsKey(myUid)) continue; // 내 uid가 없으면 건너뜀

        // status가 'accepted'인지 확인
        final status = roomMap['status'] as String? ?? 'requested';
        if (status != 'accepted') continue;

        final lastMsg = roomMap['lastMessage'] as String? ?? '';
        final lastTime = roomMap['lastMessageTime'] as int? ?? 0;

        // 내 uid가 아닌 상대 uid 찾기
        String otherUid = '';
        for (final u in usersMap.keys) {
          if (u != myUid) {
            otherUid = u;
            break;
          }
        }

        final otherUser = await _fetchUser(otherUid);
        items.add(ChatRoomItem(
          chatRoomId: chatRoomId,
          lastMessage: lastMsg,
          lastMessageTime: lastTime,
          otherUser: otherUser,
          status: status,
        ));
      }
      // 최신순 정렬
      items.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
      state = state.copyWith(isLoading: false, roomItems: items);
    });
  }

  Future<UserModel> _fetchUser(String uid) async {
    final snap = await _dbRef.child('users').child(uid).get();
    if (!snap.exists) {
      // 임시 UserModel
      return UserModel(
        uid: uid,
        userName: "Unknown",
        gender: '',
        ageGroup: '',
        purpose: '',
        introduce: '',
        location: '',
        myLanguage: '',
        targetLanguage: '',
        languageLevel: '',
        profileImageUrls: const [],
        friends: const {},
        studentCardUrl: '',
        createdAt: '',
        updatedAt: '',
      );
    }
    final userMap = Map<String, dynamic>.from(snap.value as Map);
    return UserModel.fromJson(userMap);
  }

  // 아직 채팅방이 없는 경우: 생성/ 있는 경우: 해당 방 ID 리턴
  Future<String> createOrGetChatRoom(String otherUid) async {
    final myUid = _auth.currentUser?.uid ?? '';
    if (myUid.isEmpty || otherUid.isEmpty) {
      throw Exception("잘못된 UID");
    }
    final sorted = [myUid, otherUid]..sort();
    final chatRoomId = "${sorted[0]}_${sorted[1]}";

    final chatRoomRef = _dbRef.child('chatRooms').child(chatRoomId);
    final snap = await chatRoomRef.get();
    if (!snap.exists) {
      await chatRoomRef.set({
        'createdAt': DateTime.now().toIso8601String(),
        'users': {
          myUid: true,
          otherUid: true,
        },
        'lastMessage': '',
        'lastMessageTime': 0,
        'status': 'requested',
      });
      final userSnap = await _dbRef.child('users').child(myUid).get();
      final currentUserMap = userSnap.value as Map<dynamic, dynamic>;
      final currentUserName = currentUserMap['userName'] ?? "Unknown";
      final profileImages = currentUserMap['profileImageUrls'];
      final currentUserProfileImageUrl = (profileImages is List && profileImages.isNotEmpty)
          ? profileImages.first as String
          : "";

      final notifRef = _dbRef.child('users').child(otherUid).child('notifications').push();
      final notificationData = {
        'id': notifRef.key,
        'type': 'chat_request',
        'fromUserUid': myUid,
        'toUserUid': otherUid,
        'title': '채팅 요청',
        'message': '새로운 채팅 요청',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'isRead': false,
        'senderProfileImageUrl': currentUserProfileImageUrl,
        'senderUsername': currentUserName,
      };
      await notifRef.set(notificationData);
    }
    return chatRoomId;
  }
}

final chatListViewModelProvider =
StateNotifierProvider<ChatListViewModel, ChatListState>((ref) {
  return ChatListViewModel();
});
