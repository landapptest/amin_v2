import 'package:chatting_1/models/auth_model.dart';
import 'package:chatting_1/views/auth/register/register_intermission_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';

//회원가입 시 이메일, 비밀번호 입력받아 등록하는 로직
class RegisterState {
  final bool isLoggedIn;
  final bool canRegister;
  final String errorMessage;
  final String email;
  final String password;
  final String confirmPassword;
  final UserCredential? userCredential;

  RegisterState({
    this.isLoggedIn = false,
    this.canRegister = true,
    this.errorMessage = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.userCredential,
  });

  RegisterState copyWith({
    bool? isLoggedIn,
    bool? canRegister,
    String? errorMessage,
    String? email,
    String? password,
    String? confirmPassword,
    UserCredential? userCredential,
  }) {
    return RegisterState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      canRegister: canRegister ?? this.canRegister,
      errorMessage: errorMessage ?? this.errorMessage,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      userCredential: userCredential ?? this.userCredential,
    );
  }
}

class RegisterViewModel extends StateNotifier<RegisterState> {
  final AuthModel _userController;
  RegisterViewModel(this._userController) : super(RegisterState());

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  void setConfirmPassword(String confirmPassword) {
    state = state.copyWith(confirmPassword: confirmPassword);
  }

  Future<void> signUpWithEmail(BuildContext context) async {
    state = state.copyWith(errorMessage: '');
    if (state.canRegister) {
      if (state.password == state.confirmPassword) {
        try {
          final userCredential = await _userController.signUpWithEmailandPassword(state.email, state.password);
          state = state.copyWith(userCredential: userCredential);

          final uid = userCredential.user?.uid;
          if (uid != null) {
            final dbRef = FirebaseDatabase.instance.ref('users/$uid');
            await dbRef.update({
              "isCollected": false,
            });
          }

          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const RegisterIntermissionScreen(),
              transitionDuration: const Duration(seconds: 1),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                var fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                );
                return FadeTransition(opacity: fadeAnimation, child: child);
              },
            ),
          );

        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("회원가입 에러: $e")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("비밀번호가 일치하지 않습니다!"),
            backgroundColor: Colors.grey,
          ),
        );
      }
    }
  }
}
