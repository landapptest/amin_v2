import 'package:chatting_1/utils/constants.dart';
import 'package:chatting_1/views/auth/login_view.dart';
import 'package:chatting_1/views/auth/register_view.dart';
import 'package:chatting_1/view_models/auth/login_view_model.dart';
import 'package:chatting_1/view_models/auth/register_collect_view_model.dart';
import 'package:chatting_1/view_models/auth/register_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginOrRegisterScreen extends StatelessWidget {
  LoginOrRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: LoginOrRegister(context),
    );
  }

  LoginOrRegister(context) {
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
              SizedBox(height: 200),
              Container(
                width: double.infinity,
                height: 62,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    // 텍스트 색상
                    padding: EdgeInsets.zero,
                    // 기본 패딩 제거
                    alignment: Alignment.center,
                    // 중앙 정렬
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20), // 모서리 둥글게 설정
                    ),
                    backgroundColor: AMIN_YELLOW,
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
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 62,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.zero,
                    alignment: Alignment.center,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: AMIN_YELLOW,
                  ),
                  child: Text(
                    "회원가입",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
