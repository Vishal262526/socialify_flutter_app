import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.title,
    required this.onTap,
    required this.backgroundColor,
    required this.titleColor,
    this.width = double.infinity,
  });

  final String title;
  final VoidCallback onTap;
  final Color titleColor;
  final Color backgroundColor;
  final double width;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: backgroundColor,
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
