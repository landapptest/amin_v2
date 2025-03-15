import 'dart:io';
import 'package:chatting_1/providers/auth_provider.dart';
import 'package:chatting_1/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chatting_1/utils/route.dart';

// 8번 화면으로 이동하기 위해 import
import 'register_collect_userinfo8_view.dart';

class RegisterCollectUserInfoSeventhScreen extends ConsumerStatefulWidget {
  const RegisterCollectUserInfoSeventhScreen({Key? key}) : super(key: key);

  @override
  _RegisterCollectUserInfoSeventhScreenState createState() =>
      _RegisterCollectUserInfoSeventhScreenState();
}

class _RegisterCollectUserInfoSeventhScreenState
    extends ConsumerState<RegisterCollectUserInfoSeventhScreen> {
  bool isIdentificationTaken = false; // 학생증 사진 촬영 여부

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(registerCollectViewModelProvider.notifier);
    final state = ref.watch(registerCollectViewModelProvider);

    // 학생증 File?
    final studentCardFile = state.userIdentificationFile;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 6),
          SizedBox(
            width: double.infinity,
            child: Text(
              "학생증을 인증해주세요",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                """
※ 주의사항
- 학생증 혹은 카드를 스캔하여 첨부하여 주세요
- 대학교, 이름, 학번, 학과 이외의 정보는 가리셔도 무방합니다
- 유효하지 않은 사진을 첨부할 시 가입이 거부될 수 있습니다
""",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // 아직 사진을 안 찍었으면 카메라 미리보기 대신 "촬영 전" 영역 표시
          // 찍었으면(studentCardFile != null) -> 미리보기
          !isIdentificationTaken
              ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 여긴 원래 camera preview였지만, 최소 변경으로 "빈 영역"만 남겨둠
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.32,
                  color: Colors.black12,
                ),
                // 사각형 오버레이 (원래 카메라 미리보기 위에 얹었던 것)
                Positioned.fill(
                  child: OverlayWithRectangleClipping(),
                ),
              ],
            ),
          )
              : (studentCardFile != null)
              ? Image.file(
            studentCardFile,
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.32,
            fit: BoxFit.cover,
          )
              : const Center(child: CircularProgressIndicator()),

          const Spacer(flex: 2),

          // "촬영하기" or "다시 촬영하기"
          !isIdentificationTaken
              ? GestureDetector(
            onTap: () async {
              // camera plugin 대신 ImagePicker(source: camera)
              final picker = ImagePicker();
              final pickedFile = await picker.pickImage(
                source: ImageSource.camera,
              );
              if (pickedFile == null) {
                return;
              }
              final file = File(pickedFile.path);
              // registerCollectViewModel의 userIdentificationFile 업데이트
              notifier.state = notifier.state.copyWith(
                userIdentificationFile: file,
              );
              setState(() {
                isIdentificationTaken = true;
              });
            },
            child: Container(
              width: 306,
              height: 63,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AMIN_YELLOW,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "촬영하기",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
              : GestureDetector(
            onTap: () async {
              final picker = ImagePicker();
              final pickedFile = await picker.pickImage(
                source: ImageSource.camera,
              );
              if (pickedFile == null) {
                return;
              }
              final file = File(pickedFile.path);
              notifier.state = notifier.state.copyWith(
                userIdentificationFile: file,
              );
            },
            child: Container(
              width: 306,
              height: 63,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AMIN_YELLOW,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "다시 촬영하기",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Spacer(flex: 1),

          // 기존에는 "제출하기" 버튼에서 submitFinalData 호출
          // -> 이제는 "다음으로" 버튼만 두고, 8번 화면에서 최종 저장
          GestureDetector(
            onTap: () {
              // 학생증 촬영이 되었든 안 되었든 8번 화면으로 이동
              AppRoutes.push(
                context,
                const RegisterCollectUserInfoEighthScreen(),
              );

            },
            child: Container(
              width: 306,
              height: 63,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AMIN_YELLOW,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "다음으로",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Spacer(flex: 5),
        ],
      ),
    );
  }
}

// 기존 사각형 오버레이 유지 (카메라 미리보기 대신 Container 위에 씌우는 용도)
class OverlayWithRectangleClipping extends StatelessWidget {
  const OverlayWithRectangleClipping({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // const 제거
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _getCustomPaintOverlay(context),
    );
  }

  // 만약 painter 쪽에서 MediaQuery.of(context).size 등을 쓰려면
  // 인자로 context를 넘기고, 그 안에서 size를 구할 수도 있음
  static Widget _getCustomPaintOverlay(BuildContext context) {
    // 예: final size = MediaQuery.of(context).size;
    return CustomPaint(
      painter: RectanglePainter(),
    );
  }
}


class RectanglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black54;
    double maskWidth = size.width * 0.9;
    double maskHeight = size.height * 0.86;

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset(size.width * 0.5, size.height * 0.5),
                width: maskWidth,
                height: maskHeight,
              ),
              const Radius.circular(40),
            ),
          )
          ..close(),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
