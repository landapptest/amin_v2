import 'package:chatting_1/models/auth_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 로그인 상태를 담는 불변 상태 객체
class LoginState {
  final bool isLoggedIn;
  final bool canLogin;
  final String errorMessage;
  final String email;
  final String password;
  final UserCredential? userCredential;

  LoginState({
    this.isLoggedIn = false,
    this.canLogin = false,
    this.errorMessage = '',
    this.email = '',
    this.password = '',
    this.userCredential,
  });

  LoginState copyWith({
    bool? isLoggedIn,
    bool? canLogin,
    String? errorMessage,
    String? email,
    String? password,
    UserCredential? userCredential,
  }) {
    return LoginState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      canLogin: canLogin ?? this.canLogin,
      errorMessage: errorMessage ?? this.errorMessage,
      email: email ?? this.email,
      password: password ?? this.password,
      userCredential: userCredential ?? this.userCredential,
    );
  }
}

// 로그인 상태를 관리하는 StateNotifier
class LoginViewModel extends StateNotifier<LoginState> {
  final AuthModel _userController;
  LoginViewModel(this._userController) : super(LoginState());

  // 이메일을 설정하고 로그인 가능 여부를 체크
  void setEmail(String email) {
    state = state.copyWith(email: email);
    _checkCanLogin();
  }

  // 비밀번호를 설정하고 로그인 가능 여부를 체크
  void setPassword(String password) {
    state = state.copyWith(password: password);
    _checkCanLogin();
  }

  // 로그인 버튼 활성화 여부 확인
  void _checkCanLogin() {
    bool canLogin = state.email.isNotEmpty && state.password.isNotEmpty && state.email.contains('@');
    state = state.copyWith(canLogin: canLogin);
  }

  // 로그인 처리
  Future<void> loginWithEmailPassword(BuildContext context) async {
    state = state.copyWith(errorMessage: ''); // 에러 메시지 초기화

    try {
      final userCredential = await _userController.signInWithEmailandPassword(state.email, state.password);
      state = state.copyWith(isLoggedIn: true, errorMessage: '', userCredential: userCredential);
    }
    on Exception catch(e) {
      state = state.copyWith(isLoggedIn: false, errorMessage: '로그인 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(), // TODO: 메세지 다양하게 처리
          ),
        ),
      );
    }
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    state = state.copyWith(errorMessage: ''); // 에러 메시지 초기화

    try {
      final userCredential = await _userController.signInWithGoogle();
      state = state.copyWith(isLoggedIn: true, errorMessage: '', userCredential: userCredential);

      // TODO: 정보 기입 여부 체크 후 라우팅

    }
    on Exception catch(e) {
      state = state.copyWith(isLoggedIn: false, errorMessage: '로그인 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(), // TODO: 메세지 다양하게 처리
          ),
        ),
      );
    }
  }

  // 로그아웃 처리
  void logout() {
    state = state.copyWith(isLoggedIn: false);
  }
}