import 'package:flutter/material.dart';
import 'package:socialify/components/primary_btn.dart';
import 'package:socialify/components/primary_input.dart';
import 'package:socialify/helper/helper_function.dart';
import 'package:socialify/screens/home_screen.dart';
import 'package:socialify/servies/auth.dart';
import 'package:socialify/utils/colors.dart';
import 'package:socialify/widgets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isLoading = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                backgroundColor: kprimaryColor,
                color: Colors.transparent,
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "SIGN UP",
                    style: TextStyle(
                      fontSize: 32,
                      color: kprimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: kprimaryColor,
                    child: Icon(
                      Icons.person,
                      color: kWhiteColor,
                      size: 50,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  PrimaryInput(
                    controller: _nameController,
                    placeholder: "Full Name",
                  ),
                  const SizedBox(
                    height: 16,
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
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      final Map userRegisterStatus =
                          await Auth().signupWithEmailAndPassword(
                        fullName: _nameController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                      // if user successfully register
                      if (userRegisterStatus['success']) {
                        await HelperFunction
                            .saveUserLoggedInStatusToSharedPreferences(true);
                        await HelperFunction.saveUsernameToSharedPreferences(
                            _nameController.text);
                        await HelperFunction.saveUserEmailToSharedPreferences(
                            _emailController.text);
                        navigateToHomeScreen();
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                        showSnackBar(context, kprimaryColor, kWhiteColor,
                            userRegisterStatus['err']);
                      }
                    },
                    titleColor: kWhiteColor,
                    backgroundColor: kprimaryColor,
                    title: 'REGISTER NOW',
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  PrimaryButton(
                    backgroundColor: kWhiteColor,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    titleColor: kprimaryColor,
                    title: 'GO BACK',
                  ),
                ],
              ),
            ),
    );
  }
}
