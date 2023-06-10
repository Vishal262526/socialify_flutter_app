import 'package:flutter/material.dart';
import 'package:socialify/utils/colors.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode mode = ThemeMode.system;
  bool get isDarkMode => mode == ThemeMode.dark;

  void toggleThemeMode(bool value) {
    mode = value ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyTheme {
  static final darkTheme = ThemeData(
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: kprimaryColor,
        foregroundColor: kWhiteColor,
      ),
      scaffoldBackgroundColor: Colors.grey.shade900,
      colorScheme: const ColorScheme.dark(),
      primaryColor: Colors.black,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey.shade800,
        elevation: 0,
      ),
      iconTheme: const IconThemeData(
        color: kWhiteColor,
      ),
      hintColor: kBlackColor);

  static final lightTheme = ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: kprimaryColor,
      foregroundColor: kWhiteColor,
    ),
    scaffoldBackgroundColor: kLightColor,
    colorScheme: const ColorScheme.light(),
    primaryColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: kprimaryColor,
      elevation: 0,
    ),
    iconTheme: const IconThemeData(
      color: kprimaryColor,
    ),
    hintColor: Colors.white,
  );
}
