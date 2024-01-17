import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/model/educatorModel.dart';
import '../Constants/Constants.dart';
import '../model/feedModel.dart';
import '../model/feedbackModel.dart';
import '../model/parentModel.dart';


class DatabaseServices {

  final CollectionReference _feedCollection = FirebaseFirestore.instance.collection('feeds');
  final firestoreInstance = FirebaseFirestore.instance;

  static createFeed(Feed feed) {
    feedRefs.doc(feed.authorId).set({'FeedTime': feed.timestamp});
    feedRefs.doc(feed.authorId).collection('userFeeds').add({
      'text': feed.text,
      'image': feed.image,
      "authorId": feed.authorId,
      "timestamp": feed.timestamp,
      'likes': feed.likes,
    });
  }

  static Future<List<Feed>> getUserFeeds(String? userId) async {
    QuerySnapshot userFeedsSnap = await feedRefs
        .doc(userId)
        .collection('userFeeds')
        .orderBy('timestamp', descending: true)
        .get();
    List<Feed> userFeeds =
    userFeedsSnap.docs.map((doc) => Feed.fromDoc(doc)).toList();

    return userFeeds;
  }

  static Future<List<Feed>> retrieveSubFeeds() async {
    List<Feed> feeds = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collectionGroup("userFeeds")  // Use collectionGroup to query across all users
          .orderBy('timestamp', descending: true)
          .get();

      feeds = querySnapshot.docs
          .map((doc) => Feed.fromDoc(doc))
          .toList();
    } catch (e) {
      print("Error retrieving sub feeds: $e");
    }

