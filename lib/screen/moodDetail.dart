import 'package:flutter/material.dart';

import '../controller/moodActivityController.dart';
import 'moodPage.dart';

class MoodDetailsPage extends StatelessWidget {
  final Map<String, String> moodData;
  final String selectedBehavior;
  final _controller = MoodActivityController();

  MoodDetailsPage({required this.moodData, required this.selectedBehavior});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[100],
        title: Center(
          child: Text(
            'Mood Details',
            style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 1),
            Text(
              'Selected Behavior: $selectedBehavior',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildDetailText('Date', moodData['date']),
            const SizedBox(height: 10),
            _buildDetailText('Place', moodData['place']),
            const SizedBox(height: 10),
            _buildDetailText('Symptom Before', moodData['Symptom before']),
            const SizedBox(height: 10),
            _buildDetailText('Symptom After', moodData['Symptom after']),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the mood page
                Navigator.pop(context,
                    MaterialPageRoute(
                        builder: (context) => MoodPage(currentUserId: '',)));
              },
              child: Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailText(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        '$label: ${value ?? "N/A"}',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}