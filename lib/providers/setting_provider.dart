import 'package:chatting_1/view_models/setting_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingProvider = StateNotifierProvider<SettingViewModel, SettingState>((ref) {
  return SettingViewModel();
});