import 'package:chatting_1/utils/constants.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
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
    borderRadius: BorderRadius.circular(32),
    child: Ink(
      width: width ?? double.infinity,
      height: height ?? 50,
      decoration: BoxDecoration(
        color: innerColor ?? Color(0xFF3C3C3C),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(width: 2, color: borderColor ?? Color(0xFF3C3C3C)),
        boxShadow: [
          BoxShadow(
            color: shadowColor ?? Color(0x603A86FF),
            blurRadius: 0.0,
            spreadRadius: 0.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize ?? 22,
            color: fontColor ?? ANIM_WHITE,
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

Widget DropDownButton({
  required List ranges,
  required String? selectValue,
  Function(String?)? onChanged,
  String? hintText,
  String? labelText,
}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 1),
    child: DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(16, 20, 8, 16),
        // contentPadding: const EdgeInsets.symmetric(vertical: 16),
        filled: true,
        fillColor: ANIM_WHITE,
        labelText: labelText ?? "labelText", // 라벨 텍스트
        labelStyle: TextStyle(
          fontSize: 20,
          color: ANIM_GREY,
          fontWeight: FontWeight.bold,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        // 하단 바 제거
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.transparent),
        ),
      ),
      hint: Center(
        child: Text(
          hintText ?? "",
          style: TextStyle(
              fontSize: 16
          ),
        ),
      ),
      value: ranges.contains(selectValue) ? selectValue : null,
      items: ranges
          .map((item) => DropdownMenuItem<String>(
        value: item,
        child: Center(
          child: Text(
            item,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return '';
        }
        return null;
      },
      onChanged: onChanged ?? (value) {
        selectValue = value;
      },
      onSaved: (value) {
        selectValue = value.toString();
      },
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.black45,
        ),
        iconSize: 28,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          color: ANIM_WHITE,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    ),
  );
}

Widget MultiLineTextField({
  required TextEditingController textController,
  required ScrollController scrollController,
  double? height,
  String? hintText,
}) {
  return Container(
    width: double.infinity,
    height: height ?? 150,
    margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 1),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: ANIM_WHITE,
    ),
    child: Scrollbar(
      controller: scrollController,
      child: TextField(
        scrollController: scrollController,
        maxLines: null,
        expands: true,
        maxLength: 100,
        controller: textController,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.transparent,
          hintText: hintText ?? "",
          hintStyle: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade400,
          ),
          border: InputBorder.none,
        ),
        style: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        onChanged: (introduce) {
          // notifier.updateIntroduce(introduce);
        },
      ),
    ),
  );
}
