import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/screen/mainFeedPageParent.dart';
import 'package:untitled2/screen/reactivateAccount.dart';
import '../model/parentModel.dart';
import '../screen/mainScreen.dart';

class ParentLoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? uid = FirebaseAuth.instance.currentUser?.uid;

  Future<UserCredential?> login(BuildContext context,
      ParentModel parent) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: parent.parentEmail,
        password: parent.parentPassword,
      );

      if (userCredential.user != null) {
        // Update the uid variable with the current user's UID
        uid = userCredential.user?.uid;

        // Get the user's status from Firestore using ParentModel.fromDoc
        ParentModel userModel = ParentModel.fromDoc(
            await getUserDoc(userCredential.user?.uid));        // Get the user's status from Firestore using ParentModel.fromDoc
        print('id from Firebase: ${userModel.id}');
        print('Status from Firebase: ${userModel.status}');
        if (userModel.status == "Active") {
          // If status is 1, proceed to the main screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainFeedPageParent(currentUserId: uid),
            ),
          );
        } else {
          // If status is 0, show a dialog indicating that the account has been deactivated
          _showDeactivatedAccountDialog(context);
          // Sign out the user since the account is deactivated
          _auth.signOut();
        }
      }
      return userCredential;
    } on FirebaseAuthException catch (ex) {
      _showLoginFailedDialog(context);
      print('FirebaseAuthException: ${ex.message}');
      return null;
    }
  }

  Future<DocumentSnapshot> getUserDoc(String? userId) async {
    // Retrieve the user document from Firestore
    return await FirebaseFirestore.instance
        .collection('parents')
        .doc(userId)
        .get();
  }

  void _showLoginFailedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Login Failed'),
          content: const Text('Invalid username or password.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeactivatedAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Account Deactivated'),
          content: const Text(
              'This account has been deactivated. Do you want to reactivate it?'),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReactivateScreen(currentUserId: uid),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}