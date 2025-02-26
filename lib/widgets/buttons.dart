import 'package:chatting_1/utils/constants.dart';
import 'package:flutter/material.dart';

Widget DropShadowBasicButton({
  required Widget child,
  double? width,
  double? height,
  Color? innerColor,
  Color? borderColor,
  Color? shadowColor,
  VoidCallback? onTap,
}) {
  return InkWell(
    onTap: onTap ?? () {},
    borderRadius: BorderRadius.circular(12),
    child: Ink(
      width: width ?? double.infinity,
      height: height ?? null,
      // alignment: Alignment.center,
      decoration: BoxDecoration(
        color: innerColor ?? ANIM_WHITE,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 2, color: borderColor ?? ANIM_GREY),
        boxShadow: [
          BoxShadow(
            color: shadowColor ?? ANIM_GREY,
            blurRadius: 0.0,
            spreadRadius: 0.0,
            offset: const Offset(0,2),
          )
        ],
      ),
      child: child,
    ),
  );
}

Widget DropShadowTextButton({
  required String text,
  double? fontSize,
  double? width,
  double? height,
  Color? fontColor,
  Color? innerColor,
  Color? borderColor,
  Color? shadowColor,
  VoidCallback? onTap,
}) {
  return InkWell(
    onTap: onTap ?? () {},
    borderRadius: BorderRadius.circular(12),
    child: Ink(
      width: width ?? double.infinity,
      height: height ?? 50,
      decoration: BoxDecoration(
        color: innerColor ?? ANIM_WHITE,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 2, color: borderColor ?? ANIM_GREY),
        boxShadow: [
          BoxShadow(
            color: shadowColor ?? ANIM_GREY,
            blurRadius: 0.0,
            spreadRadius: 0.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize ?? 22,
            color: fontColor ?? ANIM_BLACK,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

Widget LabelDropTextButton({
  required String text,
  double? fontSize,
  required String labelText,
  double? labelSize,
  double? width,
  double? height,
  VoidCallback? onTap,
}) {
  return Stack(
    clipBehavior: Clip.none, // Stack 내의 아이템들이 겹칠 수 있게 허용
    children: [
      DropShadowTextButton(text: text, fontSize: fontSize, width: width, height: height, onTap: onTap),
      // 버튼 위에 텍스트 (label처럼)
      Positioned(
        top: -30, // 버튼의 위쪽에서 텍스트 위치
        left: 10, // 버튼의 왼쪽에서 텍스트 위치
        child: Text(
          labelText,
          style: TextStyle(
            fontSize: labelSize ?? 17, // 텍스트 크기
            color: Colors.black, // 텍스트 색상
          ),
        ),
      ),
    ],
  );
}