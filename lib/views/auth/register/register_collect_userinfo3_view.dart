import 'package:chatting_1/providers/auth_provider.dart';
import 'package:chatting_1/views/auth/register/register_collect_userinfo4_view.dart';
import 'package:chatting_1/utils/page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:chatting_1/utils/route.dart';

// attribution required for national flag images
// https://www.freepik.com/free-vector/waving-flag-icon-collection_1152871.htm#fromView=keyword&page=1&position=1&uuid=da267124-61b0-4b4f-a37b-cc1a6e3d7842&new_detail=true
class RegisterCollectUserInfoThreeScreen extends ConsumerWidget {
  const RegisterCollectUserInfoThreeScreen({super.key});

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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(flex: 2),
                    Flexible(
                      flex: 8,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "배울려는 언어", // 특정 부분
                              style: TextStyle(
                                color: Color(0xFFCB9C5A), // 원하는 색상
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "를 골라주세요.", // 나머지 텍스트
                              style: TextStyle(
                                color: Colors.black, // 기본 색상
                              ),
                            ),
                          ],
                        ),
                        style: TextStyle(
                          fontSize: 24, // 기본 글자 크기
                          fontWeight: FontWeight.bold, // 기본 굵기
                        ),
                      ),
                    ),
                    SizedBox(height: 13),
                    GridView.builder(
                      shrinkWrap: true,
                      itemCount: notifier.gridLanguageTextArray.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
                        childAspectRatio: 10 / 7, //item 의 가로 1, 세로 1 의 비율
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 25,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            notifier.updateTargetLanguage(index);
                            notifier.updateRegisterState(7);
                            AppRoutes.push(
                              context,
                              const RegisterCollectUserInfoFourthScreen(),
                            );

                          },
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: state.targetLanguageIndex == index ? 3 : 0,
                                  color: state.targetLanguageIndex == index ? Color(0xFFCB9C5A) : Colors.white.withAlpha(0x00), // colors is shown even width is 0
                                ),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.18), // 그림자 색 (여기선 투명도를 주어 부드럽게 처리)
                                    offset: Offset(0, 4), // 그림자의 위치 (x, y 방향)
                                    blurRadius: 3, // 그림자의 흐림 정도
                                    spreadRadius: 2, // 그림자의 퍼짐 정도
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SizedBox(height: 3),
                                  ClipOval(
                                    child: Image.asset(
                                      notifier.gridLanguageImagePathArray[index],
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    notifier.gridLanguageTextArray[index],
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              )
                          ),
                        );
                      },
                    ),
                    Spacer(flex: 2),
                  ],
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: AnimatedSmoothIndicator(
              activeIndex: 1,
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