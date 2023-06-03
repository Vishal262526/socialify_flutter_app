import 'package:flutter/material.dart';

class PrimaryInput extends StatelessWidget {
  const PrimaryInput({
    super.key,
    required this.placeholder,
    required this.controller,
    this.secureTextEntry = false,
    this.keywordType = TextInputType.text,
  });

  final TextEditingController controller;
  final String placeholder;
  final bool secureTextEntry;
  final TextInputType keywordType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: secureTextEntry,
      keyboardType: keywordType,
      decoration: InputDecoration(
        hintText: placeholder,
        border: const UnderlineInputBorder(),
      ),
    );
  }
}
