import 'package:chatting_1/providers/setting_provider.dart';
import 'package:chatting_1/widgets/buttons.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatting_1/utils/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProfileView extends ConsumerStatefulWidget {
  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> with TickerProviderStateMixin {
  final TextEditingController _introduceController = TextEditingController();
  final ScrollController _introduceScrollController = ScrollController();
  final PageController _backgroundImageController = PageController();

  // NOTE: 아래 변수들(without final)들은 사실상 debug용
  String? selectedAge;
  String? selectedGoal;
  String? selectedCurrentLanguage;
  String? selectedTargetLanguage;
  String? selectedSecondaryTargetLanguage;
  String? selectedLanguageStatus;
  String? selectedSecondaryLanguageStatus;
  String? selectedAppLanguageStatus;
  bool isGettingNotification= true;
  final List<String> ageRanges = ["10대", "20대", "30대", "40대", "50대", "60대 이상"];
  final List<String> goalRanges = [
    "아주 정말 길고 긴 목표 중 하나",
    "적당한 목표",
    "조금 길긴한 목표",
    "네번째 목표",
    "새로운 목표중 하나"
  ];
  final List<String> languageRanges = [
    "한국어",
    "영어",
    "프랑스어",
    "일본어",
    "중국어",
  ];
  final List<String> languageRangesWithNull = [
    "선택 안함",
    "한국어",
    "영어",
    "프랑스어",
    "일본어",
    "중국어",
  ];
  final List<String> languageStatusRanges = [
    "어느정도해요",
    "잘해요",
    "기타등등"
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showProfileSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AMIN_GREY_LIGHT,
      context: context,
      isScrollControlled: true, // 전체 화면에 가까운 높이
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "프로필 설정",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
            _buildProfileInfo(),
          ],
        ),
      ),
    );
  }

  void _showLanguageSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AMIN_GREY_LIGHT,
      context: context,
      isScrollControlled: true, // 전체 화면에 가까운 높이
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "학습언어 설정",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                  _buildLanguageInfo(setState), // 상태를 setState로 관리
                ],
              ),
            );
          },
        );
      },
    );
  }


  void _showAppSettingSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AMIN_GREY_LIGHT,
      context: context,
      isScrollControlled: true, // 전체 화면에 가까운 높이
      builder: (context) => StatefulBuilder(
          builder: (context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "앱 설정",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                  _buildAppSettingInfo(setModalState),
                ],
              ),
            );
          }
      ),
    );
  }


  Widget _buildProfileInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: [
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 8),
              //   margin: EdgeInsets.symmetric(horizontal: 20.0),
              //   decoration: BoxDecoration(
              //     color: ANIM_WHITE,
              //     border: Border.all(color: Colors.transparent),
              //     borderRadius: BorderRadius.all(
              //       Radius.circular(12),
              //     ),
              //   ),
              //   child: TextFormField(
              //     decoration: InputDecoration(
              //         labelText: "이름",
              //         border: InputBorder.none
              //     ),
              //   ),
              // ),
              SizedBox(height: 40),
              DropDownButton(
                ranges: ageRanges,
                selectValue: selectedAge,
                hintText: "나이",
                labelText: "나이대",
                onChanged: (value) {
                  selectedAge = value;
                },
              ),
              SizedBox(height: 40),
              DropDownButton(
                ranges: goalRanges,
                selectValue: selectedGoal,
                hintText: "나의 목표",
                labelText: "학습목표",
                onChanged: (value) {
                  selectedGoal = value;
                },
              ),
              SizedBox(height: 40),
              MultiLineTextField(
                textController: _introduceController,
                scrollController: _introduceScrollController,
                hintText: "안녕하세요!",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageInfo(StateSetter setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: [
              SizedBox(height: 40),
              DropDownButton(
                ranges: languageRanges,
                selectValue: selectedCurrentLanguage,
                hintText: "",
                labelText: "모국어",
                onChanged: (value) {
                  selectedCurrentLanguage = value;
                },
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Divider(thickness: 1, height: 1, color: AMIN_GREY),
              ),
              SizedBox(height: 30),
              DropDownButton(
                ranges: languageRanges,
                selectValue: selectedTargetLanguage,
                hintText: "",
                labelText: "주언어",
                onChanged: (value) {
                  selectedTargetLanguage = value;
                },
              ),
              SizedBox(height: 20),
              DropDownButton(
                ranges: languageStatusRanges,
                selectValue: selectedLanguageStatus,
                hintText: "",
                labelText: "현재수준",
                onChanged: (value) {
                  selectedLanguageStatus = value;
                },
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Divider(thickness: 1, height: 1, color: AMIN_GREY),
              ),
              SizedBox(height: 30),
              DropDownButton(
                ranges: languageRangesWithNull,
                selectValue: selectedSecondaryTargetLanguage,
                hintText: "",
                labelText: "보조언어",
                onChanged: (value) {
                  setState(() {
                    selectedSecondaryTargetLanguage = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Visibility(
                visible: !(selectedSecondaryTargetLanguage == null || selectedSecondaryTargetLanguage == languageRangesWithNull[0]),
                child: DropDownButton(
                  ranges: languageStatusRanges,
                  selectValue: selectedSecondaryLanguageStatus,
                  hintText: "",
                  labelText: "현재수준",
                  onChanged: (value) {
                    selectedSecondaryLanguageStatus = value;
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppSettingInfo(StateSetter setModalState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: [
              SizedBox(height: 40),
              DropDownButton(
                ranges: languageRanges,
                selectValue: selectedAppLanguageStatus,
                hintText: "",
                labelText: "표시언어",
                onChanged: (value) {
                  selectedAppLanguageStatus = value;
                },
              ),
              SizedBox(height: 40),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 28),
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AMIN_WHITE,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "알림 허용",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: AMIN_GREY,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width:40),
                    Container(
                      width: 1,  // 선의 두께
                      height: 30,  // 선의 길이
                      color: AMIN_GREY,  // 선의 색상
                    ),
                    SizedBox(width:40),
                    CupertinoSwitch(
                      value: isGettingNotification,
                      activeTrackColor: AMIN_BLUE,
                      onChanged: (bool value) {
                        setModalState(() {
                          isGettingNotification = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double profileImageDiameter = 130.0;
    final settingState = ref.watch(settingProvider);
    final settingNotifier = ref.read(settingProvider.notifier);

    return Scaffold(
        backgroundColor: AMIN_WHITE,
        body: Column(
          children: [
            Container(
              height: 240,
              margin: EdgeInsets.only(bottom: profileImageDiameter/2),
              child: Stack(
                children: [
                  PageView(
                    // TODO: 동적으로 구해서 처리
                    scrollDirection: Axis.horizontal,
                    controller: _backgroundImageController,
                    children: List.generate(3, (index) {
                      return GestureDetector(
                        onTap: () {
                          settingNotifier.setBackgroundImage(context, index);
                        },
                        child: settingState.backgroundImagesPaths?[index] ?? Placeholder(),
                      );
                    }),
                  ),
                  Align(
                    alignment: Alignment(0, 2.1),
                    child: GestureDetector(
                      onTap: () {
                        print("clicked");
                        settingNotifier.setMainProfileImage(context);
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: profileImageDiameter,
                            height: profileImageDiameter,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AMIN_WHITE,
                                width: 1.0,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: (settingState.profilePath as Image?)?.image ?? (ANOMYMOUS_PROFILE as Image).image,
                            ),
                          ),
                          Positioned(
                            bottom: 7, // 우하단에서 아이콘의 위치 조정
                            right: 7,  // 우측에서 아이콘의 위치 조정
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: AMIN_GREY_LIGHT,
                              ),
                              child: Icon(
                                Icons.image_search,
                                color: AMIN_BLACK,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    width: double.infinity,
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment:  MainAxisAlignment.end,
                      children: [
                        SmoothPageIndicator(
                            controller: _backgroundImageController,
                            count: 3, // TODO: 개수 가져와서 변수로 처리
                            effect: const ScrollingDotsEffect(
                              activeDotColor: AMIN_BLUE,
                              activeStrokeWidth: 10,
                              activeDotScale: 1.7,
                              maxVisibleDots: 5,
                              radius: 10,
                              spacing: 8,
                              dotHeight: 7,
                              dotWidth: 7,
                            )
                        ),
                        SizedBox(width: 10),
                        // Container(
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(6),
                        //     color: ANIM_GREY_LIGHT,
                        //   ),
                        //   child: Icon(
                        //     Icons.image_search,
                        //     color: ANIM_BLACK,
                        //     size: 24,
                        //   ),
                        // ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     CircleAvatar(
            //       radius: 18,
            //       backgroundImage: (settingNotifier.getUserMyFlagImage())?.image ?? (Placeholder as Image).image,
            //     ),
            //     SizedBox(width: 140),
            //     CircleAvatar(
            //       radius: 18,
            //       backgroundImage: (settingNotifier.getUserTargetFlagImage())?.image ?? (Placeholder as Image).image,
            //     ),
            //   ],
            // ),
            // TODO: spacer 이용해서 바꾸기
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Column(
                children: [
                  Text( // TODO: Autosized로 하기(이름 비정상적으로 길수도)
                    "Conan O'Brien",
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 3),
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
                      onTap: () => _showProfileSheet(context),
                      text: "프로필 수정",
                      height: 62,
                    ),
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: DropShadowTextButton(
                      onTap: () => _showLanguageSheet(context),
                      text: "학습언어 수정",
                      height: 62,
                    ),
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: DropShadowTextButton(
                      onTap: () => _showAppSettingSheet(context),
                      text: "앱 설정",
                      height: 62,
                    ),
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
                      fontColor: Color(0xFFE3E3E3),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }
}