import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:chatting_1/providers/auth_provider.dart';
import 'package:chatting_1/utils/constants.dart';
import 'package:chatting_1/views/auth/register/register_collect_userinfo6_view.dart';
import 'package:chatting_1/widgets/widget_effect.dart';
import 'package:chatting_1/view_models/auth/register_collect_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chatting_1/utils/route.dart';

class RegisterCollectUserInfoFifthScreen extends ConsumerStatefulWidget {
  const RegisterCollectUserInfoFifthScreen({super.key});

  @override
  _RegisterCollectUserInfoFifthScreenState createState() => _RegisterCollectUserInfoFifthScreenState();
}

class _RegisterCollectUserInfoFifthScreenState extends ConsumerState<RegisterCollectUserInfoFifthScreen> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final notifier = ref.read(registerCollectViewModelProvider.notifier);
    Future.delayed(const Duration(milliseconds: 1000), () {
      notifier.updateRegisterState(9);
      debugPrint("@@@@@@@@@@@@@@@@@@@@@@@@ 1");
      Future.delayed(const Duration(milliseconds: 1000), () {
        notifier.updateRegisterState(10);
        debugPrint("@@@@@@@@@@@@@@@@@@@@@@@@ 2");
        Future.delayed(const Duration(milliseconds: 1000), () {
          notifier.updateRegisterState(11);
          debugPrint("@@@@@@@@@@@@@@@@@@@@@@@@ 3");
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(registerCollectViewModelProvider.notifier);
    final state = ref.watch(registerCollectViewModelProvider);
    debugPrint("@@@ test: ${state.registerState}");
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          profileAnimationStack(notifier, state),
          Center(
            child: Column(
              children: [
                const SizedBox(height: 300), // TODO: make this relative
                Visibility(
                  maintainState: true,
                  visible: state.registerState >= 10,
                  child: FadeSlideWidget(
                    child: Column(
                      children: const [
                        Text(
                          '프로필 사진을 등록해주세요',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(flex: 1),
                Flexible(
                  flex: 20,
                  child: Visibility(
                    maintainState: true,
                    visible: state.registerState >= 11,
                    child: FadeSlideWidget(
                      child: Column(
                        children: [
                          // 메인 프로필( index=0 )
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  notifier.setMainProfileImage(context);
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      height: 160,
                                      width: 160,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFD9D9D9),
                                        border: Border.all(
                                          width: 2,
                                          color: Colors.white,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.18),
                                            offset: const Offset(0, 4),
                                            blurRadius: 3,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Builder(
                                        builder: (ctx) {
                                          final file = state.profileFileArray[0];
                                          if (file != null) {
                                            return Image.file(file, fit: BoxFit.cover);
                                          }
                                          return const SizedBox();
                                        },
                                      ),
                                    ),
                                    Container(
                                      height: 155,
                                      width: 155,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 2,
                                          color: const Color(0xFFCCCCCC),
                                        ),
                                      ),
                                      child: Builder(
                                        builder: (ctx) {
                                          final file = state.profileFileArray[0];
                                          if (file != null) {
                                            return ClipOval(
                                              child: Image.file(file, fit: BoxFit.cover),
                                            );
                                          } else {
                                            return Icon(Icons.add, size: 70.0, color: Colors.grey.shade400);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Spacer(flex: 1),

                          // 추가 프로필(1,2,3)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(flex: 2),
                              for (int i = 1; i <= 3; i++)
                                ...[
                                  GestureDetector(
                                    onTap: () {
                                      notifier.pickImage(i);
                                    },
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFD9D9D9),
                                        border: Border.all(
                                          width: 2,
                                          color: Colors.white,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.18),
                                            offset: const Offset(0, 4),
                                            blurRadius: 3,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Builder(
                                        builder: (ctx) {
                                          final file = state.profileFileArray[i];
                                          if (file != null) {
                                            return Image.file(file, fit: BoxFit.cover);
                                          } else {
                                            return const Icon(Icons.add, size: 70.0, color: Colors.white);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  if (i < 3) const Spacer(flex: 1),
                                ],
                              const Spacer(flex: 2),
                            ],
                          ),
                          const Spacer(flex: 3),

                          Visibility(
                            maintainState: true,
                            visible: state.registerState >= 11,
                            child: FadeSlideWidget(
                              child: GestureDetector(
                                onTap: () {
                                  AppRoutes.push(
                                    context,
                                    RegisterCollectUserInfoSixthScreen(),
                                  );

                                },
                                child: Container(
                                  padding: const EdgeInsets.only(left: 80, right: 80, top: 15, bottom: 15),
                                  decoration: BoxDecoration(
                                    color: (state.profileFileArray[0] != null) ? ANIM_YELLOW : const Color(0xFFCCCCCC),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    "사진 선택 완료",
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Spacer(flex: 4),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Stack profileAnimationStack(RegisterCollectViewModel notifier, RegisterCollectState state) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 100, bottom: 100),
          child: AnimatedAlign(
            alignment: state.registerState == 8 ? Alignment.center : Alignment.topCenter,
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(10000),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 14, top: 14, bottom: 14),
                      child: ClipOval(
                        child: Container(
                          width: 120,
                          height: 120,
                          child: Builder(
                            builder: (ctx) {
                              final file = state.currentUserProfileFile;
                              if (file != null) {
                                return Image.file(file, fit: BoxFit.cover);
                              } else {
                                return Container(color: Colors.grey.shade300);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(flex: 3),
                              Expanded(
                                flex: 30,
                                child: AutoSizeText(
                                  state.name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  minFontSize: 8,
                                  maxFontSize: 26,
                                ),
                              ),
                              const Spacer(flex: 5),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              const Spacer(flex: 3),
                              ClipOval(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(0xFF),
                                  ),
                                  child: Image.asset(
                                    notifier.gridLanguageImagePathArray[state.myLanguageIndex],
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const Spacer(flex: 1),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 48,
                                color: Colors.white,
                                shadows: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.18),
                                    offset: const Offset(0, 4),
                                    blurRadius: 2,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              const Spacer(flex: 1),
                              ClipOval(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Image.asset(
                                    notifier.gridLanguageImagePathArray[state.targetLanguageIndex],
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const Spacer(flex: 5),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
