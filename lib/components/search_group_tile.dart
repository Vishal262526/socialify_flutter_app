import 'package:flutter/material.dart';

import '../screens/chat_screen.dart';
import '../utils/colors.dart';

class SearchGroupTile extends StatelessWidget {
  const SearchGroupTile({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.username,
    required this.isJoined,
    required this.adminName,
    required this.onTap,
  });

  final String groupId;
  final String groupName;
  final String username;
  final String adminName;
  final bool isJoined;
  final VoidCallback onTap;

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
                  groupName[0],
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: kWhiteColor,
                  ),
                )),
            title: Text(
              groupName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kBlackColor,
              ),
            ),
            subtitle: Text(adminName),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: kprimaryColor),
              onPressed: onTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.add,
                    color: kWhiteColor,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    isJoined ? "Joined" : "Join",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kWhiteColor,
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
