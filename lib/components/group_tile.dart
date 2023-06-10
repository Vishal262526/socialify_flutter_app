import 'package:flutter/material.dart';

import '../screens/chat_screen.dart';
import '../utils/colors.dart';

class GroupTile extends StatelessWidget {
  const GroupTile({
    super.key,
    required this.groupName,
    required this.groupId,
    required this.subTitle,
    required this.username,
  });

  final String groupId;
  final String groupName;
  final String subTitle;
  final String username;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              groupid: groupId,
              groupName: groupName,
              username: username,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          leading: CircleAvatar(
              backgroundColor: kprimaryColor,
              radius: 30,
              child: Text(
                groupName[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: kWhiteColor,
                ),
              )),
          title: Text(
            groupName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          subtitle: Text(
            subTitle,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }
}
