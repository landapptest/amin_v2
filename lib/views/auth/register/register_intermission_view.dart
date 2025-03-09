import 'package:chatting_1/utils/constants.dart';
import 'package:chatting_1/views/auth/register/register_collect_userinfo1_view.dart';
import 'package:flutter/material.dart';
import 'package:chatting_1/utils/route.dart';

class RegisterIntermissionScreen extends StatefulWidget {
  const RegisterIntermissionScreen({super.key});

  @override
  State<RegisterIntermissionScreen> createState() =>
      _RegisterIntermissionScreenState();
}

class _RegisterIntermissionScreenState extends State<RegisterIntermissionScreen> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    // 바로 실행되면 깜박임 생성 가능성 유
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _isExpanded = true;
      });
    });

    Future.delayed(Duration(seconds: 4), () {
      if (_isExpanded) {
        AppRoutes.pushReplacement(
          context,
          RegisterCollectUserInfoFirstScreen(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    double circleSize = screenSize.width * 0.88;
    double startCircleX = screenSize.width * -0.15;
    double startCircleY = screenSize.height * 0.45;

    double leftCircleX = screenSize.width * -0.25;
    double leftCircleY = screenSize.height * 0.4;

    double rightCircleX = screenSize.width * -0.1;
    double rightCircleY = screenSize.height * 0.51;

    return Scaffold(
      backgroundColor: Colors.white,
      body: IntermissionAnimationPage(
          circleSize,
          leftCircleX,
          startCircleX,
          leftCircleY,
          startCircleY,
          rightCircleX,
          rightCircleY
      ),
    );
  }

  Stack IntermissionAnimationPage(double circleSize, double leftCircleX, double startCircleX, double leftCircleY, double startCircleY, double rightCircleX, double rightCircleY) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        AnimatedOpacity(
          opacity: _isExpanded ? 1.0 : 0,
          duration: Duration(seconds: 2),
          curve: Curves.easeIn,
          child: Padding(
            padding: const EdgeInsets.only(top: 120, left: 60),
            child: Text(
              '당신에\n대하여\n알려주세요',
              style: TextStyle(
                fontSize: 50,
                height: 0.98,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          width: circleSize,
          height: circleSize,
          duration: Duration(seconds: 5),
          curve: Curves.easeOut,
          left: _isExpanded ?  leftCircleX: startCircleX,
          top: _isExpanded ? leftCircleY : startCircleY,
          child: Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ANIM_YELLOW_DARK,
            ),
          ),
        ),
        AnimatedPositioned(
          width: circleSize,
          height: circleSize,
          duration: Duration(seconds: 5),
          curve: Curves.easeInOut,
          left: _isExpanded ? rightCircleX : startCircleX,
          top: _isExpanded ? rightCircleY: startCircleY,
          child: Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ANIM_YELLOW_LIGHT,
            ),
          ),
        ),
      ],
    );
  }
}