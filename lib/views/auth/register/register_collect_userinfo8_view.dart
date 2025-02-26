import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatting_1/providers/auth_provider.dart';
import 'package:chatting_1/utils/constants.dart';
import 'package:chatting_1/views/auth/register/register_collect_userinfo9_view.dart';
import 'package:chatting_1/providers/user_provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:chatting_1/utils/route.dart';

class RegisterCollectUserInfoEighthScreen extends ConsumerStatefulWidget {
  const RegisterCollectUserInfoEighthScreen({Key? key}) : super(key: key);

  @override
  _RegisterCollectUserInfoEighthScreenState createState() =>
      _RegisterCollectUserInfoEighthScreenState();
}

class _RegisterCollectUserInfoEighthScreenState
    extends ConsumerState<RegisterCollectUserInfoEighthScreen> {
  @override
  void initState() {
    super.initState();
    // 화면 들어오면 위치 fetch
    final notifier = ref.read(registerCollectViewModelProvider.notifier);
    notifier.fetchUserLocation();
  }

  /// 동네 등록 (위치가 null이 아니면 DB 저장 → 9번 화면 이동)
  /// 위치가 null이면 다시 위치 fetch
  void onTapRegister() async {
    final notifier = ref.read(registerCollectViewModelProvider.notifier);
    final state = ref.read(registerCollectViewModelProvider);

    if (state.userLocation == null) {
      // 위치가 아직 없으면 다시 시도
      await notifier.fetchUserLocation();
      if (ref.read(registerCollectViewModelProvider).userLocation == null) {
        // 그래도 없으면 그냥 return or 안내
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("위치를 가져올 수 없습니다.")),
        );
        return;
      }
    }

    // 위치가 있든 없든 => 여기서 DB 저장 (submitFinalData)
    await notifier.submitFinalData(ref, context);

    // submitFinalData 내부에서 에러처리 or DB저장 성공 처리
    final err = ref.read(userProvider).errorMessage;
    if (err.isNotEmpty) {
      // DB 저장 실패
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("DB 저장 오류: $err")),
      );
      return;
    } else {
      // DB 저장 성공 -> 9번 화면 이동
      AppRoutes.push(
        context,
        const RegisterCollectUserInfoNinethScreen(),
      );

    }
  }

  /// 넘어가기 (위치 스킵) => confirm 후 DB 저장 or 그냥 넘어가기
  void onTapSkip() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "위치를 스킵하면 주변 친구 검색이 제한될 수 있어요.",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "나중에 설정에서 위치를 등록할 수 있습니다.",
                  style: TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context); // 바텀시트 닫고

                    // 위치를 스킵 => userLocation을 null로 유지해도 됨
                    // 곧바로 DB 저장 submitFinalData
                    final notifier =
                    ref.read(registerCollectViewModelProvider.notifier);

                    // 만약 "스킵" 시 location 없이 저장하고 싶다면,
                    // 굳이 resetUserLocation()도 가능
                    // notifier.resetCurrentLatLng();

                    await notifier.submitFinalData(ref, this.context);
                    final err = ref.read(userProvider).errorMessage;
                    if (err.isNotEmpty) {
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        SnackBar(content: Text("DB 저장 오류: $err")),
                      );
                      return;
                    }
                    AppRoutes.push(
                      context,
                      const RegisterCollectUserInfoNinethScreen(),
                    );

                  },
                  child: Container(
                    width: 280,
                    height: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: ANIM_YELLOW,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "위치 스킵하고 가입하기",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerCollectViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            const Spacer(flex: 8),
            const Text(
              "주변에 있는 친구들을 찾아보세요",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "자신의 지역을 확인해주세요",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13),
            ),
            const Spacer(flex: 2),
            SizedBox(
              width: 300,
              height: 300,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                clipBehavior: Clip.hardEdge,
                child: (state.userLocation == null)
                    ? const Center(child: CircularProgressIndicator())
                    : FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(
                      state.userLocation!.latitude,
                      state.userLocation!.longitude,
                    ),
                    initialZoom: 15.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(
                            state.userLocation!.latitude,
                            state.userLocation!.longitude,
                          ),
                          width: 80,
                          height: 80,
                          child: const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(flex: 3),
            GestureDetector(
              onTap: onTapRegister,
              child: Container(
                width: 304,
                height: 63,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: (state.userLocation == null)
                      ? const Color(0xFFD9D9D9)
                      : ANIM_YELLOW,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "동네 등록",
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
            GestureDetector(
              onTap: onTapSkip,
              child: Container(
                width: 304,
                height: 63,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ANIM_YELLOW.withAlpha(0xC0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "넘어가기",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Spacer(flex: 1),
            const Text(
              "* 다른사람들은 내 동네만 확인할 수 있어요",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13),
            ),
            const Spacer(flex: 7),
          ],
        ),
      ),
    );
  }
}
