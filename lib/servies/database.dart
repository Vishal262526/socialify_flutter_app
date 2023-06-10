import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialify/helper/helper_function.dart';

class Database {
  Database({this.uid});
  final String? uid;

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

// Updating the user data
  Future<void> updateUserData(String fullName, String email) async {
    await userCollection.doc(uid).set({
      "uid": uid,
      "email": email,
      "fullName": fullName,
      "groups": [],
      "profile": "",
    });
  }

  Future<QuerySnapshot> getUserData(String email) async {
    return await userCollection.where("email", isEqualTo: email).get();
  }

  // Get the user groups
  Stream<DocumentSnapshot> getUserGroup() {
    return userCollection.doc(uid).snapshots();
    // return userCollection.orderBy("field")
    // return userCollection.orderBy("timestamp","desc").where("uid":uid).snapshots();
  }

  // Create a new Group

  Future<Map> createGroup(String groupName, String uid, String username) async {
    // Add a Detao; in a groups collections
    try {
      DocumentReference groupDocumentReference = await groupCollection.add({
        "groupName": groupName,
        "groupIcon": "",
        "admin": "${uid}_$username",
        "members": [],
        "groupId": "",
        "recentMessage": "",
        "recentMessageSender": ""
      });

      // Updating the groupid and members of groups collection after creating
      groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$username"]),
        "groupId": groupDocumentReference.id,
      });

      // Updating the users collection group detail
      DocumentReference usersDocumentReference = await userCollection.doc(uid);
      usersDocumentReference.update({
        "groups":
            FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
      });
      return {"success": true};
    } catch (e) {
      return {"success": false, "err": e.toString()};
    }
  }

  // Getting the chat of the group
  Stream<QuerySnapshot> getGroupChat(String groupId) {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time", descending: true)
        .snapshots();
  }

  Future<String> getGroupAdmin(String groupId) async {
    // DocumentReference df = groupCollection.doc(groupId);
    // DocumentSnapshot snapshot = await df.get();
    // return snapshot['admin'];
    DocumentSnapshot groupSnapShot = await groupCollection.doc(groupId).get();
    return groupSnapShot['admin'];
  }

  // Getting Group Members
  Stream<DocumentSnapshot> getGroupMembers(String groupId) {
    return groupCollection.doc(groupId).snapshots();
  }

  // Search an Particular Group
  Future<QuerySnapshot> searchGroupByName(
    String groupName,
  ) {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  // Check already have in a group or not
  Future<bool> isUserJoined(
    String groupId,
    String groupName,
    String username,
  ) async {
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot userDocSnap = await userDocRef.get();

    List groups = await userDocSnap['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  Future<Map> toggleGroupJoin(
      String groupId, String groupName, String username) async {
    // Doc ref
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentReference groupDocRef = groupCollection.doc(groupId);

    DocumentSnapshot userSnapshot = await userDocRef.get();

    List userGroups = userSnapshot['groups'];

    // if user is in the group then remove then otherwise join them
    try {
      if (userGroups.contains("${groupId}_$groupName")) {
        userDocRef.update({
          "groups": FieldValue.arrayRemove(['${groupId}_$groupName'])
        });
        await groupDocRef.update({
          "members": FieldValue.arrayRemove(["${uid}_$username"])
        });
        return {"success": true, "msg": "You are Remove from $groupName Group"};
      } else {
        userDocRef.update({
          "groups": FieldValue.arrayUnion(['${groupId}_$groupName'])
        });
        await groupDocRef.update({
          "members": FieldValue.arrayUnion(["${uid}_$username"])
        });
        return {"success": true, "msg": "You are Added in $groupName Group"};
      }
    } catch (e) {
      return {"success": false, "err": e.toString()};
    }
  }

  Future<bool> sendMessage(
      String groupId, Map<String, dynamic> chatMessageData) async {
    try {
      DocumentReference chatDoc = await groupCollection
          .doc(groupId)
          .collection('messages')
          .add(chatMessageData);
      await groupCollection.doc(groupId).update({
        "recentMessage": chatMessageData['message'],
        'recentMessageSender': chatMessageData['sender'],
        "recentMessageTime": chatMessageData['time'],
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
