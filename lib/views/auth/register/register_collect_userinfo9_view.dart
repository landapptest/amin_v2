import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:chatting_1/views/home/home_main.dart';
import 'package:chatting_1/utils/route.dart';

class RegisterCollectUserInfoNinethScreen extends StatefulWidget {
  const RegisterCollectUserInfoNinethScreen({Key? key}) : super(key: key);

  @override
  _RegisterCollectUserInfoNinethScreenState createState() =>
      _RegisterCollectUserInfoNinethScreenState();
}

class _RegisterCollectUserInfoNinethScreenState
    extends State<RegisterCollectUserInfoNinethScreen> with TickerProviderStateMixin {
  late final AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  void goHome() {
    AppRoutes.pushAndRemoveUntil(
      context,
      const HomeMain(),
      predicate: (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "가입이 완료되었습니다",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              width: 200,
              child: Lottie.asset(
                'assets/check_lottie.json',
                controller: _lottieController,
                onLoaded: (composition) {
                  _lottieController.duration = composition.duration;
                  _lottieController.forward();
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "가입이 승인되면\n알림을 보내드리겠습니다",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 40),

            // "홈으로 이동" 버튼
            ElevatedButton(
              onPressed: goHome,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
              child: const Text(
                "홈으로 이동",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
