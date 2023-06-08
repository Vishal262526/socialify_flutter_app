import 'package:flutter/material.dart';

class PrimaryInput extends StatelessWidget {
  const PrimaryInput({
    super.key,
    required this.placeholder,
    required this.controller,
    this.textColor = Colors.black,
    this.secureTextEntry = false,
    this.keywordType = TextInputType.text,
    this.underlineInputBorder = true,
  });

  final TextEditingController controller;
  final String placeholder;
  final bool secureTextEntry;
  final TextInputType keywordType;
  final bool underlineInputBorder;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(color: textColor),
      obscureText: secureTextEntry,
      keyboardType: keywordType,
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: TextStyle(
          color: textColor,
        ),
        // enabled: underlineInputBorder
        border: underlineInputBorder
            ? const UnderlineInputBorder()
            : InputBorder.none,
      ),
    );
  }
}
