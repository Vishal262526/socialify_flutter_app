import 'package:flutter/material.dart';

import '../utils/colors.dart';

class GroupTile extends StatelessWidget {
  const GroupTile({
    super.key,
    required this.groupName,
    required this.groupId,
    required this.subTitle,
  });

  final String groupId;
  final String groupName;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
      subtitle: Text(
        subTitle,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
    );
  }
}
