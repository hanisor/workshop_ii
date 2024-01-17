import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled2/Constants/Constants.dart';

import '../controller/educatorRegistrationController.dart';
import '../model/educatorModel.dart';
import '../screen/educatorProfilePage.dart'; // Import the educator profile page

class EducatorEditProfile extends StatefulWidget {
  final String currentUserId;

  const EducatorEditProfile({required this.currentUserId});

  @override
  State<EducatorEditProfile> createState() => _EducatorEditProfileState();
}

class _EducatorEditProfileState extends State<EducatorEditProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _controller = EducatorRegistrationController();
  TextEditingController educatorNameController = TextEditingController();
  TextEditingController educatorFullNameController = TextEditingController();
  TextEditingController educatorEmailController = TextEditingController();
  TextEditingController educatorPhoneController = TextEditingController();
  TextEditingController educatorExpertiseController = TextEditingController();
  TextEditingController educatorPasswordController = TextEditingController();
  TextEditingController educatorRePasswordController = TextEditingController();

  final imagePicker = ImagePicker();
  File? _imageFile;

  bool _obscurePassword1 = true;
  bool _obscurePassword2 = true;

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
          educatorData['educatorFullName'] =
              educatorData['educatorFullName'] ?? '';
          educatorData['educatorName'] = educatorData['educatorName'] ?? '';
          educatorData['educatorExpertise'] =
              educatorData['educatorExpertise'] ?? '';
          educatorData['educatorEmail'] = educatorData['educatorEmail'] ?? '';
          educatorData['educatorPassword'] =
              educatorData['educatorPassword'] ?? '';
          educatorData['educatorRePassword'] =
              educatorData['educatorRePassword'] ?? '';
          educatorData['educatorPhoneNumber'] =
              educatorData['educatorPhoneNumber'] ?? '';
          educatorData['role'] = educatorData['role'] ?? '';
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

  Future<void> _pickImage() async {
    final XFile? pickedImage =
    await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String?> _uploadImage() async {
    if (_imageFile != null) {
      String fileName =
      DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = _storage
          .ref()
          .child('profile_images/$fileName.jpg');

      UploadTask uploadTask = reference.putFile(_imageFile!);
      TaskSnapshot storageTaskSnapshot = await uploadTask;

      String downloadURL =
      await storageTaskSnapshot.ref.getDownloadURL();
      return downloadURL;
    }
    return null;
  }

  Future<void> updateEducatorProfile() async {
    try {
      User? educator = _auth.currentUser;
      if (educator != null) {
        if (_imageFile != null) {
          String? profilePictureURL = await _uploadImage();
          await _firestore
              .collection('educators')
              .doc(educator.uid)
              .update({'educatorProfilePicture': profilePictureURL});
        }

        await _firestore.collection('educators').doc(educator.uid).update({
          'educatorName': educatorNameController.text,
          'educatorFullName': educatorFullNameController.text,
          'educatorPhoneNumber': educatorPhoneController.text,
          'educatorEmail': educatorEmailController.text,
          'educatorExpertise': educatorExpertiseController.text,
          'educatorPassword': educatorPasswordController.text,
          'educatorRePassword': educatorRePasswordController.text,
        });

        Map<String, dynamic> updatedData = await _fetchEducatorData();
        setState(() {
          educatorNameController.text = updatedData['educatorName'];
          educatorFullNameController.text = updatedData['educatorFullName'];
          educatorPhoneController.text = updatedData['educatorPhoneNumber'];
          educatorEmailController.text = updatedData['educatorEmail'];
          educatorExpertiseController.text =
          updatedData['educatorExpertise'];
          educatorPasswordController.text =
          updatedData['educatorPassword'];
          educatorRePasswordController.text =
          updatedData['educatorRePassword'];
        });

        print('Profile updated successfully!');
      }
    } catch (error) {
      print('Error updating profile: $error');
    }
  }

  /*Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Confirmation'),
          content: Text('Do you want to update the profile?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await updateEducatorProfile();
                Navigator.of(context).pop(); // Dismiss the dialog
                // Navigate back to the EducatorProfilePage
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: AutiTrackColor2,
        title: Center(
          child: Text(
            "Educator Update Profile",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: FutureBuilder<Map<String, dynamic>>(
            future: _fetchEducatorData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                String educatorName = snapshot.data?['educatorName'] ?? '';
                String educatorFullName =
                    snapshot.data?['educatorFullName'] ?? '';
                String educatorEmail = snapshot.data?['educatorEmail'] ?? '';
                String educatorExpertise =
                    snapshot.data?['educatorExpertise'] ?? '';
                String educatorPhoneNumber =
                    snapshot.data?['educatorPhoneNumber'] ?? '';
                String educatorPassword =
                    snapshot.data?['educatorPassword'] ?? '';
                String educatorRePassword =
                    snapshot.data?['educatorRePassword'] ?? '';
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
                              snapshot.data?['educatorProfilePicture'] ?? '',
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.amberAccent),
                            child: IconButton(
                              icon: Icon(Icons.add_photo_alternate),
                              onPressed: _pickImage,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Form(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 2, color: Colors.black),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            prefixIcon: const Icon(Icons.person_outline),
                            hintText: educatorFullName,
                          ),
                          controller: educatorFullNameController,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 2, color: Colors.black),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            prefixIcon: const Icon(Icons.person_outline),
                            hintText: educatorName),
                        controller: educatorNameController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2, color: Colors.black),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          prefixIcon: const Icon(Icons.phone_iphone_outlined),
                          hintText: educatorPhoneNumber,
                        ),
                        keyboardType: TextInputType.phone,
                        controller: educatorPhoneController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2, color: Colors.black),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          prefixIcon: const Icon(Icons.email_outlined),
                          hintText: educatorEmail,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        controller: educatorEmailController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 2, color: Colors.black),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            prefixIcon: const Icon(Icons.person_outline),
                            hintText: educatorExpertise),
                        controller: educatorExpertiseController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        obscureText: _obscurePassword2,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2, color: Colors.black),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          prefixIcon: const Icon(Icons.password_outlined),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword2 = !_obscurePassword2;
                              });
                            },
                            icon: _obscurePassword2
                                ? const Icon(
                                Icons.visibility_off_outlined)
                                : const Icon(Icons.visibility_outlined),
                          ),
                          hintText: "Enter your new password",
                        ),
                        controller: educatorPasswordController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        obscureText: _obscurePassword1,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2, color: Colors.black),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          prefixIcon: const Icon(Icons.password_outlined),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword1 = !_obscurePassword1;
                              });
                            },
                            icon: _obscurePassword1
                                ? Icon(Icons.visibility_off_outlined)
                                : Icon(Icons.visibility_outlined),
                          ),
                          hintText: "Re-enter your new password",
                        ),
                        controller: educatorRePasswordController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            //_showConfirmationDialog();
                            updateEducatorProfile();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amberAccent,
                            side: BorderSide.none,
                            shape: const StadiumBorder(),
                          ),
                          child: Text("Save Profile",
                              style: TextStyle(color: Colors.teal)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
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