import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  final String uid;
  final String userName;
  final String gender;
  final String ageGroup;
  final String purpose;
  final String introduce;
  final String location;
  final String myLanguage;
  final String targetLanguage;
  final String languageLevel;
  final List<String> profileImageUrls;
  final Map<String, String> friends;
  final String studentCardUrl;
  final String createdAt;
  final String updatedAt;

  const UserModel({
    required this.uid,
    required this.userName,
    required this.gender,
    required this.ageGroup,
    required this.purpose,
    required this.introduce,
    required this.location,
    required this.myLanguage,
    required this.targetLanguage,
    required this.languageLevel,
    required this.profileImageUrls,
    required this.friends,
    required this.studentCardUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'userName': userName,
      'gender': gender,
      'ageGroup': ageGroup,
      'purpose': purpose,
      'introduce': introduce,
      'location': location,
      'myLanguage': myLanguage,
      'targetLanguage': targetLanguage,
      'languageLevel': languageLevel,
      'profileImageUrls': profileImageUrls,
      'friends': friends,
      'studentCardUrl': studentCardUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      userName: json['userName'] ?? '',
      gender: json['gender'] ?? '',
      ageGroup: json['ageGroup'] ?? '',
      purpose: json['purpose'] ?? '',
      introduce: json['introduce'] ?? '',
      location: json['location'] ?? '',
      myLanguage: json['myLanguage'] ?? '',
      targetLanguage: json['targetLanguage'] ?? '',
      languageLevel: json['languageLevel'] ?? '',
      profileImageUrls: (json['profileImageUrls'] as List<dynamic>?)
          ?.map((item) => item.toString())
          .toList() ??
          [],
      friends: (json['friends'] as Map?)?.map((key, value) {
        return MapEntry(key.toString(), value.toString());
      }) ??
          {},
      studentCardUrl: json['studentCardUrl'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  UserModel copyWith({
    String? uid,
    String? userName,
    String? gender,
    String? ageGroup,
    String? purpose,
    String? introduce,
    String? location,
    String? myLanguage,
    String? targetLanguage,
    String? languageLevel,
    List<String>? profileImageUrls,
    Map<String, String>? friends,
    String? studentCardUrl,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      userName: userName ?? this.userName,
      gender: gender ?? this.gender,
      ageGroup: ageGroup ?? this.ageGroup,
      purpose: purpose ?? this.purpose,
      introduce: introduce ?? this.introduce,
      location: location ?? this.location,
      myLanguage: myLanguage ?? this.myLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      languageLevel: languageLevel ?? this.languageLevel,
      profileImageUrls: profileImageUrls ?? this.profileImageUrls,
      friends: friends ?? this.friends,
      studentCardUrl: studentCardUrl ?? this.studentCardUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
