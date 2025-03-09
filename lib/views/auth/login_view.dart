import 'package:chatting_1/providers/auth_provider.dart';
import 'package:chatting_1/utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatting_1/view_models/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends ConsumerWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, // 그림자 없애기
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // 아이콘 클릭 시 원하는 동작
            print("Menu icon pressed");
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: LoginPage(),
    );
  }

  Consumer LoginPage() {
    return Consumer(
      builder: (context, ref, child) {
        var canLogin = ref.watch(loginViewModelProvider).canLogin;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 38),
              child: Column(
                children: [
                  Icon(
                    Icons.ac_unit_sharp,
                    size: 100.0,
                  ),
                  SizedBox(height: 68),
                  Container(
                    height: 62,
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade400, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade400, width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade400, width: 2.0),
                        ),
                      ),
                      onChanged: (email) {
                        final viewModel = ref.read(loginViewModelProvider.notifier);
                        viewModel.setEmail(email);
                      },
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    height: 62,
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade400, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade400, width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade400, width: 2.0),
                        ),
                      ),
                      onChanged: (password) {
                        final viewModel = ref.read(loginViewModelProvider.notifier);
                        viewModel.setPassword(password);
                      },
                    ),
                  ),
                  SizedBox(height: 22),
                  Container(
                    width: double.infinity,
                    height: 62,
                    child: TextButton(
                      onPressed: canLogin ? () {
                        final viewModel = ref.read(loginViewModelProvider.notifier);
                        viewModel.loginWithEmailPassword(context);
                      } : null,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black, // 텍스트 색상
                        padding: EdgeInsets.zero, // 기본 패딩 제거
                        alignment: Alignment.center, // 중앙 정렬
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // 모서리 둥글게 설정
                        ),
                        backgroundColor: canLogin ? ANIM_YELLOW : Color(0xFFCCCCCC),
                      ),
                      child: Text(
                        "로그인",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 22),
                  Divider(
                    color: Colors.grey.shade700, // 구분선 색상
                    thickness: 0.8, // 구분선 두께
                    indent: 15, // 왼쪽 여백
                    endIndent: 15, // 오른쪽 여백
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                var loginModel = ref.read(loginViewModelProvider.notifier);
                loginModel.loginWithGoogle(context);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Image.asset(
                      "assets/icons/android_light_rd_ctn@3x.png",
                      width: 260,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 100),
          ],
        );
      },
    );
  }
}