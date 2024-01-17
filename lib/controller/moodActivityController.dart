import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../model/moodModel.dart';

class MoodActivityController {
  final CollectionReference moodCollection =
  FirebaseFirestore.instance.collection("mood");

  Future<void> addMood(BuildContext context, MoodModel mood) async {
    try {
      await moodCollection.add({
        'behaviorOccur': mood.behaviorOccur,
        'date': mood.date,
        'place': mood.place,
        'symptomBefore': mood.symptomBefore,
        'symptomAfter': mood.symptomAfter,
      });

      // Optionally, you can show a success message or perform other actions.
    } catch (error) {
      print('Error adding mood: $error');
      // Handle the error, e.g., show an error message.
    }
  }

// Add other methods as needed for fetching or updating mood data.
}