import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:chatting_1/views/auth/image_crop_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

class SettingState {
  final int following;
  final int follower;
  final Image? profilePath;
  final List<Image?>? backgroundImagesPaths;
  final bool isGeoVisible;
  final LatLng? geoLocation;

  SettingState({
    this.following = 0,
    this.follower = 0,
    this.profilePath = null,
    this.isGeoVisible = false,
    this.geoLocation = null,
    List<Image?>? backgroundImagePaths,
  }): this.backgroundImagesPaths = backgroundImagePaths ?? [
    Image.asset('assets/flags/korea_flag.png', fit: BoxFit.cover),
    Image.asset('assets/flags/japan_flag.png', fit: BoxFit.cover),
    Image.asset('assets/flags/usa_flag.png', fit: BoxFit.cover),
  ];

  SettingState copyWith({
    int? following,
    int? follower,
    Image? profilePath,
    bool? isGeoVisible,
    LatLng? geoLocation,
    List<Image?>? backgroundImagePaths,
  }) {
    return SettingState(
      following: following ?? this.following,
      follower: follower ?? this.follower,
      profilePath: profilePath ?? this.profilePath,
      isGeoVisible: isGeoVisible ?? this.isGeoVisible,
      geoLocation: geoLocation ?? this.geoLocation,
      backgroundImagePaths: backgroundImagePaths ?? this.backgroundImagesPaths,
    );
  }
}

class SettingViewModel extends StateNotifier<SettingState> {
  SettingViewModel() : super(SettingState());

  void loadSettingState() {
    // 팔로워 및 정보는 바뀔수 있으므로 페이지가 호출될때마다 리로드
    // 실제로는 firebase에서 불러와야하는데 일단 테스트로 init
    // TODO: 숫자 많아지면 1k로 표기? 고민해보기
    state = state.copyWith(
      following: Random().nextInt(1100),
      follower: Random().nextInt(1100),
      profilePath: null,
      isGeoVisible: false,
      geoLocation: null,
    );
  }

  Future<void> setMainProfileImage(BuildContext context) async {
    XFile? pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery);

    if (pickedImage == null) {
      print("이미지가 선택되지 않았습니다.");
      return;
    }

    // MemoryImage? croppedImage = await Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => ImageCropScreen(imagePath: pickedImage)),
    // );

    // if (croppedImage == null) {
    //   print("크롭된 이미지가 없습니다.");
    //   return;
    // }
    //
    // Image savedImage = Image.memory(
    //   croppedImage.bytes,
    //   fit: BoxFit.cover,
    // );

    // state = state.copyWith(
    //   profilePath: savedImage,
    // );
    // TODO: also update firebase
  }

  Future<void> setBackgroundImage(BuildContext context, int index) async {
    XFile? pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery);

    if (pickedImage == null) {
      print("이미지가 선택되지 않았습니다.");
      return;
    }

    Image newImage = Image.file(File(pickedImage.path), fit: BoxFit.cover);
    List<Image?> updatedImages = List.from(state.backgroundImagesPaths as Iterable);
    updatedImages[index] = newImage;

    state = state.copyWith(
      backgroundImagePaths: updatedImages,
    );

    // TODO: also update firebase
  }

  Image? getUserMyFlagImage() {
    return Image.asset('assets/flags/korea_flag.png', fit: BoxFit.cover);
  }

  Image? getUserTargetFlagImage() {
    return Image.asset('assets/flags/japan_flag.png', fit: BoxFit.cover);
  }
}
