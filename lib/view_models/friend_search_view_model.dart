import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:chatting_1/models/user_model.dart';

class FriendSearchState {
  final bool isLoading;
  final String errorMessage;

  // 필터
  final String selectedLanguage;
  final String selectedPurpose;
  final String selectedGender;

  // 전체 유저
  final List<UserModel> allUsers;
  // 필터 적용된 유저
  final List<UserModel> filteredUsers;

  const FriendSearchState({
    this.isLoading = false,
    this.errorMessage = '',
    this.selectedLanguage = '',
    this.selectedPurpose = '',
    this.selectedGender = '',
    this.allUsers = const [],
    this.filteredUsers = const [],
  });

  FriendSearchState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? selectedLanguage,
    String? selectedPurpose,
    String? selectedGender,
    List<UserModel>? allUsers,
    List<UserModel>? filteredUsers,
  }) {
    return FriendSearchState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      selectedPurpose: selectedPurpose ?? this.selectedPurpose,
      selectedGender: selectedGender ?? this.selectedGender,
      allUsers: allUsers ?? this.allUsers,
      filteredUsers: filteredUsers ?? this.filteredUsers,
    );
  }
}

class FriendSearchViewModel extends StateNotifier<FriendSearchState> {
  FriendSearchViewModel() : super(const FriendSearchState());

  final _dbRef = FirebaseDatabase.instance.ref();
  final _auth = FirebaseAuth.instance;

  //1) 전체 유저 allUsers에 저장 → 필터 적용
  Future<void> fetchAllUsers() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: '');
      final snap = await _dbRef.child('users').get();
      if (!snap.exists) {
        state = state.copyWith(isLoading: false, allUsers: [], filteredUsers: []);
        return;
      }

      final data = snap.value as Map<dynamic, dynamic>;
      final myUid = _auth.currentUser?.uid ?? '';
      final List<UserModel> userList = [];

      data.forEach((_, rawVal) {
        if (rawVal is Map) {
          final userMap = Map<String, dynamic>.from(rawVal);
          final userModel = UserModel.fromJson(userMap);
          if (userModel.uid != myUid) {
            userList.add(userModel);
          }
        }
      });

      state = state.copyWith(isLoading: false, allUsers: userList);
      _applyFilterInternal();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  //필터 업데이트
  void updateLanguage(String lang) {
    state = state.copyWith(selectedLanguage: lang);
    _applyFilterInternal();
  }

  void updatePurpose(String purpose) {
    state = state.copyWith(selectedPurpose: purpose);
    _applyFilterInternal();
  }

  void updateGender(String gender) {
    state = state.copyWith(selectedGender: gender);
    _applyFilterInternal();
  }

  //2) 친구 요청 보내기 (내 DB: requested, 상대 DB: pending)
  Future<void> sendFriendRequest(String targetUid) async {
    final myUid = _auth.currentUser?.uid;
    if (myUid == null || myUid.isEmpty) return;

    try {
      final updates = <String, dynamic>{};
      updates["users/$myUid/friends/$targetUid"] = "requested";
      updates["users/$targetUid/friends/$myUid"] = "pending";
      await _dbRef.update(updates);
    } catch (e) {
      //예외 처리
    }
  }

  //내부 필터
  void _applyFilterInternal() {
    final lang = state.selectedLanguage;
    final purp = state.selectedPurpose;
    final gen = state.selectedGender;

    final filtered = state.allUsers.where((user) {
      //언어
      final matchLang = (lang.isEmpty
          || user.myLanguage == lang
          || user.targetLanguage == lang);
      //목적
      final matchPurp = (purp.isEmpty || user.purpose == purp);
      //성별
      final noGenderFilter = (gen.isEmpty || gen == '무관' || gen == '상관 없음');
      final matchGen = (noGenderFilter || user.gender == gen);

      return matchLang && matchPurp && matchGen;
    }).toList();

    state = state.copyWith(filteredUsers: filtered);
  }
}

final friendSearchViewModelProvider =
StateNotifierProvider<FriendSearchViewModel, FriendSearchState>((ref) {
  return FriendSearchViewModel();
});
