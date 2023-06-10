import 'package:flutter/material.dart';
import 'package:socialify/screens/home_screen.dart';
import 'package:socialify/utils/colors.dart';

import '../helper/helper_function.dart';
import '../servies/auth.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = "";
  String email = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  void getUserData() {
    HelperFunction.getUsernameFromSharedPreferences().then((value) {
      setState(() {
        username = value!;
      });
    });
    HelperFunction.getUserEmailFromSharedPreferences().then((value) {
      setState(() {
        email = value!;
      });
    });
  }

  void navigateToLoginScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 5),
          children: [
            const SizedBox(
              height: 30,
            ),
            const Icon(
              Icons.account_circle,
              size: 100,
              color: kprimaryColor,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              username,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              color: kprimaryColor,
              height: 2,
            ),
            ListTile(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },

              selectedColor: kprimaryColor,
              leading: const Icon(Icons.group),
              title: const Text(
                "Groups",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              // contentPadding:
              // const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            ),
            ListTile(
              onTap: () {},
              selectedColor: kprimaryColor,
              selected: true,
              leading: const Icon(Icons.person),
              title: const Text(
                "Profile",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              // contentPadding:
              // const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            ),
            const Divider(
              color: kprimaryColor,
              height: 2,
            ),
            ListTile(
              onTap: () {
                Auth().signoutUser().whenComplete(() async {
                  await HelperFunction
                      .saveUserLoggedInStatusToSharedPreferences(false);
                  await HelperFunction.saveUsernameToSharedPreferences("");
                  await HelperFunction.saveUserEmailToSharedPreferences("");
                  navigateToLoginScreen();
                });
              },
              selectedColor: kprimaryColor,
              leading: const Icon(Icons.logout),
              title: const Text(
                "Logout",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              // contentPadding:
              // const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            ),
          ],
        ),
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.account_circle,
                color: kprimaryColor,
                size: 150,
              ),
              const SizedBox(
                height: 24,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  "Full Name : ",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                Text(
                  username,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ]),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Full Email : ",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
