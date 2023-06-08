import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialify/components/group_tile.dart';
import 'package:socialify/components/primary_btn.dart';
import 'package:socialify/components/primary_input.dart';
import 'package:socialify/helper/helper_function.dart';
import 'package:socialify/screens/login_screen.dart';
import 'package:socialify/screens/profile_screen.dart';
import 'package:socialify/screens/search_screen.dart';
import 'package:socialify/servies/auth.dart';
import 'package:socialify/servies/database.dart';
import 'package:socialify/utils/colors.dart';
import 'package:socialify/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
// Controllers
  final TextEditingController _groupNameController = TextEditingController();

  String username = "";
  String email = "";
  Stream<DocumentSnapshot>? groups;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  String getGroupName(String value) {
    return value.split("_")[1];
  }

  String getGroupId(String value) {
    return value.split("_")[0];
  }

  Widget getGroupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        // Make some checks
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              print("Initlizing ..............");
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context, index) {
                  final int currentIndex =
                      snapshot.data['groups'].length - index - 1;
                  final String groupName =
                      getGroupName(snapshot.data['groups'][currentIndex]);
                  final String groupId =
                      getGroupId(snapshot.data['groups'][currentIndex]);

                  return GroupTile(
                    username: username,
                    groupName: groupName,
                    groupId: groupId,
                    subTitle: "No Message are there",
                  );
                },
              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: kprimaryColor,
              backgroundColor: Colors.transparent,
            ),
          );
        }
      },
    );
  }

  void createGroup() async {
    Navigator.pop(context);
    if (_groupNameController.text != "") {
      final Map newGroupStatus =
          await Database(uid: FirebaseAuth.instance.currentUser!.uid)
              .createGroup(_groupNameController.text,
                  FirebaseAuth.instance.currentUser!.uid, username);

      if (newGroupStatus['success']) {
        showSnackBar(
            context, kprimaryColor, kWhiteColor, "Group Created Successfully");
      } else {
        print(newGroupStatus['err']);
      }
    } else {
      showSnackBar(context, kprimaryColor, kWhiteColor,
          "Group Name is Empty, please try again");
    }
  }

  Widget noGroupWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      alignment: Alignment.center,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.add_circle,
            color: kprimaryColor,
            size: 75,
          ),
          SizedBox(
            height: 20,
          ),
          Text("You don't have an group tap to create new"),
        ],
      ),
    );
  }

  void popupDialogue(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "New Group",
              textAlign: TextAlign.left,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PrimaryInput(
                  placeholder: "Group Name",
                  controller: _groupNameController,
                )
              ],
            ),
            actions: [
              PrimaryButton(
                title: 'Create',
                onTap: createGroup,
                backgroundColor: kprimaryColor,
                titleColor: kWhiteColor,
              ),
              const SizedBox(
                height: 8,
              ),
              PrimaryButton(
                title: 'Cancel',
                onTap: () {
                  Navigator.pop(context);
                },
                backgroundColor: kprimaryColor,
                titleColor: kWhiteColor,
              )
            ],
          );
        });
  }

  void getUserData() async {
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

    // get the list of groups snapshots
    setState(() {
      groups =
          Database(uid: FirebaseAuth.instance.currentUser!.uid).getUserGroup();
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
        title: const Text("Groups"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
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
              onTap: () {},
              selected: true,
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
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
              selectedColor: kprimaryColor,
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
      body: getGroupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popupDialogue(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
