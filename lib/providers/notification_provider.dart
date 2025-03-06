import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatting_1/view_models/notification_view_model.dart';

final notificationViewModelProvider = StateNotifierProvider<NotificationViewModel, NotificationState>((ref) {
  return NotificationViewModel();
});
