import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:socialify/screens/group_info_screen.dart';
import 'package:socialify/servies/database.dart';
import 'package:socialify/utils/colors.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.groupid,
    required this.groupName,
    required this.username,
  });

  final String groupid;
  final String groupName;
  final String username;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Stream<QuerySnapshot>? chats;
  String admin = "";

  @override
  void initState() {
    // TODO: implement initState
    getChatAndAdminData();
    super.initState();
  }

  void getChatAndAdminData() async {
    setState(() {
      chats = Database(uid: FirebaseAuth.instance.currentUser!.uid)
          .getGroupChat(widget.groupid);
      print(chats);
    });

    admin = await Database(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupAdmin(widget.groupid);
    admin = extractAdminName(admin);
  }

  // Extract a Admin name from the uid_adminname pattern string
  String extractAdminName(String value) {
    return value.split("_")[1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 70,
        titleSpacing: 0,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupInfoScreen(
                    groupId: widget.groupid,
                    groupName: widget.groupName,
                    adminName: admin,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.info,
            ),
          ),
        ],
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: kWhiteColor,
              child: Text(
                widget.groupName[0],
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: kprimaryColor,
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Text(widget.groupName)
          ],
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Text(widget.groupName),
      ),
    );
  }
}
