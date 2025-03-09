import 'dart:io';
import 'package:chatting_1/models/user_model.dart';
import 'package:chatting_1/providers/user_provider.dart';
import 'package:chatting_1/views/auth/image_crop_view.dart';
import 'package:chatting_1/views/home/home_main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';

/// State
class RegisterCollectState {
  final String name;
  final String gender;
  final String ageGroup;
  final String purpose;
  final String introduce;
  final int registerState;
  final int myLanguageIndex;
  final int targetLanguageIndex;
  final int languageLevelIndex;
  final List<File?> profileFileArray;       // 프로필 이미지들 (파일)
  final File? currentUserProfileFile;       // 대표 프로필(0번째)
  final File? userIdentificationFile;       // 학생증 파일
  final LatLng? userLocation;               // 위도/경도

  RegisterCollectState({
    this.name = '',
    this.gender = '',
    this.ageGroup = '',
    this.purpose = '',
    this.introduce = '',
    this.registerState = 0,
    this.myLanguageIndex = -1,
    this.targetLanguageIndex = -1,
    this.languageLevelIndex = -1,
    List<File?>? profileFileArray,
    this.currentUserProfileFile,
    this.userIdentificationFile,
    this.userLocation,
  }) : profileFileArray = profileFileArray ?? [null, null, null, null, null];

  RegisterCollectState copyWith({
    String? name,
    String? gender,
    String? ageGroup,
    String? purpose,
    String? introduce,
    int? registerState,
    int? myLanguageIndex,
    int? targetLanguageIndex,
    int? languageLevelIndex,
    List<File?>? profileFileArray,
    File? currentUserProfileFile,
    File? userIdentificationFile,
    LatLng? userLocation,
  }) {
    return RegisterCollectState(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      ageGroup: ageGroup ?? this.ageGroup,
      purpose: purpose ?? this.purpose,
      introduce: introduce ?? this.introduce,
      registerState: registerState ?? this.registerState,
      myLanguageIndex: myLanguageIndex ?? this.myLanguageIndex,
      targetLanguageIndex: targetLanguageIndex ?? this.targetLanguageIndex,
      languageLevelIndex: languageLevelIndex ?? this.languageLevelIndex,
      profileFileArray: profileFileArray ?? this.profileFileArray,
      currentUserProfileFile: currentUserProfileFile ?? this.currentUserProfileFile,
      userIdentificationFile: userIdentificationFile ?? this.userIdentificationFile,
      userLocation: userLocation ?? this.userLocation,
    );
  }
}

/// ViewModel
class RegisterCollectViewModel extends StateNotifier<RegisterCollectState> {
  RegisterCollectViewModel() : super(RegisterCollectState());

  // 성별, 나이대, 목적 등 스피너나 그리드에 사용할 예시 배열
  final genderStringArray = ["남성", "여성", "비공개"];
  final ageStringArray = ["10대", "20대", "30대", "40대", "이외"];
  final purposeStringArray = ["목적1", "좀 더 긴 목적2", "좀 많이많이많이 긴 목적목적목적3"];

  final gridLanguageTextArray = [
    "한국어", "영어", "중국어", "일본어",
    "프랑스어", "스페인어", "러시아어", "베트남어",
  ];
  final gridLanguageImagePathArray = [
    'assets/flags/korea_flag.png',
    'assets/flags/usa_flag.png',
    'assets/flags/china_flag.png',
    'assets/flags/japan_flag.png',
    'assets/flags/france_flag.png',
    'assets/flags/spain_flag.png',
    'assets/flags/russia_flag.png',
    'assets/flags/vietnam_flag.png',
  ];
  final gridLanguageLevelTextArray = [
    "처음 입문해요",
    "기초적인 수준이에요",
    "기본적인 대화가 가능해요",
    "대화하는데 지장이 없어요",
  ];

  // ----- 간단한 setter들 -----
  void updateName(String name) => state = state.copyWith(name: name);
  void updateGender(String gender) => state = state.copyWith(gender: gender);
  void updateAgeGroup(String ageGroup) => state = state.copyWith(ageGroup: ageGroup);
  void updatePurpose(String purpose) => state = state.copyWith(purpose: purpose);
  void updateIntroduce(String introduce) => state = state.copyWith(introduce: introduce);

  void updateMyLanguage(int index) => state = state.copyWith(myLanguageIndex: index);
  void updateTargetLanguage(int index) => state = state.copyWith(targetLanguageIndex: index);
  void updateLanguageLevel(int index) => state = state.copyWith(languageLevelIndex: index);
  void updateRegisterState(int regState) => state = state.copyWith(registerState: regState);

  bool isLanguageSetted() {
    return state.myLanguageIndex != -1 && state.targetLanguageIndex != -1 && state.languageLevelIndex != -1;
  }

