import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatting_1/models/notification_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationState {
  final bool isLoading;
  final String errorMessage;
  final List<NotificationModel> notifications;

  NotificationState({
    this.isLoading = false,
    this.errorMessage = '',
    this.notifications = const [],
  });

  NotificationState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<NotificationModel>? notifications,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      notifications: notifications ?? this.notifications,
    );
  }
}

class NotificationViewModel extends StateNotifier<NotificationState> {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  NotificationViewModel() : super(NotificationState()) {
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: '');
      final user = _auth.currentUser;
      if (user == null) {
        state = state.copyWith(isLoading: false, errorMessage: 'User not logged in');
        return;
      }
      final userUid = user.uid;
      // 실시간으로 notifications 데이터를 구독합니다.
      _db.child('users').child(userUid).child('notifications').onValue.listen((event) {
        if (event.snapshot.value != null) {
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);
          List<NotificationModel> notifications = data.entries.map((entry) {
            final json = Map<String, dynamic>.from(entry.value);
            return NotificationModel.fromJson(json);
          }).toList();
          // 최신 알림이 위에 오도록 정렬
          notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          state = state.copyWith(notifications: notifications, isLoading: false);
        } else {
          state = state.copyWith(notifications: [], isLoading: false);
        }
      });
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;
      await _db.child('users').child(user.uid).child('notifications').child(notificationId).update({
        'isRead': true,
      });
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;
      await _db.child('users').child(user.uid).child('notifications').child(notificationId).remove();
    } catch (e) {
      print('Error deleting notification: $e');
    }
  }

  // 알림 생성 로직: 친구 요청, 채팅 요청 등 이벤트 발생 시 호출
  Future<void> createNotification({
    required String type,
    required String fromUserUid,
    required String toUserUid,
    required String title,
    required String message,
    int? timestamp,
  }) async {
    try {
      final ts = timestamp ?? DateTime.now().millisecondsSinceEpoch;
      final notifRef = _db.child('users').child(toUserUid).child('notifications').push();
      final newNotification = NotificationModel(
        id: notifRef.key ?? '',
        type: type,
        fromUserUid: fromUserUid,
        toUserUid: toUserUid,
        title: title,
        message: message,
        timestamp: ts,
        isRead: false,
      );
      await notifRef.set(newNotification.toJson());
    } catch (e) {
      print('Error creating notification: $e');
    }
  }
}
