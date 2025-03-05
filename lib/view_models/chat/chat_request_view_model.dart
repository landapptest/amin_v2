import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:chatting_1/models/user_model.dart';

class ChatRequestItem {
  final String chatRoomId;
  final String lastMessage;
  final String status; // "requested", etc.
  final UserModel otherUser;

  ChatRequestItem({
    required this.chatRoomId,
    required this.lastMessage,
    required this.status,
    required this.otherUser,
  });
}

//화면에 표시할 상태
class ChatRequestState {
  final bool isLoading;
  final String errorMessage;
  final List<ChatRequestItem> requestedRooms;

  ChatRequestState({
    this.isLoading = false,
    this.errorMessage = '',
    this.requestedRooms = const [],
  });

  ChatRequestState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<ChatRequestItem>? requestedRooms,
  }) {
    return ChatRequestState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      requestedRooms: requestedRooms ?? this.requestedRooms,
    );
  }
}

class ChatRequestViewModel extends StateNotifier<ChatRequestState> {
  ChatRequestViewModel() : super(ChatRequestState());

  final _db = FirebaseDatabase.instance.ref();
  final _auth = FirebaseAuth.instance;

  //현재 "status=='requested'" 인 채팅방만 가져오기
  Future<void> fetchRequestedRooms() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: '');
      final myUid = _auth.currentUser?.uid;
      if (myUid == null) {
        throw Exception("로그인 필요");
      }

      final snapshot = await _db.child('chatRooms').get();
      if (!snapshot.exists) {
        state = state.copyWith(isLoading: false, requestedRooms: []);
        return;
      }

      final data = Map<dynamic, dynamic>.from(snapshot.value as Map);
      final List<ChatRequestItem> tempList = [];

      for (final entry in data.entries) {
        final roomId = entry.key as String;
        final roomMap = Map<dynamic, dynamic>.from(entry.value);

        final usersMap = roomMap['users'] as Map<dynamic, dynamic>?;
        if (usersMap == null) continue;
        if (!usersMap.containsKey(myUid)) continue;

        final status = roomMap['status'] as String? ?? 'requested';
        if (status != 'requested') {
          continue;
        }

        final lastMsg = roomMap['lastMessage'] as String? ?? '';

        //상대방 찾기
        String otherUid = '';
        for (final u in usersMap.keys) {
          if (u != myUid) {
            otherUid = u;
            break;
          }
        }

        final otherUser = await _fetchUser(otherUid);

        tempList.add(ChatRequestItem(
          chatRoomId: roomId,
          lastMessage: lastMsg,
          status: status,
          otherUser: otherUser,
        ));
      }

      state = state.copyWith(isLoading: false, requestedRooms: tempList);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  //상대방 프로필 가져오기
  Future<UserModel> _fetchUser(String uid) async {
    final snap = await _db.child('users').child(uid).get();
    if (!snap.exists) {
      // 임시
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
        profileImageUrls: [],
        friends: {},
        studentCardUrl: '',
        createdAt: '',
        updatedAt: '',
      );
    }
    final userMap = Map<String, dynamic>.from(snap.value as Map);
    return UserModel.fromJson(userMap);
  }

  //채팅 요청 수락 => status='accepted'
  Future<void> acceptChatRequest(String chatRoomId) async {
    try {
      await _db.child('chatRooms').child(chatRoomId).update({
        'status': 'accepted',
      });
      // 변경 후 다시 요청 목록 fetch
      await fetchRequestedRooms();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  //채팅 요청 거절 => status='rejected'
  Future<void> rejectChatRequest(String chatRoomId) async {
    try {
      await _db.child('chatRooms').child(chatRoomId).update({
        'status': 'rejected',
      });
      await fetchRequestedRooms();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}

final chatRequestViewModelProvider =
StateNotifierProvider<ChatRequestViewModel, ChatRequestState>((ref) {
  return ChatRequestViewModel();
});
