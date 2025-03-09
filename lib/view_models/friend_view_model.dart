import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:chatting_1/models/user_model.dart';

//친구 수락/거절, 목록 관리
class FriendState {
  final bool isLoading;
  final String errorMessage;

  //내가 받은 친구 요청 (pending)
  final List<UserModel> pendingRequests;

  //이미 accepted 상태인 친구 목록
  final List<UserModel> acceptedFriends;

  FriendState({
    this.isLoading = false,
    this.errorMessage = '',
    this.pendingRequests = const [],
    this.acceptedFriends = const [],
  });

  FriendState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<UserModel>? pendingRequests,
    List<UserModel>? acceptedFriends,
  }) {
    return FriendState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      pendingRequests: pendingRequests ?? this.pendingRequests,
      acceptedFriends: acceptedFriends ?? this.acceptedFriends,
    );
  }
}

class FriendViewModel extends StateNotifier<FriendState> {
  FriendViewModel() : super(FriendState());

  final _dbRef = FirebaseDatabase.instance.ref();
  final _auth = FirebaseAuth.instance;

  //내가 받은 친구 요청 목록 (state.pendingRequests) 구하기
  Future<void> fetchPendingRequests() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: '');
      final myUid = _auth.currentUser?.uid;
      if (myUid == null || myUid.isEmpty) {
        throw Exception("로그인되지 않음");
      }

      //DB에서 전체 users 가져와서,
      final snap = await _dbRef.child('users').get();
      if (!snap.exists) {
        state = state.copyWith(isLoading: false, pendingRequests: []);
        return;
      }

      final data = snap.value as Map<dynamic, dynamic>;
      final List<UserModel> userList = [];

      data.forEach((key, value) {
        if (value is Map) {
          final userMap = Map<String, dynamic>.from(value);
          final userModel = UserModel.fromJson(userMap);

          //"상대방 user.friends[myUid]"가 "requested"이면
          //→ "상대방이 나에게 친구 요청을 보낸" 상태
          if (userModel.uid != myUid) {
            final relation = userModel.friends[myUid];
            if (relation == "requested") {
              userList.add(userModel);
            }
          }
        }
      });

      //pendingRequests만 갱신
      state = state.copyWith(isLoading: false, pendingRequests: userList);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  //accepted 상태의 친구 목록 구하기
  Future<void> fetchAcceptedFriends() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: '');
      final myUid = _auth.currentUser?.uid;
      if (myUid == null || myUid.isEmpty) {
        throw Exception("로그인되지 않음");
      }

      final snap = await _dbRef.child('users').get();
      if (!snap.exists) {
        state = state.copyWith(isLoading: false, acceptedFriends: []);
        return;
      }

      final data = snap.value as Map<dynamic, dynamic>;
      final List<UserModel> userList = [];

      data.forEach((key, value) {
        if (value is Map) {
          final userMap = Map<String, dynamic>.from(value);
          final userModel = UserModel.fromJson(userMap);

          //상대방 user.friends[myUid]가 "accepted"인지 확인
          if (userModel.uid != myUid) {
            final relation = userModel.friends[myUid];
            if (relation == "accepted") {
              userList.add(userModel);
            }
          }
        }
      });
      //acceptedFriends만 갱신
      state = state.copyWith(isLoading: false, acceptedFriends: userList);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  //친구 요청 수락
  Future<void> acceptFriendRequest(String fromUserUid) async {
    final myUid = _auth.currentUser?.uid;
    if (myUid == null || myUid.isEmpty) return;

    try {
      final updates = <String, dynamic>{};
      final notifRef = _dbRef.child('users').child(fromUserUid).child('notifications').push();
      updates["users/$myUid/friends/$fromUserUid"] = "accepted";
      updates["users/$fromUserUid/friends/$myUid"] = "accepted";

      await _dbRef.update(updates);
      //수락 후, 다시 요청/친구목록 갱신
      await fetchPendingRequests();
      await fetchAcceptedFriends();
      final senderUsername = _auth.currentUser?.displayName ?? "Unknown";
      final senderProfileImageUrl = "";
      final notificationData = {
        'id': notifRef.key,
        'type': 'friend_accepted',
        'fromUserUid': myUid,
        'toUserUid': fromUserUid,
        'title': '친구 요청 수락',
        'message': '친구 요청 수락됨',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'isRead': false,
        'senderProfileImageUrl': senderProfileImageUrl,
        'senderUsername': senderUsername,
      };
      await notifRef.set(notificationData);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  //친구 요청 거절
  Future<void> rejectFriendRequest(String fromUserUid) async {
    final myUid = _auth.currentUser?.uid;
    if (myUid == null || myUid.isEmpty) return;

    try {
      final updates = <String, dynamic>{};
      updates["users/$myUid/friends/$fromUserUid"] = "rejected";
      updates["users/$fromUserUid/friends/$myUid"] = "rejected";

      await _dbRef.update(updates);
      //거절 후, 목록 갱신
      await fetchPendingRequests();
      //거절은 accepted 목록에는 영향을 주지 않으므로, 굳이 fetchAcceptedFriends()는 생략 가능
    } catch (e) {}
  }
}

final friendViewModelProvider = StateNotifierProvider<FriendViewModel, FriendState>((ref) {
  return FriendViewModel();
});
