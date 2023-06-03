import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialify/components/primary_btn.dart';
import 'package:socialify/components/primary_input.dart';
import 'package:socialify/helper/helper_function.dart';
import 'package:socialify/screens/home_screen.dart';
import 'package:socialify/screens/signup_screen.dart';
import 'package:socialify/servies/auth.dart';
import 'package:socialify/servies/database.dart';
import 'package:socialify/utils/colors.dart';
import 'package:socialify/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void navigateToHomeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  void loginUser(String email, String password) async {
    setState(() {
      isLoading = true;
    });
    final Map loginData = await Auth()
        .loginUserWithEmailAndPassword(email: email, password: password);
    if (loginData['success']) {
      try {
        final QuerySnapshot userSnapshot = await Database(
          uid: FirebaseAuth.instance.currentUser!.uid,
        ).getUserData(email);
        await HelperFunction.saveUserLoggedInStatusToSharedPreferences(true);
        await HelperFunction.saveUsernameToSharedPreferences(
            userSnapshot.docs[0]['fullName']);
        await HelperFunction.saveUserEmailToSharedPreferences(
            userSnapshot.docs[0]['email']);
        navigateToHomeScreen();
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print("Something went wrong");
      }
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, kprimaryColor, kWhiteColor, loginData['err']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: kprimaryColor,
                backgroundColor: Colors.transparent,
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "LOG IN",
                    style: TextStyle(
                      fontSize: 32,
                      color: kprimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  PrimaryInput(
                    keywordType: TextInputType.emailAddress,
                    controller: _emailController,
                    placeholder: "Email",
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  PrimaryInput(
                    secureTextEntry: true,
                    controller: _passwordController,
                    placeholder: "Password",
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  PrimaryButton(
                    onTap: () {
                      loginUser(
                          _emailController.text, _passwordController.text);
                    },
                    titleColor: kWhiteColor,
                    backgroundColor: kprimaryColor,
                    title: 'LOG IN',
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  PrimaryButton(
                    backgroundColor: kWhiteColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },
                    titleColor: kprimaryColor,
                    title: 'SIGN UP',
                  ),
                ],
              ),
            ),
    );
  }
}
