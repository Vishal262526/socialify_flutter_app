import 'package:flutter/material.dart';
import 'package:socialify/utils/colors.dart';

class MessageTile extends StatelessWidget {
  final String message;
  final String senderName;
  final bool sentByMe;
  const MessageTile({
    super.key,
    required this.message,
    required this.senderName,
    required this.sentByMe,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          sentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            constraints: const BoxConstraints(
              maxWidth: 300,
              minWidth: 50,
            ),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: sentByMe ? kprimaryColor : kprimaryLightColor,
              borderRadius: sentByMe
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    )
                  : const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
            ),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  senderName,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: sentByMe ? kWhiteColor : kBlackColor,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 18,
                    color: sentByMe ? kWhiteColor : kBlackColor,
                  ),
                ),
              ],
            ))
      ],
    );
  }
}
