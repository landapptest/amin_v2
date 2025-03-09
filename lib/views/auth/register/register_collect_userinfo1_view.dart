import 'package:chatting_1/providers/auth_provider.dart';
import 'package:chatting_1/utils/constants.dart';
import 'package:chatting_1/views/auth/register/register_collect_userinfo2_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:chatting_1/utils/route.dart';

// it is stateful because of FocusNode
class RegisterCollectUserInfoFirstScreen extends ConsumerStatefulWidget {
  @override
  _RegisterCollectUserInfoFirstScreenState createState() => _RegisterCollectUserInfoFirstScreenState();
}

class _RegisterCollectUserInfoFirstScreenState extends ConsumerState<RegisterCollectUserInfoFirstScreen> {
  final TextEditingController nameController = TextEditingController();
  final FocusNode namefocusNode = FocusNode();

  void addNameFocusListener() {
    namefocusNode.addListener(() {
      final hasFocus = namefocusNode.hasFocus;
      final notifier = ref.watch(registerCollectViewModelProvider.notifier);
      final state = ref.watch(registerCollectViewModelProvider.notifier).state;
      if(state.registerState == 0 && hasFocus) {
        notifier.updateRegisterState(1);
      }
      else if(state.registerState == 1 && state.name != "" && !hasFocus) {
        notifier.updateRegisterState(2);
        // dispose it manually if possible
      }
    });
  }

  @override
  void initState() {
    super.initState();
    addNameFocusListener();
  }

  @override
  void dispose() {
    namefocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(registerCollectViewModelProvider.notifier);
    final state = ref.watch(registerCollectViewModelProvider);
    return Scaffold(
      // appBar: AppBar(title: Text('사용자 정보 입력')),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(flex: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(flex: 1),
                Flexible(
                  flex: 3,
                  child: Text(
                    "이름",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Spacer(flex: 1),
                Flexible(
                  flex: 14,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        // 둥근 모서리 설정
                        border: Border.all(
                          width: 3,
                          color: ANIM_YELLOW, // TODO: focus됐을때만 파란색
                        )
                    ),
                    child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        // TODO: add focus out on outer-click
                        child: TextField(
                          controller: nameController,
                          focusNode: namefocusNode,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.transparent,
                            hintText: "홍길동",
                            hintStyle: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade400,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          onChanged: (name) {
                            notifier.updateName(name);
                          },
                        )
                    ),
                  ),
                ),
                Spacer(flex: 1),
              ],
            ),
            Spacer(flex: 3),
            Visibility(
              visible: state.registerState >= 2 ? true: false,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(flex: 1),
                  Text(
                      '성별',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                  Spacer(flex: 1),
                  Row(
                    children: notifier.genderStringArray.map((
                        gender) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4),
                        child: ChoiceChip(
                          label: Text(
                              gender,
                              style: TextStyle(
                                fontSize: 22,
                                color: state.gender == gender
                                    ? Colors.white
                                    : Colors.black,
                              )
                          ),
                          selected: false,
                          onSelected: (isSelected) {
                            notifier.updateGender(gender);
                            notifier.updateRegisterState(3);
                          },
                          backgroundColor: state.gender == gender
                              ? ANIM_YELLOW
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: state.gender == gender
                                  ? ANIM_YELLOW
                                  : Colors.grey,
                              width: 2,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Spacer(flex: 1),
                ],
              ),
            ),

            Spacer(flex: 1),
            Visibility(
              visible: state.registerState >= 3 ? true: false,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: Row(
                children: [
                  Spacer(flex: 1),
                  Text('연령대',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                  Spacer(flex: 1),
                  Container(
                    width: 260,
                    height: 180,
                    alignment: Alignment.center,
                    child: Wrap(
                      spacing: 5,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,

                      children: notifier.ageStringArray.map((
                          ageGroup) {
                        return ChoiceChip(
                          label: Text(
                            ageGroup,
                            style: TextStyle(
                              fontSize: 22,
                              color: state.ageGroup == ageGroup
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          selected: false,
                          onSelected: (isSelected) {
                            if (isSelected) {
                              notifier.updateAgeGroup(ageGroup);
                              notifier.updateRegisterState(4);
                            }
                          },
                          backgroundColor: state.ageGroup ==
                              ageGroup ? ANIM_YELLOW : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: state.ageGroup == ageGroup
                                  ? ANIM_YELLOW
                                  : Colors.grey,
                              width: 2,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Spacer(flex: 1),
                ],
              ),
            ),

            // Spacer(flex: 1),
            Visibility(
              visible: state.registerState >= 4 ? true: false,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: Column(
                children: [
                  Divider(indent: 20.0, endIndent: 20.0),
                  Text(
                    '사용목적',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: notifier.purposeStringArray.map((
                        purpose) {
                      return Row(
                        children: [
                          Flexible(flex: 1, child: Container()),
                          Expanded(
                            flex: 12,
                            child: ChoiceChip(
                              label: Container(
                                width: double.infinity,
                                child: Text(
                                  textAlign: TextAlign.center,
                                  purpose,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: state.purpose ==
                                        purpose
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              selected: false,
                              // 선택된 상태로 설정
                              onSelected: (isSelected) {
                                if (isSelected) {
                                  notifier.updatePurpose(purpose);
                                  notifier.updateRegisterState(5);
                                  // navigator
                                  AppRoutes.push(
                                    context,
                                    RegisterCollectUserInfoSecondScreen(),
                                  );

                                }
                              },
                              backgroundColor: state.purpose ==
                                  purpose
                                  ? ANIM_YELLOW
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    12),
                                side: BorderSide(
                                  color: state.purpose == purpose
                                      ? ANIM_YELLOW
                                      : Colors.grey,
                                  width: 3,
                                ),
                              ),
                            ),
                          ),
                          Flexible(flex: 1, child: Container()),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            Spacer(flex: 3),
            Container(
              alignment: Alignment.center,
              child: AnimatedSmoothIndicator(
                activeIndex: 0,
                count: 3,
                effect: SlideEffect(
                    dotHeight: 14,
                    dotWidth: 14,
                    // dotColor: Color(0xffB9D4DC),
                    activeDotColor: Color(0xFF343434)
                ),
              ),
            ),
            SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}