import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialify/components/message_tile.dart';
import 'package:socialify/components/primary_input.dart';
import 'package:socialify/provider/theme_provider.dart';
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
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _chatMessagesController = ScrollController();
  Stream<QuerySnapshot>? chats;
  String admin = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChatAndAdminData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _messageController.dispose();
    super.dispose();
  }

  void getChatAndAdminData() async {
    setState(() {
      chats = Database(uid: FirebaseAuth.instance.currentUser!.uid)
          .getGroupChat(widget.groupid);
    });

    admin = await Database(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupAdmin(widget.groupid);
    admin = extractAdminName(admin);
  }

  // Extract a Admin name from the uid_adminname pattern string
  String extractAdminName(String value) {
    return value.split("_")[1];
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageData = {
        "message": _messageController.text,
        "sender": widget.username,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      final bool messageSent =
          await Database(uid: FirebaseAuth.instance.currentUser!.uid)
              .sendMessage(widget.groupid, chatMessageData);
      if (messageSent) {
        _messageController.clear();
      } else {
        print("Something went wrong");
      }
    }
  }

  void scrollToEnd() {
    final double position = _chatMessagesController.position.minScrollExtent;
    _chatMessagesController.animateTo(position,
        duration: const Duration(seconds: 1), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: kWhiteColor,
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
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: chatMessages(),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                color:
                    Provider.of<ThemeProvider>(context).mode == ThemeMode.dark
                        ? Colors.grey.shade800
                        : kLightColor,
                child: Row(
                  children: [
                    Expanded(
                      child: PrimaryInput(
                        controller: _messageController,
                        placeholder: "Type a message",
                        textColor: kBlackColor,
                        underlineInputBorder: false,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    InkWell(
                      onTap: sendMessage,
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: kprimaryColor),
                        child: const Icon(
                          Icons.send,
                          color: kWhiteColor,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget chatMessages() => StreamBuilder(
        stream: chats,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  reverse: true,
                  controller: _chatMessagesController,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                      message: snapshot.data.docs[index]['message'],
                      senderName: snapshot.data.docs[index]['sender'],
                      sentByMe: widget.username ==
                          snapshot.data.docs[index]['sender'],
                    );
                  })
              : Container();
        },
      );
}
