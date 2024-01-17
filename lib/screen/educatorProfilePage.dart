import 'package:flutter/material.dart';
import 'package:untitled2/constants/constants.dart';
import 'package:untitled2/screen/settingPage.dart';
import '../screen/educatorEditProfile.dart';
import '../screen/systemInfo.dart'; // Import the SystemInfoPage
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import '../widget/profileMenu.dart';
import 'package:image_picker/image_picker.dart';

import '../model/educatorModel.dart';
import 'homePage.dart';

class EducatorProfilePage extends StatefulWidget {
  final String currentUserId;

  const EducatorProfilePage({required this.currentUserId, String? userId});

  @override
  _EducatorProfilePageState createState() => _EducatorProfilePageState();
}

class _EducatorProfilePageState extends State<EducatorProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Initialize FirebaseFirestore
  final FirebaseStorage _storage = FirebaseStorage.instance;




  Future<Map<String, dynamic>> _fetchEducatorData() async {
    User? educator = _auth.currentUser;

    try {
      if (educator != null) {
        DocumentSnapshot documentSnapshot =
        await _firestore.collection('educators').doc(educator.uid).get();

        if (documentSnapshot.exists) {
          Map<String, dynamic> educatorData =
          documentSnapshot.data() as Map<String, dynamic>;
          educatorData['educatorProfilePicture'] =
              educatorData['educatorProfilePicture'] ?? '';
          return educatorData;
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

        title: Center(child: Text("Educator User Profile")),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: FutureBuilder<Map<String, dynamic>>(
            future: _fetchEducatorData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                String educatorFullName = snapshot.data?['educatorFullName'] ?? '';
                String educatorName = snapshot.data?['educatorName'] ?? '';
                String educatorEmail = snapshot.data?['educatorEmail'] ?? '';
                return Column(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              snapshot.data?['educatorProfilePicture'] ?? '', // Use the profile picture URL
                              fit: BoxFit.cover,  // You can adjust the fit based on your requirements
                            ),),
                        ),
                      ],
                    ),
                    const SizedBox(height:10),
                    Text(
                      educatorFullName,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height:5),
                    Text(

                      educatorName,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height:5),
                    Text(
                      educatorEmail,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EducatorEditProfile(currentUserId: widget.currentUserId))),
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
                    ProfileMenuWidget(title: "Settings", icon: Icons.settings,
                      onPress: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingPage(currentUserId: widget.currentUserId),
                        )),),

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