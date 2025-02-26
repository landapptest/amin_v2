import 'package:chatting_1/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:chatting_1/utils/constants.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class ProfileView extends StatefulWidget {
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with TickerProviderStateMixin {
  late final AnimationController _lottieEyeController;
  late final AnimationController _lottieRefreshController;

  @override
  void initState() {
    _lottieEyeController = AnimationController(vsync: this);
    _lottieRefreshController = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _lottieEyeController.dispose();
    _lottieRefreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    double _scrollOffset = 0.0;

    return Scaffold(
      backgroundColor: ANIM_WHITE,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // // 배경 사진
              // true ? Placeholder() :
              // Image.asset(
              //   'assets/background_placeholder.png', // 배경 사진 경로
              //   fit: BoxFit.cover,
              //   height: 200.0,
              // ),
              // // 스크롤 가능한 내용
              ListView(
                controller: _scrollController,
                children: [
                  SizedBox(
                    height: 200,
                    child: Container(
                      color: ANIM_BLUE.withAlpha(0x50),
                      child: Align(
                        alignment: Alignment(0, 2.7),
                        child: ClipOval(
                          child: Container(
                            width: 130,
                            height: 130,
                            child: ANOMYMOUS_PROFILE,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 45.0), // 프로필 사진 위치 조정을 위한 공간
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text( // TODO: Autosized로 하기(이름 비정상적으로 길수도)
                          "Conan O'Brien",
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Text(
                        //   "서울시 광진구 화양동 (동네 표시하면)",
                        //   style: TextStyle(fontSize: 16.0),
                        // ),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "13",
                                  style: TextStyle(
                                    fontSize: 32,
                                    height: 0.9,
                                  ),
                                ),
                                Text(
                                  "팔로워",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 28),
                            Container(
                              width: 1,  // 선의 두께
                              height: 60,  // 선의 길이
                              color: Colors.black,  // 선의 색상
                            ),
                            SizedBox(width: 28),
                            Column(
                              children: [
                                Text(
                                  "12",
                                  style: TextStyle(
                                    fontSize: 32,
                                    height: 0.9,
                                  ),
                                ),
                                Text(
                                  "팔로잉",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 32),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: DropShadowTextButton(
                            text: "프로필 수정",
                            height: 62,
                          ),
                        ),
                        SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: DropShadowTextButton(
                            text: "학습언어 수정",
                            height: 62,
                          ),
                        ),
                        SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: DropShadowTextButton(
                            text: "앱 설정",
                            height: 62,
                          ),
                        ),
                        SizedBox(height: 50),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Row(
                              children: [
                                Flexible(
                                  child: LabelDropTextButton(
                                    text: "",
                                    labelText: "위치 설정",
                                    height: 62,
                                  ),
                                ),
                                SizedBox(width: 5),
                                DropShadowBasicButton(
                                  child: ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                      Colors.white.withAlpha(0x80), // 흰색이 섞이도록 투명도 조정
                                      BlendMode.modulate, // 색상을 조정하는 BlendMode
                                    ),
                                    child: Lottie.asset(
                                      'assets/eye_lottie.json',
                                      controller: _lottieEyeController,
                                      onLoaded: (composition) {
                                        _lottieEyeController.duration = composition.duration;

                                        // 설정에 따라 0.5 or 0.0
                                        _lottieEyeController.value = 0.5;
                                        //
                                      },
                                    ),
                                  ),
                                  onTap: () {
                                    // 임시
                                    if(_lottieEyeController.value == 0.5) {
                                      _lottieEyeController.animateTo(1.0);
                                    }
                                    else {
                                      _lottieEyeController.animateTo(0.5);
                                    }
                                  },
                                  width: 62,
                                  height: 62,
                                ),
                                SizedBox(width: 3),

                                DropShadowBasicButton(
                                  child: Lottie.asset(
                                    'assets/refresh_lottie.json',
                                    controller: _lottieRefreshController,
                                    onLoaded: (composition) {
                                      _lottieRefreshController.duration = composition.duration;
                                    },
                                  ),
                                  onTap: () {
                                    if (!_lottieRefreshController.isAnimating) {
                                      _lottieRefreshController.forward(from: 0.0);
                                    }
                                  },
                                  width: 62,
                                  height: 62,
                                ),
                              ],
                            )
                        ),
                        SizedBox(height: 30),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: ANIM_BLUE.withAlpha(0x80))
                              ),
                            )
                        ),
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: DropShadowTextButton(
                            text: "로그아웃",
                            height: 62,
                            innerColor: Color(0xFFE66F6F),
                            borderColor: Color(0xFFD34242),
                            shadowColor: Color(0xFFD34242),
                            fontColor: Color(0xFFCFCFCF),
                          ),
                        ),
                        // SizedBox(height: 500.0), // 스크롤 테스트를 위한 임시 공간
                      ],
                    ),
                  ),
                ],
              ),
              // 프로필 사진
              // Positioned(
              //   top: 150.0 - _scrollOffset, // 스크롤에 따라 위치 조정
              //   left: constraints.maxWidth / 2 - 50.0, // 화면 너비에 비례하여 위치 계산
              //   child: CircleAvatar(
              //     backgroundImage: AssetImage('assets/profile.jpg'), // 프로필 사진 경로
              //     radius: 50.0,
              //   ),
              // ),
            ],
          );
        },
      ),
    );
  }
}