import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChildInfoPage extends StatefulWidget {
  @override
  _ChildInfoPageState createState() => _ChildInfoPageState();
}

class _ChildInfoPageState extends State<ChildInfoPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Load current child information when the page is initialized
    _loadChildInfo();
  }

  void _loadChildInfo() async {
    try {
      String parentId = _auth.currentUser?.uid ?? '';
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('parents')
          .doc(parentId)
          .collection('children')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Display the information of the first child found
        DocumentSnapshot<Map<String, dynamic>> childSnapshot = querySnapshot.docs.first;
        fullNameController.text = childSnapshot['childFullName'];
        nicknameController.text = childSnapshot['childNickname'];
        ageController.text = childSnapshot['childAge'];
        genderController.text = childSnapshot['childGender'];
      }
    } catch (error) {
      print('Error loading child info: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[200],
        title: Center(child: Text('Child Information', style: TextStyle(fontSize: 32, color: Colors.black))),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildFormField('Full Name', fullNameController, 'Please enter full name'),
                SizedBox(height: 16),
                _buildFormField('Nickname', nicknameController, null),
                SizedBox(height: 16),
                _buildFormField('Age', ageController, null, keyboardType: TextInputType.number),
                SizedBox(height: 16),
                _buildFormField('Gender', genderController, null),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton('Add Child Info', Colors.blue, _createChildInfo),
                    _buildButton('Update Child Info', Colors.green, _updateChildInfo),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField(String label, TextEditingController controller, String? validationMessage,
      {TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.all(12),
      ),
      validator: (value) {
        if (validationMessage != null && (value == null || value.isEmpty)) {
          return validationMessage;
        }
        return null;
      },
      keyboardType: keyboardType,
    );
  }

  Widget _buildButton(String label, Color color, Function() onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: color,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      child: Text(label),
    );
  }

  Future<void> _createChildInfo() async {
    try {
      String fullName = fullNameController.text;
      String nickname = nicknameController.text;
      String age = ageController.text;
      String gender = genderController.text;

      // Get the current user's ID
      String parentId = _auth.currentUser?.uid ?? '';

      // Add child information under the child collection
      await _firestore
          .collection('parents')
          .doc(parentId)
          .collection('children')
          .add({
        'childFullName': fullName,
        'childNickname': nickname,
        'childAge': age,
        'childGender': gender,
      });

      // Log the creation in the system log
      await _firestore.collection('system_log').add({
        'userId': parentId,
        'action': 'Child Information Created',
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Child information created successfully'),
        ),
      );

      // Reload child information after creation
      _loadChildInfo();
    } catch (error) {
      print('Error creating child info: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating child information: $error'),
        ),
      );
    }
  }

  Future<void> _updateChildInfo() async {
    try {
      String fullName = fullNameController.text;
      String nickname = nicknameController.text;
      String age = ageController.text;
      String gender = genderController.text;

      // Get the current user's ID
      String parentId = _auth.currentUser?.uid ?? '';

      // Update child information under the child collection
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('parents')
          .doc(parentId)
          .collection('children')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Update the first child's information found
        DocumentSnapshot<Map<String, dynamic>> childSnapshot = querySnapshot.docs.first;
        String childId = childSnapshot.id;

        await _firestore
            .collection('parents')
            .doc(parentId)
            .collection('children')
            .doc(childId)
            .update({
          'childFullName': fullName,
          'childNickname': nickname,
          'childAge': age,
          'childGender': gender,
        });

        // Log the update in the system log
        await _firestore.collection('system_log').add({
          'userId': parentId,
          'action': 'Child Information Updated',
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Child information updated successfully'),
          ),
        );

        // Reload child information after update
        _loadChildInfo();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No child information found to update'),
          ),
        );
      }
    } catch (error) {
      print('Error updating child info: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating child information: $error'),
        ),
      );
    }
  }
}