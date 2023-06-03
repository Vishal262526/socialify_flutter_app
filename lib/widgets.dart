import 'package:flutter/material.dart';

// showing snackbar
void showSnackBar(
  BuildContext context,
  Color backgroundColor,
  Color textColor,
  String message,
) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: backgroundColor,
    content: Text(
      message,
      style: TextStyle(
        color: textColor,
      ),
    ),
    duration: const Duration(seconds: 2),
    action: SnackBarAction(
      label: "OK",
      onPressed: () {},
      textColor: textColor,
    ),
  ));
}
