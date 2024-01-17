import 'package:flutter/material.dart';
import 'package:untitled2/screen/moodStatistics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MoodList extends StatefulWidget {
  const MoodList({Key? key}) : super(key: key);

  @override
  State<MoodList> createState() => _MoodListState();
}

class _MoodListState extends State<MoodList> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[100],
        title: const Center(
          child: Text(
            'Mood List',
            style: TextStyle(
              fontSize: 32,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.show_chart),
            onPressed: () {
              // Navigate to the mood statistics page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MoodStats(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Your mood records are displayed below. Tap on a record to view details.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('mood')
                  .where('userId', isEqualTo: _auth.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                var moodDocs = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: moodDocs.length,
                  itemBuilder: (context, index) {
                    var moodData = moodDocs[index].data() as Map<String, dynamic>;
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        title: Text(
                          'Behavior: ${moodData['behavior']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text('Trigger: ${moodData['trigger']}'),
                        onTap: () {
                          // Show detailed information in a dialog
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Mood Details'),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  buildDetailRow('Behavior', moodData['behavior']),
                                  buildDetailRow('Trigger', moodData['trigger']),
                                  buildDetailRow('Date', moodData['date']),
                                  buildDetailRow('Place', moodData['place']),
                                  buildDetailRow('Symptom Before', moodData['symptomBefore']),
                                  buildDetailRow('Symptom After', moodData['symptomAfter']),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Close'),
                                ),
                              ],
                            ),
                          );
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // Show confirmation dialog before deleting
                            showDeleteConfirmationDialog(moodDocs[index].reference);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _hardDeleteMood(DocumentReference reference) {
    // Perform your hard delete logic here
    reference.delete();
  }

  void showDeleteConfirmationDialog(DocumentReference reference) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this mood record?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the confirmation dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Perform hard delete if confirmed
              _hardDeleteMood(reference);
              Navigator.pop(context); // Close the confirmation dialog
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}