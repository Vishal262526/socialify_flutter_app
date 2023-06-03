import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:socialify/firebase_options.dart';
import 'package:socialify/helper/helper_function.dart';
import 'package:socialify/screens/home_screen.dart';
import 'package:socialify/screens/login_screen.dart';
import 'package:socialify/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLoggedInStatus();
  }

  void getUserLoggedInStatus() async {
    bool? loginStatus = await HelperFunction.getUserLoggedInStatus();
    if (loginStatus != null) {
      setState(() {
        userIsLoggedin = loginStatus;
      });
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.light().copyWith(
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: kprimaryColor,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: kprimaryColor,
            centerTitle: true,
            elevation: 0,
          ),
          scaffoldBackgroundColor: kLightColor),
      home: userIsLoggedin ? const HomeScreen() : const LoginScreen(),
    );
  }
}
