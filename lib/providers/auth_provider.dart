import 'package:chatting_1/models/auth_model.dart';
import 'package:chatting_1/view_models/auth/login_view_model.dart';
import 'package:chatting_1/view_models/auth/register_collect_view_model.dart';
import 'package:chatting_1/view_models/auth/register_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userControllerProvider = Provider<AuthModel>((ref) {
  return AuthModel();
});

final loginViewModelProvider = StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  final userController = ref.read(userControllerProvider);
  return LoginViewModel(userController);
});

final registerViewModelProvider = StateNotifierProvider<RegisterViewModel, RegisterState>((ref) {
  final userController = ref.read(userControllerProvider);
  return RegisterViewModel(userController);
});

final registerCollectViewModelProvider = StateNotifierProvider<RegisterCollectViewModel, RegisterCollectState>((ref) {
  return RegisterCollectViewModel();
});