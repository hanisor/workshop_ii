import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/model/parentModel.dart';
import 'package:untitled2/screen/settingPage.dart';
import 'package:untitled2/widget/feedContainerBoth.dart';
import '../bottomNavigationMenu.dart';
import '../constants/constants.dart';
import '../model/educatorModel.dart';
import '../model/feedModel.dart';
import '../services/databaseServices.dart';


class MainScreen extends StatefulWidget {
  final String? currentUserId;


  const MainScreen({required this.currentUserId});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List _followingFeeds = [];
  bool _loading = false;
  // List<Feed> _allFeeds = []; // Add a list to store all feeds
  List<QueryDocumentSnapshot> feedItems = [];

  buildFeeds(Feed feed, {ParentModel? parent, EducatorModel? edu}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: FeedContainerBoth(
        feed: feed,
        parent: parent,
        edu: edu,
        currentUserId: widget.currentUserId,
        users: [],
      ),
    );
  }
  Widget showFeeds(Feed feed) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('parents').doc(feed.authorId).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData && snapshot.data != null) {
          DocumentSnapshot parentData = snapshot.data!;
          if (parentData.exists && parentData['role'] == 'parent') {
            ParentModel parent = ParentModel.fromDoc(parentData);
            parent.id = feed.authorId;
            return buildFeeds(feed, parent: parent);
          } else {
            // If not a parent, check educators collection
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('educators').doc(feed.authorId).get(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> eduSnapshot) {
                if (eduSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (eduSnapshot.hasData && eduSnapshot.data != null) {
                  DocumentSnapshot eduData = eduSnapshot.data!;
                  if (eduData.exists && eduData['role'] == 'educator') {
                    EducatorModel edu = EducatorModel.fromDoc(eduData);
                    edu.id = feed.authorId;
                    return buildFeeds(feed, edu: edu);
                  }
                }
                // If not found in educators collection, return empty SizedBox
                return SizedBox.shrink();
              },
            );
          }
        }
        // If no data or conditions don't match, return empty SizedBox
        return SizedBox.shrink();
      },
    );
  }


  Future<void> setupFollowingFeeds() async {
    setState(() {
      _loading = true;
    });

    // Fetch feeds directly from Firestore
    List _allFeeds = await DatabaseServices.retrieveSubFeeds();

    if (mounted) {
      setState(() {
        _loading = false;
      });

      // Set the fetched feeds directly to _followingFeeds
      _followingFeeds = _allFeeds.toList(); // Assuming all fetched feeds are to be followed

    }
  }

  @override
  void initState() {
    super.initState();
    setupFollowingFeeds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: AutiTrackColor2,
        elevation: 0.5,
        centerTitle: true,
        leading: Container(
          height: 40,
        ),
        title: Text(
          'Community',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => setupFollowingFeeds(),
        child: ListView(
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          children: [
            _loading ? LinearProgressIndicator() : SizedBox.shrink(),
            SizedBox(height: 5),
            Column(
              children: _followingFeeds.isEmpty && _loading == false
                  ? [
                SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    'There is No New Tweets',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                )
              ]
                  : _followingFeeds.map((feed) => showFeeds(feed)).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationMenu(
        selectedIndex: 0,
        onItemTapped: (index) {
          if (index == 2) {
            Navigator.pushReplacementNamed(context, '/graph');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/message');
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/activity');
          } else if (index == 4) {
            Navigator.pushReplacementNamed(context, '/feedParent');
          }
        },
      ),
    );
  }
}