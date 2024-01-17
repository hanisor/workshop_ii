import 'package:untitled2/Constants/Constants.dart';

import '../screen/homePage.dart';
import 'package:flutter/material.dart';

import '../screen/parentEditProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screen/systemInfo.dart'; // Import the SystemInfoPage
import 'package:get/get.dart';
import '../widget/profileMenu.dart';

import 'childInfo.dart';

class ParentProfilePage extends StatefulWidget {
  final String currentUserId;

  const ParentProfilePage({required this.currentUserId, String? userId});

  @override
  _ParentProfilePageState createState() => _ParentProfilePageState();
}

class _ParentProfilePageState extends State<ParentProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> _fetchParentData() async {
    User? parent = _auth.currentUser;

    try {
      if (parent != null) {
        DocumentSnapshot documentSnapshot =
        await _firestore.collection('parents').doc(parent.uid).get();

        if (documentSnapshot.exists) {
          Map<String, dynamic> parentData =
          documentSnapshot.data() as Map<String, dynamic>;
          parentData['parentProfilePicture'] =
              parentData['parentProfilePicture'] ?? '';
          return parentData;
        } else {
          print('Document does not exist');
        }
      }
    } catch (e) {
      print('Error retrieving data: $e');
    }

    return {};
  }
  // Function to show logout confirmation dialog
  Future<void> _showLogoutConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout Confirmation'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _logout(); // Call the logout function if confirmed
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage())); // Close the dialog
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }
  // Function to perform logout
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Redirect to the login page after logout
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    } catch (error) {
      print('Error during logout: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: AutiTrackColor2,

        title: Center(child: Text("Parent User Profile")),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: FutureBuilder<Map<String, dynamic>>(
            future: _fetchParentData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                String parentFullName = snapshot.data?['parentFullName'] ?? '';
                String parentName = snapshot.data?['parentName'] ?? '';
                String parentEmail = snapshot.data?['parentEmail'] ?? '';
                return Column(
                  children: [
                    Stack(
                      children: [
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(80),
                              child: Image.network(

                                snapshot.data?['parentProfilePicture'] ?? '', // Use the profile picture URL
                                fit: BoxFit.cover,  // You can adjust the fit based on your requirements

                              ),
                            ),
                          ),

                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      parentFullName,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      parentName,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      parentEmail,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ParentEditProfile(currentUserId: widget.currentUserId))),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amberAccent,
                          side: BorderSide.none,
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          "Edit Profile",
                          style: TextStyle(color: Colors.teal),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Divider(color: Colors.green),

                    // MENU
                    ProfileMenuWidget(
                        title: "Settings", icon: Icons.settings, onPress: () {}),

                    const Divider(color: Colors.green),
                    const SizedBox(height: 10),
                    ProfileMenuWidget(
                      title: "System Information",
                      icon: Icons.info,
                      onPress: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SystemInfo(),
                          )),
                    ),
                    const Divider(color: Colors.green),
                    ProfileMenuWidget(
                      title: "Child Information",
                      icon: Icons.child_care,
                      onPress: () {
                        // Navigate to the Child Information page
                        // Replace ChildInfoPage with the actual page for displaying child information
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => ChildInfoPage(),
                        ));
                      },
                    ),
                    const Divider(color: Colors.green),
                    ProfileMenuWidget(
                      title: "Logout",
                      icon: Icons.logout,
                      textColor: Colors.red,
                      endIcon: false,
                      onPress: _showLogoutConfirmationDialog, // Show confirmation dialog when pressed
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}