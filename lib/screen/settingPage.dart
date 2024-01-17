import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/Constants/Constants.dart';
import 'package:untitled2/screen/HomePage.dart';
import 'package:untitled2/screen/feedbackScreen.dart';
import 'package:untitled2/services/databaseServices.dart';

class SettingPage extends StatelessWidget {
  final String? currentUserId;

  const SettingPage({required this.currentUserId});

  void handleLogout(BuildContext context) async {
    bool? confirmLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Logout"),
          content: Text("Are you sure you want to log out?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(false); // User canceled
              },
            ),
            TextButton(
              child: Text("Confirm"),
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed
              },
            ),
          ],
        );
      },
    );

    if (confirmLogout != null && confirmLogout) {
      try {
        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> handleDeactivateAccount(BuildContext context) async {
    bool? confirmDeactivation =   await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deactivation"),
          content: Text("Are you sure you want to deactivate your account?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(false); // User canceled
              },
            ),
            TextButton(
              child: Text("Confirm"),
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed
              },
            ),
          ],
        );
      },
    );
    if (confirmDeactivation != null && confirmDeactivation) {
      // User confirmed, perform account deactivation
      DatabaseServices databaseServices = DatabaseServices();
      await databaseServices.softDeleteUser(currentUserId);

      // Redirect to login or home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        centerTitle: true,
        title: Text('Settings'),
        backgroundColor: AutiTrackColor2, // Set app bar color to green
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              child: Text('Feedback and Info',
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AutiTrackColor2, // Set button color to green
              ), onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FeedbackScreen(currentUserId: currentUserId)
                  )
              );
            },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Logout', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AutiTrackColor2,
              ),
              onPressed: () {
                handleLogout(context);
              },
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                handleDeactivateAccount(context);
              },
              child: Text(
                'Deactivate Account',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AutiTrackColor2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
