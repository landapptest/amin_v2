import 'package:flutter/material.dart';
import 'dart:math';

final images = [
  "https://randomuser.me/api/protraits/men/40.jpg",
];

ListTile _tile(String title, String subtitle) => ListTile(
  title: Text(title,
    style: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      fontFamily: 'Noto Sans KR',
      color: Colors.black,
    ),
  ),
  subtitle: Text(subtitle),
  leading: _userImage(images[Random().nextInt(images.length)]),
  trailing: Row(
    mainAxisSize: MainAxisSize.min, // 아이콘들이 너무 넓게 퍼지지 않도록 최소 크기만 차지하도록 설정
    children: <Widget>[
      IconButton(
        icon: Icon(Icons.favorite_border),
        onPressed: () {},
        style: IconButton.styleFrom(foregroundColor: Colors.redAccent, iconSize: 30),
      ),
      IconButton(
        icon: Icon(Icons.send), // 추가된 두 번째 아이콘 (예: 공유 아이콘)
        onPressed: () {},
        style: IconButton.styleFrom(foregroundColor: Colors.blueAccent, iconSize: 30),
      ),
    ],
  ),
);

ClipRRect _userImage(String url) => ClipRRect(
  borderRadius: BorderRadius.circular(100),
  child: Image.network(url, width:50, height: 50, fit: BoxFit.cover),
);