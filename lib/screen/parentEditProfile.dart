import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/constants.dart';
import '../controller/parentRegistrationController.dart';
import '../model/parentModel.dart';

class ParentEditProfile extends StatefulWidget {
  final String currentUserId;

  const ParentEditProfile({required this.currentUserId});
  @override
  State<ParentEditProfile> createState() => _ParentEditProfileState();
}

class _ParentEditProfileState extends State<ParentEditProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _controller = ParentRegistrationController();
  TextEditingController parentNameController = TextEditingController();
  TextEditingController parentFullNameController = TextEditingController();
  TextEditingController parentEmailController = TextEditingController();
  TextEditingController parentPhoneController = TextEditingController();
  TextEditingController parentPasswordController = TextEditingController();
  TextEditingController parentRePasswordController = TextEditingController();
  File? _imageFile;
  final imagePicker = ImagePicker();
  bool _obscurePassword1 = true;
  bool _obscurePassword2 = true;

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
          parentData['parentName'] = parentData['parentName'] ?? '';
          parentData['parentFullName'] = parentData['parentFullName'] ?? '';
          parentData['parentPassword'] = parentData['parentPassword'] ?? '';
          parentData['parentRePassword'] =
              parentData['parentRePassword'] ?? '';
          parentData['parentPhoneNumber'] =
              parentData['parentPhoneNumber'] ?? '';
          parentData['role'] = parentData['role'] ?? '';
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

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage =
    await _picker.pickImage(source: ImageSource.gallery);

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
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = FirebaseStorage.instance
          .ref()
          .child('profile_images/$fileName.jpg');

      UploadTask uploadTask = reference.putFile(_imageFile!);
      TaskSnapshot storageTaskSnapshot = await uploadTask;

      String downloadURL = await storageTaskSnapshot.ref.getDownloadURL();
      return downloadURL;
    }
    return null;
  }

  // Method to update the parent profile
  Future<void> updateParentProfile() async {
    try {
      User? parent = _auth.currentUser;
      if (parent != null) {
        // Update the profile picture if a new image is selected
        if (_imageFile != null) {
          String? profilePictureURL = await _uploadImage();
          await _firestore
              .collection('parents')
              .doc(parent.uid)
              .update({'parentProfilePicture': profilePictureURL});
        }

        // Update other profile information
        await _firestore.collection('parents').doc(parent.uid).update({
          'parentName': parentNameController.text,
          'parentFullName': parentFullNameController.text,
          'parentPhoneNumber': parentPhoneController.text,
          'parentEmail': parentEmailController.text,
          'parentPassword': parentPasswordController.text,
          'parentRePassword': parentRePasswordController.text,
        });

        // Fetch updated data for the UI
        Map<String, dynamic> updatedData = await _fetchParentData();
        setState(() {
          // Update UI with the fetched data
          parentNameController.text = updatedData['parentName'];
          parentFullNameController.text = updatedData['parentFullName'];
          parentPhoneController.text = updatedData['parentPhoneNumber'];
          parentEmailController.text = updatedData['parentEmail'];
          parentPasswordController.text = updatedData['parentPassword'];
          parentRePasswordController.text = updatedData['parentRePassword'];
        });

        // Show success message or navigate to a different screen
        print('Profile updated successfully!');
      }
    } catch (error) {
      print('Error updating profile: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green[50],
        appBar: AppBar(
          backgroundColor: AutiTrackColor2,

          title: Center(
              child: Text("Parent Update Profile",
                  style: Theme.of(context).textTheme.headlineLarge)),
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
                      String parentName = snapshot.data?['parentName'] ?? '';
                      String parentFullName = snapshot.data?['parentFullName'] ?? '';
                      String parentEmail = snapshot.data?['parentEmail'] ?? '';
                      String parentPhoneNumber =
                          snapshot.data?['parentPhoneNumber'] ?? '';
                      String parentPassword = snapshot.data?['parentPassword'] ?? '';
                      String parentRePassword =
                          snapshot.data?['parentRePassword'] ?? '';
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
                                    snapshot.data?['parentProfilePicture'] ?? '',
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
                                    color: Colors.amberAccent,
                                  ),
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
                                  hintText: parentFullName,
                                ),
                                controller: parentFullNameController,
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
                                hintText: parentName,
                              ),
                              controller: parentNameController,
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
                                hintText: parentPhoneNumber,
                              ),
                              keyboardType: TextInputType.phone,
                              controller: parentPhoneController,
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
                                hintText: parentEmail,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              controller: parentEmailController,
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
                                      ? const Icon(Icons.visibility_off_outlined)
                                      : const Icon(Icons.visibility_outlined),
                                ),
                                hintText: "Enter New Password",
                              ),
                              controller: parentPasswordController,
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
                                      ? const Icon(Icons.visibility_off_outlined)
                                      : const Icon(Icons.visibility_outlined),
                                ),
                                hintText: "Enter New RePassword",
                              ),
                              controller: parentRePasswordController,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Call the updateProfile method here
                                  updateParentProfile();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amberAccent,
                                  side: BorderSide.none,
                                  shape: const StadiumBorder(),
                                ),
                                child: Text(
                                  "Save Profile",
                                  style: TextStyle(color: Colors.teal),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                        ],
                      );
                    }
                  }),
            )));
  }
}