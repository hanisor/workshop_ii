/*
import 'package:flutter/material.dart';
import 'package:untitled2/model/parentModel.dart';
import 'package:untitled2/screen/addFeedPage.dart';
import 'package:untitled2/screen/parentProfilePage.dart';
import '../bottomNavigationMenu.dart';
import '../constants/constants.dart';
import '../model/feedModel.dart';
import '../services/databaseServices.dart';
import '../widget/feedContainerPersonalPage.dart';
import '../widget/userDetailsContainer.dart';


class MainFeedPageParent extends StatefulWidget {
  final String? currentUserId;


  const MainFeedPageParent({required this.currentUserId});

  @override
  _MainFeedPageParentState createState() => _MainFeedPageParentState();
}

class _MainFeedPageParentState extends State<MainFeedPageParent> {
  List<Feed> _followingFeeds = [];
  bool _loading = false;
  ParentModel? _parent;
  bool _userDetailsDisplayed = false;

  buildFeeds(Feed feed, ParentModel parent) {
    print("_userDetailsDisplayed value: $_userDetailsDisplayed");

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_userDetailsDisplayed)
            UserDetailsContainer(parent: _parent),
          SizedBox(height: 10),
          FeedContainerPersonalPage(
            feed: feed,
            parent: parent,
            currentUserId: widget.currentUserId,
            users: [],
            isParent: true,
            isEdu: false,
          ),
        ],
      ),
    );
  }


  showFeeds(String? currentUserId) {
    List<Widget> followingFeedsList = [];
    for (Feed feed in _followingFeeds) {
      followingFeedsList.add(FutureBuilder(
          future: parentRef.doc(feed.authorId).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              ParentModel author = ParentModel.fromDoc(snapshot.data);
              author.id = feed.authorId;
              return buildFeeds(feed, author);
            } else {
              return SizedBox.shrink();
            }
          }));
    }
    return followingFeedsList;
  }


  setupFollowingFeeds() async {
    setState(() {
      _loading = true;
    });
    List<Feed> followingFeeds =
    await DatabaseServices.getUserFeeds(widget.currentUserId);
    if (mounted) {
      setState(() {
        _followingFeeds = followingFeeds;
        _loading = false;
      });
    }
  }



  @override
  void initState() {
    super.initState();
    setupFollowingFeeds();
    fetchParentDetails(); // Fetch parent details only once

  }

  Future<void> fetchParentDetails() async {
    // Fetch parent details
    DatabaseServices databaseServices = DatabaseServices();
    _parent = await databaseServices.fetchParentDetails(widget.currentUserId);

    if (_parent != null) {
      setState(() {
        _userDetailsDisplayed = true; // Set to true after fetching details
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddFeedPage(
                        currentUserId: widget.currentUserId,
                      )));
        }, child: const Icon(Icons.add),

      ),
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[200],
        elevation: 0.5,
        centerTitle: true,
        leading: Container(
          height: 40,
        ),
        title: Text(
          'Feeds',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Navigate to the parent profile page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ParentProfilePage(
                    userId: widget.currentUserId, currentUserId: '',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_userDetailsDisplayed && _parent != null)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.lightGreen[200],
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(_parent!.parentProfilePicture),
                    ),
                    SizedBox(width: 30),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _parent!.parentName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            _parent!.parentFullName,
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.grey[900],
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            _parent!.parentEmail,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            _parent!.role,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Divider(height: 20, thickness: 2, color: Colors.grey),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => setupFollowingFeeds(),
              child: ListView(
                physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                children: [
                  _loading ? LinearProgressIndicator() : SizedBox.shrink(),
                  SizedBox(height: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 5),
                      Column(
                        children: _followingFeeds.isEmpty && _loading == false
                            ? [
                          SizedBox(height: 5),
                          Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 25),
                            child: Text(
                              'There is No New Tweets',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          )
                        ]
                            : showFeeds(widget.currentUserId),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationMenu(
        selectedIndex: 4,
        onItemTapped: (index) {
          if (index == 2) {
            Navigator.pushReplacementNamed(context, '/graph');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/message');
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/activity');
          } else if (index == 0) {
            Navigator.pushReplacementNamed(context, '/mainScreen');
          }else if (index == 4) {
            Navigator.pushReplacementNamed(context, '/feedParent');
          }
        },
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:untitled2/model/educatorModel.dart';
import 'package:untitled2/screen/addFeedPage.dart';
import 'package:untitled2/screen/parentProfilePage.dart';
import '../bottomNavigationMenu.dart';
import '../bottomNavigationMenuEdu.dart';
import '../constants/constants.dart';
import '../model/feedModel.dart';
import '../model/parentModel.dart';
import '../services/databaseServices.dart';
import '../widget/feedContainerPersonalPage.dart';
import '../widget/userDetailsContainer.dart';
import 'educatorProfilePage.dart';


class MainFeedPageParent extends StatefulWidget {
  final String? currentUserId;


  const MainFeedPageParent({required this.currentUserId});

  @override
  _MainFeedPageParentState createState() => _MainFeedPageParentState();
}

class _MainFeedPageParentState extends State<MainFeedPageParent> {
  List<Feed> _followingFeeds = [];
  bool _loading = false;
  ParentModel? _parent;
  bool _userDetailsDisplayed = false;

  buildFeeds(Feed feed, ParentModel parent) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*if (!_userDetailsDisplayed)
            UserDetailsContainer(edu: _edu),*/
          SizedBox(height: 10),
          FeedContainerPersonalPage(
            feed: feed,
            parent: parent,
            currentUserId: widget.currentUserId,
            users: [],
            isParent: true,
            isEdu: false,
          ),
        ],
      ),
    );
  }

  showFeeds(String? currentUserId) {
    List<Widget> followingFeedsList = [];
    for (Feed feed in _followingFeeds) {
      followingFeedsList.add(FutureBuilder(
          future: parentRef.doc(feed.authorId).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              ParentModel author = ParentModel.fromDoc(snapshot.data);
              author.id = feed.authorId;
              return buildFeeds(feed, author);
            } else {
              return SizedBox.shrink();
            }
          }));
    }
    return followingFeedsList;
  }


  setupFollowingFeeds() async {
    setState(() {
      _loading = true;
    });
    List<Feed> followingFeeds =
    await DatabaseServices.getUserFeeds(widget.currentUserId);
    if (mounted) {
      setState(() {
        _followingFeeds = followingFeeds;
        _loading = false;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    setupFollowingFeeds();
    fetchEducatorDetails(); // Fetch parent details only once

  }
  Future<void> fetchEducatorDetails() async {
    // Fetch parent details
    DatabaseServices databaseServices = DatabaseServices();
    _parent = await databaseServices.fetchParentDetails(widget.currentUserId);

    if (_parent != null) {
      setState(() {
        _userDetailsDisplayed = true; // Set to true after fetching details
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddFeedPage(
                        currentUserId: widget.currentUserId,
                      )));
        }, child: const Icon(Icons.add),

      ),
      appBar: AppBar(
        backgroundColor: AutiTrackColor2,
        elevation: 0.5,
        centerTitle: true,
        leading: Container(
          height: 40,
        ),
        title: Text(
          'Feeds',
          style: TextStyle(
            color: Colors.black,
          ),
        ),  actions: [
        IconButton(
          icon: Icon(Icons.person),
          onPressed: () {
            // Navigate to the parent profile page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ParentProfilePage(
                  userId: widget.currentUserId, currentUserId: '',
                ),
              ),
            );
          },
        ),
      ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_userDetailsDisplayed && _parent != null)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: AutiTrackColor2,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(_parent!.parentProfilePicture),
                    ),
                    SizedBox(width: 30),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _parent!.parentName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            _parent!.parentFullName,
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.grey[900],
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            _parent!.parentEmail,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            _parent!.role,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Divider(height: 20, thickness: 2, color: Colors.grey),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => setupFollowingFeeds(),
              child: ListView(
                physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                children: [
                  _loading ? LinearProgressIndicator() : SizedBox.shrink(),
                  SizedBox(height: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 5),
                      Column(
                        children: _followingFeeds.isEmpty && _loading == false
                            ? [
                          SizedBox(height: 5),
                          Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 25),
                            child: Text(
                              'There is No New Tweets',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          )
                        ]
                            : showFeeds(widget.currentUserId),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationMenu(
        selectedIndex: 4,
        onItemTapped: (index) {
          if (index == 2) {
            Navigator.pushNamed(context, '/graph');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/message');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/activity');
          } else if (index == 0) {
            Navigator.pushNamed(context, '/mainScreen');
          } else if (index == 4) {
            Navigator.pushNamed(context, '/feedParent');
          }
        },

      ),
    );
  }
}