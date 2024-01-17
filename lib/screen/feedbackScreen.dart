import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:untitled2/Constants/Constants.dart';
import 'package:untitled2/services/databaseServices.dart';

import '../model/feedbackModel.dart';



class FeedbackScreen extends StatefulWidget {
  final String? currentUserId;

  const FeedbackScreen({required this.currentUserId});


  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  double _rating = 0; // Initial rating set to 0
  String _comment = ''; // Empty comment string
  DatabaseServices databaseServices = DatabaseServices(); // Create an instance of DatabaseServices

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Feedback',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.lightGreen[200],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0), // Padding for the entire body
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              'assets/feedback.png', // Image asset for feedback
              height: 300, // Adjusted image height
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: Text(
                  'Rate our app:', // Text prompting to rate the app
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Center(
              child: RatingBar.builder(
                initialRating: _rating, // Current rating value
                minRating: 0, // Minimum allowed rating
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5, // Total number of rating icons
                itemSize: 40.0, // Size of each rating icon
                itemBuilder: (context, _) => Icon(
                  Icons.star, // Star icon used for rating
                  color: AutiTrackColor, // Star icon color
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating; // Update the rating value
                  });
                },
              ),
            ),
            SizedBox(height: 40), // Vertical spacing
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter your comments...',
                // Placeholder text for comment input
                border: OutlineInputBorder(), // Input border
              ),
              maxLines: 5, // Allowing multiline input with maximum 5 lines
              onChanged: (value) {
                setState(() {
                  _comment = value; // Update the comment value as the user types
                });
              },
            ),
            SizedBox(height: 20), // Vertical spacing
            ElevatedButton(
              onPressed: () {
                // Create a FeedbackModel instance
                FeedbackModel feedback = FeedbackModel(
                  rating: _rating,
                  comment: _comment,
                  authorId: widget.currentUserId!,
                  timestamp: Timestamp.fromDate(DateTime.now()),
                );

                // Call the function to add feedback
                databaseServices.addFeedback(feedback);

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.lightGreen[200],
                onPrimary: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              ),
              child: Text('Submit'), // Text displayed on the button
            ),
          ],
        ),
      ),
    );
  }
}