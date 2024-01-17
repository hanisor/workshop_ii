import 'package:flutter/material.dart';
//import 'package:get/get.dart';

class SystemInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        backgroundColor: Colors.green,

        title: Center(child: Text('AutiTrack System Information')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'App Name: AutiTrack',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Version: 1.0.0',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Description:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'AutiTrack is designed to track and analyze the behavior of children with special needs, particularly those prone to hyperactivity or tantrums. The app helps parents and caregivers monitor and record the movements and activity patterns of these children in different situations.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Key Features:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  '- Track and analyze behavior patterns.',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '- Monitor and record movements and activities.',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '- Identify triggers for hyperactivity or tantrums.',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '- Analyze reactions to various stimuli and situations.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'To Educate Parents:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'AutiTrack aims to educate parents who may not have experience with children with special needs. By providing insights into behavior, triggers, and reactions, the app empowers parents to understand and support their children better.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Developer: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'BITS Software Developer',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Contact:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Email: b032110405@student.utem.edu.my ',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Email: b032110348@student.utem.edu.my ',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Email: b032110192@student.utem.edu.my ',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Email: b032220043@student.utem.edu.my ',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}