import 'dart:io';
import 'package:chatting_1/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//사용자 정보 DB에 저장/업데이트 시 로딩이나 에러 표시
class UserState {
  final bool isLoading;
  final String errorMessage;

  const UserState({
    this.isLoading = false,
    this.errorMessage = '',
  });

  UserState copyWith({
    bool? isLoading,
    String? errorMessage,
  }) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

//사용자 정보 DB 저장/업데이트 로직
class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(const UserState());

  Future<void> saveUserData({
    required UserModel userModel,
    required List<File?> profileImages,
    File? studentCardImage,
  }) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: '');

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("로그인 정보가 없습니다.");
      }

      final uid = currentUser.uid;
      if (uid != userModel.uid) {
        throw Exception("현재 로그인된 사용자 UID와 userModel.uid가 다릅니다.");
      }
      final storage = FirebaseStorage.instance;
      final uploadedPaths = <String>[];

      for (final file in profileImages) {
        if (file == null) continue;

        final fileName = "profileImages/$uid/${DateTime.now().millisecondsSinceEpoch}";
        await storage.ref(fileName).putFile(file);
        uploadedPaths.add(fileName);
      }

      String studentCardPath = '';
      if (studentCardImage != null) {
        final fileName = "studentCards/$uid/${DateTime.now().millisecondsSinceEpoch}";
        await storage.ref(fileName).putFile(studentCardImage);
        studentCardPath = fileName;
      }

      final updatedModel = userModel.copyWith(
        profileImageUrls: uploadedPaths,
        studentCardUrl: studentCardPath,
        updatedAt: DateTime.now().toIso8601String(),
      );

      final dbRef = FirebaseDatabase.instance.ref();
      await dbRef.child('users').child(uid).set(updatedModel.toJson());

      state = state.copyWith(isLoading: false);

    } on FirebaseException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message ?? 'FirebaseException',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});
