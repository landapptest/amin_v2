import 'package:flutter/material.dart';

//공통 textfield 스타일
class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const MyTextField({
    Key? key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Theme.of(context)로 생상 다르게 적용
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          enabledBorder:OutlineInputBorder(
            borderSide:
            BorderSide(color: Theme.of(context).colorScheme.tertiary),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
            BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          fillColor: Theme.of(context).colorScheme.secondary,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}