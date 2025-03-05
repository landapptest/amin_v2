import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:chatting_1/models/message_model.dart';
import 'dart:async';

//채팅 전송/수신 로직
class ChatViewModel extends StateNotifier<void> {
  ChatViewModel() : super(null);

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseDatabase.instance.ref();

  //메시지 전송 시:
  //1) messages/{chatId}/push => 메시지 저장
  //2) chatRooms/{chatId}/lastMessage, lastMessageTime => 갱신
  Future<void> sendMessage(String chatId, String content) async {
    final myUid = _auth.currentUser?.uid ?? '';
    if (myUid.isEmpty) return;

    final timestamp = DateTime.now().millisecondsSinceEpoch;

    //1) 메시지 저장
    final newMsgRef = _db.child('messages').child(chatId).push();
    await newMsgRef.set({
      'senderUid': myUid,
      'content': content,
      'timestamp': timestamp,
    });

    //2) chatRooms/{chatId} 갱신
    final chatRoomRef = _db.child('chatRooms').child(chatId);
    await chatRoomRef.update({
      'lastMessage': content,
      'lastMessageTime': timestamp,
    });
  }

  //특정 채팅방의 메시지 리스트 스트림
  Stream<List<MessageModel>> watchMessages(String chatId) {
    final msgRef = _db.child('messages').child(chatId);
    // onValue => 전체 메시지 목록이 변경될 때마다
    return msgRef.onValue.map((event) {
      if (event.snapshot.value == null) {
        return <MessageModel>[];
      }
      final data = Map<Object?, Object?>.from(event.snapshot.value as Map);
      final List<MessageModel> messages = [];
      data.forEach((key, value) {
        final msgMap = Map<String, dynamic>.from(value as Map);
        final msgModel = MessageModel.fromJson(msgMap);
        messages.add(msgModel);
      });
      //시간순 정렬
      messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return messages;
    });
  }

  /// 내 UID
  String currentUserUid() {
    return _auth.currentUser?.uid ?? '';
  }
}

/// Riverpod Provider
final chatViewModelProvider = StateNotifierProvider<ChatViewModel, void>((ref) {
  return ChatViewModel();
});