    return feeds;
  }

  Future<ParentModel?> fetchParentDetails(String? currentUserId) async {
    if (currentUserId != null) {
      try {
        // Replace 'parentCollection' with your actual Firestore collection name
        DocumentSnapshot parentSnapshot = await firestoreInstance.collection('parents').doc(currentUserId).get();

        if (parentSnapshot.exists) {
          // Assuming ParentModel.fromSnapshot is a factory method in ParentModel class
          return ParentModel.fromDoc(parentSnapshot);

        }
      } catch (e) {
        print('Error fetching parent details: $e');
      }
    }
    return null; // Return null if no details found or if currentUserId is null
  }


  Future<EducatorModel?> fetchEducatorDetails(String? currentUserId) async {
    if (currentUserId != null) {
      try {
        // Replace 'parentCollection' with your actual Firestore collection name
        DocumentSnapshot educatorSnapshot = await firestoreInstance.collection('educators').doc(currentUserId).get();

        if (educatorSnapshot.exists) {
          // Assuming ParentModel.fromSnapshot is a factory method in ParentModel class
          print('fetching educator details: $educatorSnapshot');
          return EducatorModel.fromDoc(educatorSnapshot);

        }
      } catch (e) {
        print('Error fetching educator details: $e');
      }
    }
    return null; // Return null if no details found or if currentUserId is null
  }


  Future<List<Feed>> getFeedById() async {
    var userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return [];
    }

    var querySnapshot = await _feedCollection.where('userId', isEqualTo: userId).get();
    return querySnapshot.docs.map((doc) => Feed.fromDoc(doc.data() as DocumentSnapshot<Object?>)).toList();
  }

  Future<List<Feed>> fetchAllFeeds() async {
    // Fetch all documents from the 'feeds' collection
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('feeds').get();

    // Process the documents and convert them into Feed objects
    List<Feed> feeds = querySnapshot.docs.map((doc) {
      return Feed.fromDoc(doc); // Convert the document data into a Feed object
    }).toList();

    return feeds;
  }

  static void deleteFeedFromUserFeeds(String feedId, String authorId) {
    feedRefs
        .doc(authorId)
        .collection('userFeeds')
        .doc(feedId)
        .delete()
        .then((value) {
      print('Feed deleted successfully from userFeeds');
    })
        .catchError((error) {
      print('Failed to delete feed from userFeeds: $error');
    });
  }

  Future<void> softDeleteUser(String? userId) async {
    try {
      // Check if the user exists in the 'parents' collection
      DocumentSnapshot parentSnapshot = await FirebaseFirestore.instance
          .collection('parents')
          .doc(userId)
          .get();

      // Check if the user exists in the 'educators' collection
      DocumentSnapshot educatorSnapshot = await FirebaseFirestore.instance
          .collection('educators')
          .doc(userId)
          .get();

      // Perform soft delete based on existence in either collection
      if (parentSnapshot.exists) {
        // User exists in the 'parents' collection, perform soft delete
        await FirebaseFirestore.instance
            .collection('parents')
            .doc(userId)
            .update({'status': 'Deactivate'});
      } else if (educatorSnapshot.exists) {
        // User exists in the 'educators' collection, perform soft delete
        await FirebaseFirestore.instance
            .collection('educators')
            .doc(userId)
            .update({'status': 'Deactivate'});
      } else {
        // Handle the case where the user is not found in either collection
        print('User not found in both parents and educators collections');
      }
    } catch (e) {
      print("Error soft delete: $e");
    }
  }

  Future<void> reactivateAccount(String? userId) async {
    try {
      // Check if the user exists in the 'parents' collection
      DocumentSnapshot parentSnapshot = await FirebaseFirestore.instance
          .collection('parents')
          .doc(userId)
          .get();

      // Check if the user exists in the 'educators' collection
      DocumentSnapshot educatorSnapshot = await FirebaseFirestore.instance
          .collection('educators')
          .doc(userId)
          .get();

      // Log user details
      print('User ID: $userId');
      print('Parent Snapshot: ${parentSnapshot.exists}');
      print('Educator Snapshot: ${educatorSnapshot.exists}');

      // Perform soft delete based on existence in either collection
      if (parentSnapshot.exists) {
        // User exists in the 'parents' collection, perform soft delete
        await FirebaseFirestore.instance
            .collection('parents')
            .doc(userId)
            .update({'status': 'Active'});

        // Log success message
        print('User status updated to Active in parents collection');
      } else if (educatorSnapshot.exists) {
        // User exists in the 'educators' collection, perform soft delete
        await FirebaseFirestore.instance
            .collection('educators')
            .doc(userId)
            .update({'status': 'Active'});

        // Log success message
        print('User status updated to Active in educators collection');
      } else {
        // Handle the case where the user is not found in either collection
        print('User not found in both parents and educators collections');
      }
    } catch (e) {
      // Log error message
      print("Error reactivate account: $e");
    }
  }


  static void likeFeed(String? currentUserId, Feed feed) {
    DocumentReference feedDocProfile =
    feedRefs.doc(feed.authorId).collection('userFeeds').doc(feed.id);
    feedDocProfile.get().then((doc) {
      if (doc.exists) {
        Map<String, dynamic>? data = doc.data() as Map<String,
            dynamic>?; // Explicit casting
        if (data != null) {
          int? likes = data['likes'] as int?;
          if (likes != null) {
            feedDocProfile.update({'likes': likes + 1});
          }
        }
      }
    });

    DocumentReference feedDocFeed =
    feedRefs.doc(currentUserId).collection('userFeeds').doc(feed.id);
    feedDocFeed.get().then((doc) {
      if (doc.exists) {
        Map<String, dynamic>? data = doc.data() as Map<String,
            dynamic>?; // Explicit casting
        if (data != null) {
          int? likes = data['likes'] as int?;
          if (likes != null) {
            feedDocFeed.update({'likes': likes + 1});
          }
        }
      }
    });

    likesRef.doc(feed.id).collection('feedLikes').doc(currentUserId).set({});
  }


  static void unlikeFeed(String? currentUserId, Feed feed) {
    DocumentReference feedDocProfile =
    feedRefs.doc(feed.authorId).collection('userFeeds').doc(feed.id);
    feedDocProfile.get().then((doc) {
      if (doc.exists) {
        var data = doc.data();
        if (data is Map<String, dynamic>) {
          int? likes = data['likes']; // Null-aware operator used
          if (likes != null) {
            feedDocProfile.update({'likes': likes - 1});
          }
        }
      }
    });

    DocumentReference feedDocFeed =
    feedRefs.doc(currentUserId).collection('userFeed').doc(feed.id);
    feedDocFeed.get().then((doc) {
      if (doc.exists) {
        var data = doc.data();
        if (data is Map<String, dynamic>) {
          int? likes = data['likes']; // Null-aware operator used
          if (likes != null) {
            feedDocFeed.update({'likes': likes - 1});
          }
        }
      }
    });

    likesRef
        .doc(feed.id)
        .collection('likes')
        .doc(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }


  static Future<bool> isLikeFeed(String? currentUserId, Feed feed) async {
    DocumentSnapshot userDoc = await likesRef
        .doc(feed.id)
        .collection('likes')
        .doc(currentUserId)
        .get();

    return userDoc.exists;
  }

  Future<void> addFeedback(FeedbackModel feedback) async {
    try {
      await firestoreInstance.collection('feedback').add({
        'authorId': feedback.authorId, // Include the author ID
        'rating': feedback.rating,
        'comment': feedback.comment,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (error) {
      print('Error adding feedback: $error');
      // Handle error
    }
  }

}