  // ----- 프로필 이미지, 학생증 촬영 예시 -----
  Future<void> pickImage(int index) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) {
      debugPrint("이미지가 선택되지 않았습니다.");
      return;
    }
    final file = File(pickedImage.path);

    final updatedImages = [...state.profileFileArray];
    updatedImages[index] = file;

    state = state.copyWith(profileFileArray: updatedImages);
  }

  Future<void> setMainProfileImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage == null) {
      debugPrint("이미지가 선택되지 않았습니다.");
      return;
    }

    // 크롭 화면
    final memoryImage = await Navigator.push<Uint8List?>(
      context,
      MaterialPageRoute(builder: (context) => ImageCropScreen(imagePath: pickedImage.path)),
    );

    if (memoryImage == null) {
      debugPrint("크롭된 이미지가 없습니다.");
      return;
    }

    // 임시 파일로 저장
    final croppedFile = await _writeBytesToTempFile(memoryImage);

    final updatedImages = [...state.profileFileArray];
    updatedImages[0] = croppedFile;

    state = state.copyWith(
      profileFileArray: updatedImages,
      currentUserProfileFile: croppedFile,
    );
  }

  Future<bool> takeStudentCard() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) {
      debugPrint("학생증 사진이 촬영되지 않았습니다.");
      return false;
    }
    final file = File(pickedFile.path);
    state = state.copyWith(userIdentificationFile: file);
    return true;
  }

  // ----- 위치 수집 로직 -----
  Future<void> fetchUserLocation() async {
    final loc = await _getCurrentLatLng();
    state = state.copyWith(userLocation: loc);
  }

  void resetUserLocation() {
    // 위치를 없애고 싶을 때
    state = state.copyWith(userLocation: null);
  }

  Future<LatLng?> _getCurrentLatLng() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint("위치 서비스가 비활성화됨");
      return null;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint("위치 권한 거부됨");
        return null;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      debugPrint("위치 권한 영구 거부됨");
      return null;
    }

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return LatLng(pos.latitude, pos.longitude);
  }

  // ----- 최종 DB 저장 (9번째 화면에서 호출) -----
  Future<void> submitFinalData(WidgetRef ref, BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      debugPrint("로그인된 사용자가 없습니다.");
      return;
    }
    final uid = currentUser.uid;
    final now = DateTime.now().toIso8601String();

    // 언어 인덱스 → 실제 텍스트
    String myLang = '';
    if (state.myLanguageIndex >= 0 && state.myLanguageIndex < gridLanguageTextArray.length) {
      myLang = gridLanguageTextArray[state.myLanguageIndex];
    }
    String targetLang = '';
    if (state.targetLanguageIndex >= 0 && state.targetLanguageIndex < gridLanguageTextArray.length) {
      targetLang = gridLanguageTextArray[state.targetLanguageIndex];
    }
    String level = '';
    if (state.languageLevelIndex >= 0 && state.languageLevelIndex < gridLanguageLevelTextArray.length) {
      level = gridLanguageLevelTextArray[state.languageLevelIndex];
    }

    // 위치 → "위도,경도" 문자열 (없으면 "")
    String locationStr = "";
    if (state.userLocation != null) {
      locationStr = "${state.userLocation!.latitude},${state.userLocation!.longitude}";
    }

    // UserModel 생성
    final userModel = UserModel(
      uid: uid,
      userName: state.name,
      gender: state.gender,
      ageGroup: state.ageGroup,
      purpose: state.purpose,
      introduce: state.introduce,
      location: locationStr,
      myLanguage: myLang,
      targetLanguage: targetLang,
      languageLevel: level,
      profileImageUrls: [],
      friends: {},
      studentCardUrl: '',
      createdAt: now,
      updatedAt: now,
    );

    // userProvider => saveUserData
    final userNotifier = ref.read(userProvider.notifier);
    await userNotifier.saveUserData(
      userModel: userModel,
      profileImages: state.profileFileArray,
      studentCardImage: state.userIdentificationFile,
    );

    final err = ref.read(userProvider).errorMessage;
    if (err.isNotEmpty) {
      debugPrint("DB 저장 중 에러 발생: $err");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("DB 저장 오류: $err")),
      );
      return;
    } else {
      debugPrint("DB 저장 성공!");

      // isCollected = true
      try {
        final dbRef = FirebaseDatabase.instance.ref('users/$uid');
        await dbRef.update({"isCollected": true});
        debugPrint("isCollected = true 업데이트 완료.");
      } catch (e) {
        debugPrint("isCollected 업데이트 에러: $e");
      }

      // 완료 후 홈화면으로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeMain()),
      );
    }
  }

  // ----- 크롭된 이미지 임시파일로 저장 -----
  Future<File> _writeBytesToTempFile(Uint8List bytes) async {
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File(filePath);
    await file.writeAsBytes(bytes);
    return file;
  }
}
