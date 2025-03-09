import 'package:flutter/material.dart';

//riverpod StateNotifier에서 간편하게 사용하기 위해 제작
class MyFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  /// 선택(필요시) 색상, 미선택 색상 등 UI 관련 속성
  final Color? selectedColor;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  const MyFilterChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.selectedColor,
    this.backgroundColor,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(
        label,
        style: textStyle ?? const TextStyle(color: Colors.white),
      ),
      selected: isSelected,
      backgroundColor: backgroundColor ?? Colors.grey[800],
      selectedColor: selectedColor ?? const Color(0xFFCB9C5A),
      onSelected: onSelected,
    );
  }
}
