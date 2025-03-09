import 'package:chatting_1/providers/auth_provider.dart';
import 'package:chatting_1/utils/constants.dart';
import 'package:chatting_1/views/auth/register/register_collect_userinfo5_view.dart';
import 'package:chatting_1/utils/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class RegisterCollectUserInfoFourthScreen extends ConsumerWidget {
  const RegisterCollectUserInfoFourthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registerCollectViewModelProvider);
    final notifier = ref.watch(registerCollectViewModelProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                children: [
                  Spacer(flex: 3),
                  Text.rich(
                    TextSpan(
                        children: [
                          TextSpan(
                            text: "현재 당신의 ",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: "${notifier.gridLanguageTextArray[state.targetLanguageIndex]}",
                            style: TextStyle(
                              color: Color(0xFFCB9C5A),
                            ),
                          ),
                          TextSpan(
                            text: " 실력은 ?",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                  ),
                  Spacer(flex: 1),
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: notifier.gridLanguageLevelTextArray.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, //1 개의 행에 보여줄 item 개수
                      childAspectRatio: 30 / 7, //item 의 가로 1, 세로 1 의 비율
                      mainAxisSpacing: 18,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          notifier.updateLanguageLevel(index);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(flex: 2),
                            Expanded(
                              flex: 15,
                              child: Container(
                                  height: 76,
                                  decoration: BoxDecoration(
                                    color: state.languageLevelIndex == index ? ANIM_YELLOW : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      width: 3,
                                      color: ANIM_YELLOW_LIGHT,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2), // 그림자 색 (여기선 투명도를 주어 부드럽게 처리)
                                        offset: Offset(0, 4), // 그림자의 위치 (x, y 방향)
                                        blurRadius: 3, // 그림자의 흐림 정도
                                        spreadRadius: 2, // 그림자의 퍼짐 정도
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        notifier.gridLanguageLevelTextArray[index],
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: state.languageLevelIndex == index ? Colors.white : Colors.black,
                                        ),
                                      )
                                    ],
                                  )
                              ),
                            ),
                            Spacer(flex: 2),
                          ],
                        ),
                      );
                    },
                  ),

                  Spacer(flex: 1),
                  Row(
                    children: [
                      Spacer(flex: 2),
                      Expanded(
                        flex: 15,
                        child: Container(
                          width: double.infinity,
                          height: 62,
                          child: TextButton(
                            onPressed: notifier.isLanguageSetted() ? () {
                              AppRoutes.push(
                                context,
                                RegisterCollectUserInfoFifthScreen(),
                              );

                              notifier.updateRegisterState(8);
                            } : null,
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.zero,
                              alignment: Alignment.center,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: notifier.isLanguageSetted() ? ANIM_YELLOW : Color(0xFFCCCCCC),
                            ),
                            child: Text(
                              "선택 완료",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Spacer(flex: 2),
                    ],
                  ),

                  Spacer(flex: 4),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: AnimatedSmoothIndicator(
              activeIndex: 2,
              count: 3,
              effect: SlideEffect(
                  dotHeight: 14,
                  dotWidth: 14,
                  // dotColor: Color(0xffB9D4DC),
                  activeDotColor: Color(0xFF343434)
              ),
            ),
          ),
          SizedBox(height: 26),
        ],
      ),
    );
  }
}