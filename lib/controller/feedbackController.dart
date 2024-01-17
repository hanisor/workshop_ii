import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackController {
  final CollectionReference feedbackCollection =
  FirebaseFirestore.instance.collection("feedback");

  Future<void> addFeedback(
      double rating, String comment, String authorId) async {
    try {
      print('Adding feedback...');
      await feedbackCollection.add({
        'rating': rating,
        'comment': comment,
        'timestamp': FieldValue.serverTimestamp(),
        'authorId': authorId, // Include author ID in the feedback data
      });
      print('Feedback added successfully!');
    } catch (error) {
      print('Error adding feedback: $error');
      // Handle error
    }
  }
}