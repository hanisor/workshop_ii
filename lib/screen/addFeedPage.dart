import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled2/model/educatorModel.dart';
import '../constants/constants.dart';
import '../model/feedModel.dart';
import '../model/parentModel.dart';
import '../services/databaseServices.dart';
import '../services/storageServices.dart';
import '../widget/roundedButton.dart';
import 'package:permission_handler/permission_handler.dart';

class AddFeedPage extends StatefulWidget {
  final String? currentUserId;

  const AddFeedPage({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _AddFeedPageState createState() => _AddFeedPageState();
}

class _AddFeedPageState extends State<AddFeedPage> {
  String _feedText = '';
  File? _pickedImage;
  bool _loading = false;
  ParentModel? _parent;
  EducatorModel? _educator;
  dynamic _user;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> handleImageFromGallery() async {
    try {
      final PermissionStatus permissionStatus = await _requestPermission();
      if (permissionStatus == PermissionStatus.granted) {
        final ImagePicker _picker = ImagePicker();
        XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
        if (pickedImage != null) {
          setState(() {
            _pickedImage = File(pickedImage.path);
          });
        }
      } else {
        // Handle the case when permission is not granted
      }
    } catch (e) {
      print(e);
    }
  }

  Future<PermissionStatus> _requestPermission() async {
    final PermissionStatus permissionStatus = await Permission.storage.status;
    if (permissionStatus != PermissionStatus.granted) {
      final PermissionStatus result = await Permission.storage.request();
      return result;
    } else {
      return permissionStatus;
    }
  }

  Future<void> fetchUserData() async {
    bool isEducatorUser = await isEducator(widget.currentUserId);

    if (isEducatorUser) {
      await fetchEducatorModel();
      _user = _educator;
    } else {
      await fetchParentModel();
      _user = _parent;
    }
  }

  Future<bool> isEducator(String? userId) async {
    try {
      if (userId != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('educators')
            .doc(userId)
            .get();

        if (userSnapshot.exists) {
          String? role = userSnapshot['role'];
          return role == 'educator';
        }
      }
    } catch (e) {
      print('Error determining user type: $e');
    }

    return false;
  }

  Future<void> fetchParentModel() async {
    ParentModel? parent = await getParentFromFirestore(widget.currentUserId);

    if (parent != null) {
      setState(() {
        _parent = parent;
      });
    }
  }

  Future<ParentModel?> getParentFromFirestore(String? parentId) async {
    try {
      DocumentSnapshot parentSnapshot = await FirebaseFirestore.instance
          .collection('parents')
          .doc(parentId)
          .get();

      if (parentSnapshot.exists) {
        return ParentModel.fromDoc(parentSnapshot);
      } else {
        print('Document for parentId: $parentId does not exist');
        return null;
      }
    } catch (e) {
      print('Error fetching parent from Firestore: $e');
      return null;
    }
  }

  Future<void> fetchEducatorModel() async {
    EducatorModel? edu = await getEducatorFromFirestore(widget.currentUserId);

    if (edu != null) {
      setState(() {
        _educator = edu;
      });
    }
  }

  Future<EducatorModel?> getEducatorFromFirestore(String? educatorId) async {
    try {
      DocumentSnapshot educatorSnapshot = await FirebaseFirestore.instance
          .collection('educators')
          .doc(educatorId)
          .get();

      if (educatorSnapshot.exists) {
        return EducatorModel.fromDoc(educatorSnapshot);
      } else {
        print('Document for educatorId: $educatorId does not exist');
        return null;
      }
    } catch (e) {
      print('Error fetching educator from Firestore: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AutiTrackColor,
        centerTitle: true,
        title: Text(
          'Feed',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 20),
              TextField(
                maxLength: 280,
                maxLines: 7,
                decoration: InputDecoration(
                  hintText: 'What is on your mind?',
                ),
                onChanged: (value) {
                  _feedText = value;
                },
              ),
              SizedBox(height: 10),
              _pickedImage == null
                  ? SizedBox.shrink()
                  : Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: AutiTrackColor,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(_pickedImage!),
                      ),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: handleImageFromGallery,
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    border: Border.all(
                      color: AutiTrackColor,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 50,
                    color: AutiTrackColor,
                  ),
                ),
              ),
              SizedBox(height: 20),
              RoundedButton(
                btnText: 'Post',
                onBtnPressed: () async {
                  if (_feedText.isNotEmpty && _user != null) {
                    setState(() {
                      _loading = true;
                    });

                    String imageUrl = '';

                    try {
                      if (_pickedImage != null) {
                        imageUrl = await StorageService.uploadFeedPicture(_pickedImage!);
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to upload image. Please try again.'),
                        ),
                      );
                      print('Image upload error: $e');
                    }

                    Feed feed = Feed(
                      text: _feedText,
                      image: imageUrl,
                      likes: 0,
                      timestamp: Timestamp.fromDate(DateTime.now()),
                      authorId: widget.currentUserId,
                      id: '', // Ensure to assign a valid ID for the feed
                    );

                    try {
                      await DatabaseServices.createFeed(feed);
                      Navigator.pop(context);
                    } catch (e) {
                      print('Feed creation error: $e');
                      // Handle feed creation error
                    }

                    setState(() {
                      _loading = false;
                    });
                  }
                },
              ),

              SizedBox(height: 20),
              _loading ? CircularProgressIndicator() : SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
