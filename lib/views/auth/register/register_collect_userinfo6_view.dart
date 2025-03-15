import 'package:auto_size_text/auto_size_text.dart';
import 'package:chatting_1/providers/auth_provider.dart';
import 'package:chatting_1/utils/constants.dart';
import 'package:chatting_1/view_models/auth/register_collect_view_model.dart';
import 'package:chatting_1/views/auth/register/register_collect_userinfo7_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:chatting_1/utils/route.dart';

class RegisterCollectUserInfoSixthScreen extends ConsumerStatefulWidget {
  @override
  _RegisterCollectUserInfoSixthScreenState createState() => _RegisterCollectUserInfoSixthScreenState();
}

class _RegisterCollectUserInfoSixthScreenState extends ConsumerState<RegisterCollectUserInfoSixthScreen> {
  final TextEditingController introduceController = TextEditingController();
  final ScrollController introduceScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(registerCollectViewModelProvider.notifier);
    final state = ref.watch(registerCollectViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          profileAnimationStack(notifier, state, state.introduce),
          const Spacer(flex: 1),
          const Text(
            "당신에 대해 설명해주세요",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Scrollbar(
                controller: introduceScrollController,
                child: TextField(
                  scrollController: introduceScrollController,
                  maxLines: null,
                  expands: true,
                  maxLength: 100,
                  controller: introduceController,
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    hintText: "안녕하세요 !",
                    hintStyle: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade400,
                    ),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  onChanged: (introduce) {
                    notifier.updateIntroduce(introduce);
                  },
                ),
              ),
            ),
          ),
          const Spacer(flex: 1),
          GestureDetector(
            onTap: () {
              AppRoutes.push(
                context,
                const RegisterCollectUserInfoSeventhScreen(),
              );

            },
            child: Container(
              padding: const EdgeInsets.only(left: 80, right: 80, top: 15, bottom: 15),
              decoration: BoxDecoration(
                color: AMIN_YELLOW,
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
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Stack profileAnimationStack(RegisterCollectViewModel notifier, RegisterCollectState state, String introduce) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 100),
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
                        // 원본: child: state.currentUserProfileImage
                        // File 기반
                        child: Builder(
                          builder: (ctx) {
                            final file = state.currentUserProfileFile; // File?
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
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Spacer(flex: 4),
                            ClipOval(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(0xFF),
                                ),
                                child: Image.asset(
                                  notifier.gridLanguageImagePathArray[state.myLanguageIndex],
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const Spacer(flex: 1),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 40,
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
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const Spacer(flex: 5),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Text(
                            introduce,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
