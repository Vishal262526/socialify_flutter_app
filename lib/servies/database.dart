import 'package:cloud_firestore/cloud_firestore.dart';

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
}
