import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/model/educatorModel.dart';
import 'package:untitled2/screen/settingPage.dart';
import 'package:untitled2/widget/feedContainerBoth.dart';
import '../bottomNavigationMenu.dart';
import '../bottomNavigationMenuEdu.dart';
import '../constants/constants.dart';
import '../model/parentModel.dart';
import '../model/feedModel.dart';
import '../services/databaseServices.dart';

class MainScreenEdu extends StatefulWidget {
  final String? currentUserId;

  const MainScreenEdu({required this.currentUserId});

  @override
  _MainScreenEduState createState() => _MainScreenEduState();
}

class _MainScreenEduState extends State<MainScreenEdu> {
  List<Feed> _allFeeds = []; // Added a list to store all feeds
  List<Feed> _followingFeeds = [];
  bool _loading = false;
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setupFollowingFeeds();
    });
  }

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
                return SizedBox.shrink();
              },
            );
          }
        }
        return SizedBox.shrink();
      },
    );
  }

  Future<void> setupFollowingFeeds() async {
    setState(() {
      _loading = true;
    });

    // Fetch all feeds and filter them based on following
    _allFeeds = await DatabaseServices.retrieveSubFeeds();
    _followingFeeds = _allFeeds; // Initially set to all feeds

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  // Function to filter feeds by text
  void _filterFeeds(String query) {
    if (query.isNotEmpty) {
      List<Feed> filteredFeeds = _allFeeds
          .where((feed) =>
          feed.text.toLowerCase().contains(query.toLowerCase()))
          .toList();

      setState(() {
        _followingFeeds = filteredFeeds;
      });
    } else {
      // If the search query is empty, reset the feeds to the original list
      setState(() {
        _followingFeeds = _allFeeds;
      });
    }
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
        title: _loading
            ? CircularProgressIndicator()
            : _isSearching
            ? TextField(
          controller: _searchController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search by Text...',
            hintStyle: TextStyle(color: Colors.black),
          ),
          style: TextStyle(fontSize: 17, letterSpacing: 0.5),
          onChanged: (query) {
            _filterFeeds(query);
          },
        )
            : Text(
          'Community',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              print("Navigating to SettingPage with currentUserId: ${widget.currentUserId}");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SettingPage(currentUserId: widget.currentUserId)
                  )
              );
            },
          ),
        ],
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
      bottomNavigationBar: BottomNavigationMenuEdu(
        selectedIndex: 0,
        onItemTapped: (index) {
          if (index == 1) {
            Navigator.pushReplacementNamed(context, '/messages');
          }  else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/feedEdu');
          }
          else if (index == 0) {
            Navigator.pushReplacementNamed(context, '/mainScreenEdu');
          }
        },
      ),
    );
  }
}