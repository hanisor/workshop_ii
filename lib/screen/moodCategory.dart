import 'package:flutter/material.dart';

import '../util/moodTile.dart';
import 'moodlist.dart';

class CategoryPage extends StatelessWidget {


  // list of mood
  List MoodDetected = [
    // [mood, description, moodColor, ImageName]
    ["Anger", "Anger", Colors.blue, "lib/images/dissatisfaction.png"],
    ["Anxiety", "Anxiety", Colors.pinkAccent, "lib/images/anxiety.png"],
    ["Irritability", "Irritability", Colors.orange, "lib/images/dizziness.png"],
    ["Sad", "Sadness", Colors.yellowAccent, "lib/images/cry.png"],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[100],
        title: Center(child: Text('Autism Mood', style: TextStyle(fontSize: 32, color: Colors.black))),
        actions: [
          IconButton(
            icon: Icon(Icons.list_alt_outlined),
            onPressed: () {
              // Navigate to MoodList page when the button is pressed
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MoodList()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: MoodDetected.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1 / 1.3,
              ),
              itemBuilder: (context, index) {
                return MoodTile(
                  mood: MoodDetected[index][0],
                  description: MoodDetected[index][1],
                  moodColor: MoodDetected[index][2],
                  imageName: MoodDetected[index][3],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Autism is not a choice. However, acceptance is. Embrace the unique brilliance, celebrate the small victories, and love the extraordinary journey of those with autism.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}