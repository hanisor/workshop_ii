import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:untitled2/screen/HomePage.dart';
import 'package:untitled2/screen/graph.dart';
import 'package:untitled2/screen/mainFeedPageEdu.dart';
import 'package:untitled2/screen/mainFeedPageParent.dart';
import 'package:untitled2/screen/mainScreen.dart';
import 'package:untitled2/screen/mainScreenEdu.dart';
// import 'package:untitled2/screen/mainScreenEdu.dart';
import 'package:untitled2/screen/moodPage.dart';
import 'firebase_options.dart';

import 'messages/homeScreenEdu.dart';
import 'messages/homeScreenParent.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );

  // Get the current user ID
  String? currentUserId = await getCurrentUserId();

  runApp(MyApp(currentUserId: currentUserId));
}

Future<String?> getCurrentUserId() async {
  // Check if a user is already signed in
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    // If a user is signed in, return the UID
    return user.uid;
  } else {
    // If no user is signed in, you can handle this case as needed
    // For example, you can sign in the user or return null
    // depending on your application's logic.
    return null;
  }
}

class MyApp extends StatelessWidget {
  final String? currentUserId;

  MyApp({required this.currentUserId, super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      title: 'AutiTrack',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: HomePage(),
      routes: {
        '/mainScreen': (context) => MainScreen(currentUserId: currentUserId),
        '/mainScreenEdu': (context) => MainScreenEdu(currentUserId: currentUserId),
        '/feedEdu': (context) => MainFeedPageEdu(currentUserId: currentUserId),
        '/feedParent': (context) => MainFeedPageParent(currentUserId: currentUserId),
        '/message': (context) => HomeScreen(currentUserId: currentUserId),
        '/messages': (context) => HomeScreenEdu(currentUserId: currentUserId),
        '/graph': (context) => ThingSpeakGraph(),
        '/activity': (context) => MoodPage(currentUserId: currentUserId),
        // Add other routes as needed
      },
    );
  }
}